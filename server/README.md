# Fresh Fadez API

The booking backend for **After8 Hair Salon**, 123 Willows Street,
Bloemfontein — one salon, one app, three kinds of user (clients, stylists, the
owner).

Node + Express + TypeScript, PostgreSQL via Prisma, Zod for request
validation, JWT access/refresh tokens, Argon2id password hashing. Built with
`tsc`, tested with `node --test`.

Two things are worth reading before anything else, because they are where the
real decisions live:

- **[`src/availability/engine.ts`](src/availability/engine.ts)** — the slot
  calculation, as a pure function. Plain data in, slots out. No database, no
  Express, no `new Date()`.
- **[`prisma/migrations/20261123143000_appointment_no_overlap/migration.sql`](prisma/migrations/20261123143000_appointment_no_overlap/migration.sql)**
  — the PostgreSQL exclusion constraint that makes double-booking impossible.

---

## Local setup

### 1. PostgreSQL

The API needs a real PostgreSQL (version 14 or newer) because it relies on
`btree_gist` and exclusion constraints. SQLite will not do.

**macOS, Homebrew:**

```bash
brew install postgresql@17 && brew services start postgresql@17
```

Add it to your `PATH` if `psql` is not found — Homebrew keeps versioned
formulae out of the way:

```bash
export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
```

**Docker, if you would rather not install it:**

```bash
docker run --name fresh-fadez-pg -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d postgres:17
```

Then create the two databases — one to develop against, one for the tests to
write to and clean up after:

```bash
createdb fresh_fadez && createdb fresh_fadez_test
```

### 2. Configure

```bash
cp .env.example .env
```

Open `.env` and set `DATABASE_URL` and `TEST_DATABASE_URL` to match your
Postgres (a Homebrew install usually wants your own username and no password;
the Docker command above wants `postgres:postgres`). Generate the two JWT
secrets:

```bash
node -e "console.log(require('crypto').randomBytes(48).toString('base64url'))"
```

Every booking rule — lead time, slot granularity, how far ahead the diary is
open, the cancellation window — is an environment variable in there, with the
reasoning next to it.

### 3. Install, migrate, seed

```bash
npm install
```

```bash
npx prisma migrate deploy && npm run seed
```

`migrate deploy` creates the schema, the `btree_gist` extension and the
exclusion constraints. `npm run seed` loads the real salon: the four services
at their real prices, the four stylists with their rosters, 09:00–20:00 opening
hours (closed Sundays), and two test logins.

### 4. Run

```bash
npm run dev
```

It listens on `http://localhost:8080` and prints the port. `GET /` is a health
check that touches no database.

### 5. Test

```bash
npm test
```

41 tests. The availability engine tests need nothing but Node. The
concurrency tests need `TEST_DATABASE_URL` pointing at a migrated database —
without it they skip with a message rather than failing, so `npm test` works
on a laptop that has never run Postgres. Apply the migrations to the test
database once:

```bash
DATABASE_URL="$TEST_DATABASE_URL" npx prisma migrate deploy
```

### Test logins

Created by the seed script, which refuses to run with `NODE_ENV=production`.
Password for all of them: `Password123!`

| Role | Email |
| --- | --- |
| Client | `client@freshfadez.test` |
| Owner (also a bookable stylist) | `jabulile@after8salon.co.za` |
| Stylist | `oscar@after8salon.co.za` |

### Other commands

| Command | What it does |
| --- | --- |
| `npm run build` | `prisma generate` then `tsc` into `dist/` |
| `npm run typecheck` | `tsc --noEmit` |
| `npm run migrate` | `prisma migrate dev` — create and apply a new migration |
| `npm run db:reset` | Drop, re-migrate and re-seed. Destroys local data |
| `npm run seed` | Re-run the seed (idempotent — safe to repeat) |

---

## How availability is calculated

`GET /availability` is the endpoint the booking screen is built around. For a
requested service, date and (optionally) stylist, the slots are:

```
  salon opening hours for that weekday          when the doors are open
∩ the stylist's working hours for that weekday  when they are rostered
− their time off                                leave, training
− their non-cancelled appointments              the chair is occupied
= free time
```

