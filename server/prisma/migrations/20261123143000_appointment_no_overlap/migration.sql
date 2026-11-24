-- Makes double-booking structurally impossible.
--
-- Everything else in this server could be wrong and two clients still could
-- not end up in the same chair at the same time, because the rule is enforced
-- by PostgreSQL rather than by application code.
--
-- Why not a read-then-write check in the handler? Because it races, and not
-- subtly: two phones tapping the same 10:00 slot both run "SELECT ... is it
-- free" (both see yes), then both INSERT. The window is milliseconds wide and
-- a promotion posted to the salon's Instagram is exactly the traffic that
-- finds it. Serialising the whole booking table would also work and would cost
-- every booking a lock; an exclusion constraint costs an index lookup and is
-- correct across any number of server instances.
--
-- How it works:
--
--   * `tstzrange(startsAt, endsAt, '[)')` turns the two timestamps into a
--     half-open range. Half-open is what makes an appointment ending at 10:00
--     and one starting at 10:00 *not* overlap — the back-to-back case that
--     fills a salon's day. `&&` is the range-overlap operator.
--   * `stylistId WITH =` scopes the rule: overlapping is only a conflict for
--     the same stylist. Two stylists working at once is the whole business.
--   * GiST is the index type, because btree cannot answer `&&`. `=` on a text
--     column is not a GiST operator either, which is what `btree_gist`
--     supplies — hence the extension.
--   * The WHERE clause makes it a partial constraint, so a cancelled or
--     no-show appointment stops occupying the chair. Cancelling frees the slot
--     with no extra bookkeeping: the row simply leaves the constraint's scope,
--     and the next availability call offers the time again. The predicate must
--     stay in step with `OCCUPYING_STATUSES` in src/availability/service.ts.
--
-- Note the bare 'CANCELLED' rather than 'CANCELLED'::"AppointmentStatus". An
-- index predicate may only contain IMMUTABLE functions, and the enum input
-- function `enum_in` is merely STABLE — so an explicit cast is rejected with
-- "functions in index expression must be marked IMMUTABLE". An unadorned
-- literal is coerced during parse analysis instead and arrives as a constant,
-- with no function call left to object to.
--
-- A rejected insert raises SQLSTATE 23P01, which the API turns into
-- 409 SLOT_TAKEN (see src/routes/appointments.ts).

CREATE EXTENSION IF NOT EXISTS btree_gist;

ALTER TABLE "Appointment"
  ADD CONSTRAINT "appointment_no_overlap"
  EXCLUDE USING gist (
    "stylistId" WITH =,
    tstzrange("startsAt", "endsAt", '[)') WITH &&
  )
  WHERE ("status" <> 'CANCELLED' AND "status" <> 'NO_SHOW');

-- The same rule from the client's side: one person cannot be in two chairs at
-- once. Without this, a client could book a 10:00 cut with one stylist and a
-- 10:00 facial with another — two valid rows by the constraint above, and two
-- appointments nobody can keep. The error is distinguished from the stylist
-- conflict by constraint name, so the app can say "you already have an
-- appointment then" rather than "that slot was just taken".
ALTER TABLE "Appointment"
  ADD CONSTRAINT "appointment_client_no_overlap"
  EXCLUDE USING gist (
    "userId" WITH =,
    tstzrange("startsAt", "endsAt", '[)') WITH &&
  )
  WHERE ("status" <> 'CANCELLED' AND "status" <> 'NO_SHOW');

-- A stylist's day, in start order — the query behind both the availability
-- engine's "what is already booked" read and the staff agenda. The exclusion
-- constraints' GiST indexes serve overlap tests, not ordered range scans, so
-- this btree index is not redundant with them.
CREATE INDEX IF NOT EXISTS "appointment_stylist_window_idx"
  ON "Appointment" ("stylistId", "startsAt", "endsAt");