Free time is then walked on a fixed grid (`SLOT_GRANULARITY_MINUTES`, default
15) and a slot is offered only where the **whole** service duration fits inside
one free span, and starts no sooner than `MIN_BOOKING_LEAD_MINUTES` from now.
So a 90-minute colour is not offered at 19:00 when the salon shuts at 20:00.

The grid is anchored to each free span's own start rather than to midnight, so
a stylist rostered from 09:10 is offered 09:10, 09:25, … rather than nothing.

`stylistId` is optional. Omitted, each slot lists every qualified stylist who
could take it, which is what lets the app offer "anyone" and still book a
named person once the client picks one.

All of this lives in [`src/availability/engine.ts`](src/availability/engine.ts)
as a pure function, and [`src/availability/service.ts`](src/availability/service.ts)
is the thin layer that fetches the rows and converts timezones. That split is
why "closed on Sunday" and "the booking at 13:00 blocks 12:30" are each a
four-line test.

### Timezone

The salon is in one place, and that place has no daylight saving:
Africa/Johannesburg is UTC+2 all year. So the offset is a single number,
`SALON_UTC_OFFSET_MINUTES`, not a tz database. Opening hours are stored as
minutes from local midnight (09:00 is `540`); appointments are stored as real
`timestamptz` instants. Only `src/lib/time.ts` converts between the two.

---

## How double-booking is prevented

Not by checking. A handler that reads "is 10:00 free?" and then writes the
booking has a gap between the two, and two phones tapping the same slot both
read "free" and both write. That is not a rare race — it is what happens when
the salon posts a promotion.

The guarantee is a PostgreSQL exclusion constraint:

```sql
EXCLUDE USING gist (
  "stylistId" WITH =,
  tstzrange("startsAt", "endsAt", '[)') WITH &&
) WHERE ("status" <> 'CANCELLED' AND "status" <> 'NO_SHOW')
```

Two overlapping bookings for one stylist cannot both exist, whatever the
application does, in whatever order requests arrive, however many instances of
the server are running. The range is half-open (`[)`), so an appointment ending
at 10:00 and one starting at 10:00 do not conflict — the back-to-back case that
fills a salon's day. The `WHERE` clause means cancelling frees the slot with no
extra bookkeeping: the row simply leaves the constraint's scope.

A second constraint does the same from the client's side, so one person cannot
hold two appointments at once with two different stylists.

Three details that are easy to get wrong, and are each commented where they
matter:

- The timestamp columns are `@db.Timestamptz(3)`, not Prisma's default
  `timestamp(3)`. Over plain `timestamp`, building a `tstzrange` needs a cast
  PostgreSQL rates STABLE, and the constraint is rejected outright.
- The status literals in the predicate carry no `::"AppointmentStatus"` cast,
  because the enum input function is STABLE too and an index predicate admits
  only IMMUTABLE functions. An unadorned literal folds to a constant instead.
- PostgreSQL resolves *simultaneous* conflicting inserts against an exclusion
  constraint by **deadlocking**, not by raising `23P01` — there is no
  speculative-insertion path as there is for unique indexes. So every write
  goes through [`src/lib/booking-tx.ts`](src/lib/booking-tx.ts), which takes a
  transaction-scoped advisory lock on the stylist and then the client (always
  that order, so the locks cannot deadlock either) and retries on `40P01`. The
  lock turns the race into a queue; the constraint is still what guarantees
  correctness.

A losing booking always comes back as **409 `SLOT_TAKEN`**, whether it lost
before it read availability or inside the write, so the app has one case to
handle: *"that slot was just taken."*

This is covered by [`test/concurrency.test.mjs`](test/concurrency.test.mjs),
which starts the real app on an ephemeral port and fires two — then eight —
simultaneous bookings at one slot, asserting exactly one wins.

---

## API

Base URL: `http://localhost:8080`. All bodies and responses are JSON.

**Conventions the Flutter data layer can rely on everywhere:**

- Instants are ISO 8601 UTC strings: `"2026-12-04T07:00:00.000Z"`.
- Money is `priceCents`, an integer in ZAR cents. R45,00 is `4500`. Never a
  formatted string, never a float.
- Durations are whole minutes. Times of day come as both a minute count and an
  `"HH:MM"` label.
- Dates are `"YYYY-MM-DD"`, salon-local.
- Weekdays are `0`–`6`, Sunday to Saturday.
- Authenticated requests send `Authorization: Bearer <accessToken>`.

**Every error has the same shape:**

```json
{ "error": { "code": "SLOT_TAKEN", "message": "That time was just booked by someone else. Please pick another slot.", "details": { } } }
```

`message` is written to be shown to a client on a phone. `code` is the stable
value to branch on. `details` appears on validation failures as
`{ "field": ["message"] }`.

### Error codes

| Status | Code | Meaning |
| --- | --- | --- |
| 400 | `BAD_REQUEST` | Malformed request the schema could not express |
| 400 | `MALFORMED_JSON` | Body is not valid JSON |
| 401 | `TOKEN_MISSING` / `TOKEN_INVALID` | No or unusable access token — sign out |
| 401 | `TOKEN_EXPIRED` | Access token expired — call `/auth/refresh` |
| 401 | `INVALID_CREDENTIALS` | Wrong email or password |
| 401 | `REFRESH_TOKEN_INVALID` | Refresh token expired, revoked, or already rotated |
| 401 | `RESET_TOKEN_INVALID` | Password-reset link expired or already used |
| 403 | `FORBIDDEN` | Signed in, but not allowed to do that |
| 404 | `NOT_FOUND` | No such record or endpoint |
| 409 | `SLOT_TAKEN` | **The slot is gone. Offer the client another one** |
| 409 | `CLIENT_DOUBLE_BOOKED` | They already have an appointment at that time |
| 409 | `ALREADY_EXISTS` | Unique field collision |
| 422 | `VALIDATION_FAILED` | Field-level errors in `details` |
| 422 | `SLOT_NOT_AVAILABLE` | That time is not on offer — refresh availability |
| 422 | `SALON_CLOSED` | The salon is shut that day |
| 422 | `DATE_IN_PAST` / `DATE_TOO_FAR_AHEAD` | Outside the open diary |
| 422 | `CANCELLATION_WINDOW_PASSED` | Too late for a client to cancel |
| 422 | `APPOINTMENT_CLOSED` | Already completed, cancelled or a no-show |
| 422 | `INVALID_TRANSITION` | That status change is not legal from here |
| 422 | `NOT_COMPLETED` / `ALREADY_REVIEWED` | Review preconditions |
| 500 | `INTERNAL` | Logged server-side with detail; opaque to the client |

### Auth

#### `POST /auth/register` → 201

Always creates a **CLIENT**. A `role` field would be a public endpoint handing
out the owner's privileges, so there is none.

```json
{ "email": "thabo@example.com", "password": "Password123!", "fullName": "Thabo Mokoena", "phone": "+27 82 555 0101" }
```

Response — the same envelope as `/auth/login` and `/auth/refresh`:

```json
{
  "user": {
    "id": "uuid", "email": "thabo@example.com", "fullName": "Thabo Mokoena",
    "phone": "+27 82 555 0101", "role": "CLIENT",
    "createdAt": "2026-11-24T06:26:36.433Z", "stylistId": null
  },
  "accessToken": "eyJ…",
  "refreshToken": "wb5Y4Wwvi…",
  "accessTokenExpiresIn": 1800,
  "refreshTokenExpiresAt": "2026-12-24T06:26:36.489Z"
}
```

`accessTokenExpiresIn` is seconds. `user.stylistId` is non-null for staff and
is what the staff screens key off.

#### `POST /auth/login` → 200

`{ "email": "…", "password": "…" }` → the session envelope above.

#### `POST /auth/refresh` → 200

`{ "refreshToken": "…" }` → a **new** session envelope with a new refresh
token. The presented token is revoked as the replacement is issued, so each
one works exactly once; replaying a rotated token gives 401
`REFRESH_TOKEN_INVALID`.

#### `POST /auth/logout` → 200

`{ "refreshToken": "…" }` → `{ "ok": true }`. Idempotent.

#### `POST /auth/forgot-password` → 200

`{ "email": "…" }` → always the same answer, whether or not the address
exists, so it cannot be used to enumerate the salon's client list:

```json
{ "ok": true, "message": "If that email is registered, a reset link is on its way." }
```

Outside production the response also carries `resetToken`, because no mail
provider is wired up yet and a reset flow nobody can test is a reset flow that
does not work. **Sending the email is the one piece of auth still to build.**

#### `POST /auth/reset-password` → 200

`{ "token": "…", "password": "NewPassword123!" }` → `{ "ok": true, "message": … }`.
Signs every device out, which is what someone resetting a compromised account
expects.

#### `GET /auth/me` → 200 *(auth)*

The `user` object above, including `stylistId`.

### Catalogue (public)

#### `GET /salon` → 200

Everything the app needs before a date is chosen — name, address, phone,
opening hours for all seven days, the booking rules, and the open date range.

```json
{
  "salon": { "name": "After8 Hair Salon", "brand": "Fresh Fadez", "address": "123 Willows Street, Bloemfontein", "phone": "+27 (51) 123-4567", "currency": "ZAR" },
  "businessHours": [ { "weekday": 0, "isClosed": true, "openMinute": 540, "closeMinute": 1200, "openTime": "09:00", "closeTime": "20:00" } ],
  "rules": { "slotStepMinutes": 15, "leadTimeMinutes": 120, "maxDaysAhead": 60, "cancellationWindowHours": 4, "utcOffsetMinutes": 120 },
  "bookingWindow": { "firstDate": "2026-11-24", "lastDate": "2027-01-23" }
}
```

#### `GET /services` → 200

Query: `category`, `includeInactive=true`.

```json
{ "services": [ {
  "id": "uuid", "name": "Hair Cutting", "description": "Professional haircut with styling",
  "category": "Hair Services", "priceCents": 4500, "durationMinutes": 45,
  "imageAsset": "assets/images/haircut.jpg", "active": true, "stylistIds": ["uuid"]
} ] }
```

#### `GET /services/:id` → 200

One service, same shape.

#### `GET /stylists` → 200

Query: `serviceId` (only those who perform it), `includeInactive=true`.

```json
{ "stylists": [ {
  "id": "uuid", "userId": "uuid", "fullName": "Jabulile Mashibini",
  "title": "Senior Stylist", "specialization": "Hair Cutting & Coloring",
  "bio": "Eight years behind the chair…", "experienceYears": 8,
  "rating": 4.9, "reviewCount": 156,
  "imageAsset": "assets/images/staff_sarah.jpg", "active": true,
  "services": [ { "id": "uuid", "name": "Hair Cutting", "priceCents": 4500, "durationMinutes": 45, "…": "…" } ]
} ] }
```

#### `GET /stylists/:id` → 200

The same object plus `schedule` (their weekly hours) and `reviews` (the ten
most recent):

```json
{
  "…": "…",
  "schedule": [ { "weekday": 2, "startMinute": 540, "endMinute": 780, "startTime": "09:00", "endTime": "13:00" } ],
  "reviews": [ { "id": "uuid", "appointmentId": "uuid", "stylistId": "uuid", "rating": 5, "comment": "Spot on.", "createdAt": "2026-11-24T06:28:32.344Z", "authorName": "Thabo Mokoena" } ]
}
```

### Availability (public)

#### `GET /availability?serviceId=&date=&stylistId=` → 200

`stylistId` is optional. `date` is `YYYY-MM-DD`.

```json
{
  "date": "2026-11-28",
  "service": { "id": "uuid", "name": "Hair Cutting", "durationMinutes": 45, "priceCents": 4500 },
  "rules": { "slotStepMinutes": 15, "leadTimeMinutes": 120, "maxDaysAhead": 60 },
  "reason": null,
  "slots": [
    { "startsAt": "2026-11-28T07:00:00.000Z", "endsAt": "2026-11-28T07:45:00.000Z", "label": "09:00", "stylistIds": ["uuid"] },
    { "startsAt": "2026-11-28T07:15:00.000Z", "endsAt": "2026-11-28T08:00:00.000Z", "label": "09:15", "stylistIds": ["uuid", "uuid"] }
  ]
}
```

`label` is the salon-local `HH:MM` to put on the chip, so the app need not
re-derive the timezone. `stylistIds` are the stylists free for that whole slot.

When `slots` is empty, `reason` says why — show it instead of a blank day:

| `reason` | Meaning |
| --- | --- |
| `SALON_CLOSED` | Closed that weekday |
| `NO_STYLIST_FOR_SERVICE` | Nobody performs that service |
| `NO_STYLIST_WORKING` | Nobody is rostered that day |
| `FULLY_BOOKED` | Rostered, but nothing left — try another day |

`reason` is `null` whenever `slots` is non-empty.

### Appointments *(all require auth)*

#### `POST /appointments` → 201

```json
{ "serviceId": "uuid", "stylistId": "uuid", "startsAt": "2026-11-28T07:00:00.000Z", "notes": "First visit" }
```

`stylistId` is optional — omit it and the salon assigns a qualified stylist who
is free. `startsAt` must be a slot `GET /availability` offers.

Price and duration are copied from the service at booking time, so repricing
the catalogue tomorrow does not reprice bookings already in the diary.

Response — the appointment object used everywhere:

```json
{
  "id": "uuid", "status": "PENDING",
  "startsAt": "2026-11-28T07:00:00.000Z", "endsAt": "2026-11-28T07:45:00.000Z",
  "durationMinutes": 45, "priceCents": 4500, "notes": "First visit",
  "createdAt": "2026-11-24T06:26:37.722Z",
  "cancelledAt": null, "cancellationReason": null,
  "serviceId": "uuid", "stylistId": "uuid", "userId": "uuid",
  "service": { "id": "uuid", "name": "Hair Cutting", "priceCents": 4500, "durationMinutes": 45, "…": "…" },
  "stylist": { "id": "uuid", "fullName": "Jabulile Mashibini", "title": "Senior Stylist", "imageAsset": "assets/images/staff_sarah.jpg" },
  "client": { "id": "uuid", "fullName": "Thabo Mokoena", "phone": "+27 82 555 0101", "email": "thabo@example.com" }
}
```

The `client` block is present only for staff — a client does not need their own
details echoed back. `review` appears on list and detail reads, `null` until
one is written.

Errors: **409 `SLOT_TAKEN`** (someone took it), **409 `CLIENT_DOUBLE_BOOKED`**,
422 `SLOT_NOT_AVAILABLE` (off-grid, outside hours, stylist not rostered or not
qualified), 422 `SALON_CLOSED`, 422 `DATE_IN_PAST`, 422 `DATE_TOO_FAR_AHEAD`.

#### `GET /appointments` → 200

Scoped by role in middleware: a client sees their own; a stylist sees their
chair plus anything they booked as a client themselves; the owner sees the
whole diary.

Query: `status` (comma-separated), `from`, `to` (`YYYY-MM-DD`, inclusive),
`scope` (`upcoming` | `past` | `all`), `limit` (default 50, max 200), `cursor`,
and — owner only — `stylistId`, `userId`.

```json
{ "appointments": [ { "…": "appointment objects" } ], "nextCursor": "uuid-or-null" }
```

Sorted ascending by `startsAt`, except `scope=past` which is descending. Pass
`nextCursor` back as `cursor` for the next page.

#### `GET /appointments/:id` → 200

One appointment, including `review`.

#### `PATCH /appointments/:id` → 200 — reschedule

```json
{ "startsAt": "2026-11-28T09:00:00.000Z", "stylistId": "uuid", "notes": "…" }
```

Every field optional; at least one required. Changing `startsAt` or
`stylistId` re-checks availability (ignoring this booking, so it does not block
its own new time) and resets `status` to `PENDING` — the stylist agreed to the
old time, not this one. `notes` alone skips the availability question.

Same conflict guarantee and the same errors as `POST`. 422
`APPOINTMENT_CLOSED` if it is already completed, cancelled or a no-show.

#### `POST /appointments/:id/cancel` → 200

```json
{ "reason": "Something came up" }
```

`reason` optional. Idempotent — cancelling twice returns the appointment. The
slot is bookable again the instant this returns.

Clients may not cancel inside `CANCELLATION_WINDOW_HOURS` (default 4) of the
start — 422 `CANCELLATION_WINDOW_PASSED`, with the salon's phone number in the
message. Staff and the owner may always cancel, because a stylist off sick at
8am has to be able to clear their day.

#### `POST /appointments/:id/review` → 201

```json
{ "rating": 5, "comment": "Spot on." }
```

`rating` is 1–5. Only the client who had the appointment, only once it is
`COMPLETED`, only once. The stylist's `rating` and `reviewCount` are
recomputed in the same transaction, so the displayed average can never
disagree with the reviews behind it.

### Staff *(STYLIST or OWNER)*

#### `POST /appointments/:id/confirm` → 200

`PENDING` → `CONFIRMED`.

#### `POST /appointments/:id/complete` → 200

`PENDING` or `CONFIRMED` → `COMPLETED`.

#### `POST /appointments/:id/no-show` → 200

`PENDING` or `CONFIRMED` → `NO_SHOW`. Frees the slot, like a cancellation.

All three: a stylist may only touch their own chair; the owner, anyone's.
Anything else is 422 `INVALID_TRANSITION`.

#### `GET /staff/agenda?date=&stylistId=` → 200

A stylist's morning view, in one call. `date` defaults to today. A stylist may
only see their own; the owner may pass `stylistId` or omit it for the whole
salon.

```json
{
  "date": "2026-11-28", "weekday": 6, "stylistId": "uuid-or-null",
  "businessHours": { "isClosed": false, "openTime": "09:00", "closeTime": "20:00" },
  "workingHours": [ { "stylistId": "uuid", "startTime": "09:00", "endTime": "15:00" } ],
  "appointments": [ { "…": "appointment objects, with the client block" } ],
  "timeOff": [ { "id": "uuid", "stylistId": "uuid", "startsAt": "…", "endsAt": "…", "reason": "Training" } ],
  "summary": {
    "total": 7, "booked": 6, "bookedMinutes": 330, "expectedRevenueCents": 62500,
    "byStatus": { "CONFIRMED": 5, "PENDING": 1, "CANCELLED": 1 }
  }
}
```

Cancellations and no-shows stay in `appointments` — a stylist wants to see that
the 14:00 cancelled rather than silently find a gap — but are excluded from
`booked`, `bookedMinutes` and `expectedRevenueCents`.

#### `GET /stylists/me` → 200, `PATCH /stylists/me` → 200

Read or update your own profile: `title`, `specialization`, `bio`,
`experienceYears`, `imageAsset`.

#### `PUT /stylists/me/schedule` → 200

Replaces the **whole week** atomically. A roster is read as a whole, and a
replace cannot leave the week half-updated if the connection drops.

```json
{ "schedule": [
  { "weekday": 2, "startMinute": 540, "endMinute": 780 },
  { "weekday": 2, "startMinute": 840, "endMinute": 1080 }
] }
```

Several rows may share a weekday — that is how a lunch break is expressed: two
shifts with a gap, and the gap is simply not offered. Overlapping shifts on one
day are rejected with 400.

```json
{ "stylistId": "uuid", "schedule": [ { "weekday": 2, "startMinute": 540, "endMinute": 780, "startTime": "09:00", "endTime": "13:00" } ] }
```

#### `GET /stylists/me/time-off` → 200

Upcoming time off only.

#### `POST /stylists/me/time-off` → 201

```json
{ "startsAt": "2026-12-01T07:00:00.000Z", "endsAt": "2026-12-01T12:00:00.000Z", "reason": "Training" }
```

Response includes `clashingAppointments` — bookings already in the diary across
that span. Non-empty means those clients still think they have an appointment,
so show it to the stylist rather than letting them find out on the day.

#### `DELETE /stylists/me/time-off/:id` → 200

### Owner only

#### `POST /services` → 201, `PATCH /services/:id` → 200

```json
{ "name": "Beard Trim", "description": "Shape and line up", "category": "Hair Services",
  "priceCents": 6500, "durationMinutes": 30, "imageAsset": null, "active": true,
  "stylistIds": ["uuid"] }
```

`PATCH` takes any subset. `stylistIds` **replaces** the set, so removing a
stylist from a service uses the same call that adds one.

#### `DELETE /services/:id` → 200

Deletes only if nothing references it. A service with past bookings is retired
instead (`active: false`), because history beats tidiness — the bookings that
used it keep their name and price:

```json
{ "…": "service", "deactivated": true, "message": "That service has past bookings, so it was retired rather than deleted." }
```

---

## Project layout

```
server/
├─ prisma/
│  ├─ schema.prisma                   models, with the reasoning in comments
│  └─ migrations/
│     ├─ …_init/                      the schema
│     └─ …_appointment_no_overlap/    the exclusion constraints — read this
├─ src/
│  ├─ config.ts                       every tunable number, from the environment
│  ├─ app.ts                          the Express app (no listen, so tests can mount it)
│  ├─ index.ts                        process entry, graceful shutdown
│  ├─ availability/
│  │  ├─ intervals.ts                 half-open interval arithmetic, pure
│  │  ├─ engine.ts                    the slot calculation, pure
│  │  └─ service.ts                   fetches the rows, converts timezones
│  ├─ lib/
│  │  ├─ time.ts                      local-time ↔ instant, pure
│  │  ├─ booking-tx.ts                advisory lock + deadlock retry
│  │  ├─ errors.ts                    ApiError and the conflict detectors
│  │  ├─ serialize.ts                 the wire shapes, in one place
│  │  ├─ tokens.ts                    JWT + rotating refresh tokens
│  │  ├─ password.ts                  Argon2id
│  │  ├─ http.ts                      asyncHandler, Zod parsing
│  │  └─ prisma.ts                    the single client
│  ├─ middleware/
│  │  ├─ auth.ts                      requireAuth, requireStaff, requireOwner
│  │  └─ error.ts                     the single exit for every failure
│  ├─ routes/                         auth, services, stylists, appointments, availability, staff
│  └─ scripts/seed.ts                 the real salon data
├─ test/
│  ├─ availability.test.mjs           34 tests, no database needed
│  └─ concurrency.test.mjs            7 tests, real HTTP + real Postgres
├─ .env.example
├─ render.yaml                        move to the repo root before deploying
└─ README.md
```

Responses never return Prisma rows directly — everything goes through
`src/lib/serialize.ts`. That is not ceremony: returning rows means
`passwordHash` ships the first time someone adds an `include`, and a column
rename silently becomes a breaking API change.

---

## Deploying

[`render.yaml`](render.yaml) is a Render blueprint: a free web service plus a
free managed Postgres, with `prisma migrate deploy` in the build so a deploy
applies migrations before the new code serves traffic. Render reads
`render.yaml` from the **repository root**, so move or symlink it there first —
`rootDir: server` is already written for that.

The JWT secrets are `generateValue: true`, so Render creates them and they are
never committed. In production the server refuses to boot without them rather
than falling back to a development default.

The first deploy has an empty database. Seed it once with `DATABASE_URL`
pointed at the Render database and `NODE_ENV` unset — the seed script refuses
to run in production, because it creates accounts with a known password.
Change those passwords before anyone real uses the app.

---

## Still to do

- **Send the password-reset email.** The token is generated, hashed, stored and
  honoured; there is just no mail provider, so outside production the token
  comes back in the response. See the `TODO` in `src/routes/auth.ts`.
- **Push notifications** for confirmations and reminders.
- **Rate limiting** on `/auth/login` and `/auth/forgot-password`. The endpoints
  are written not to leak whether an account exists, but nothing yet slows down
  repeated attempts.
