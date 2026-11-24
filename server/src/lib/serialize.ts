/**
 * The wire shapes, in one file.
 *
 * The Flutter data layer is written against exactly these objects, so every
 * response goes through a function here rather than returning a Prisma row
 * directly. That is not ceremony: returning rows means `passwordHash` ships
 * the first time someone adds an `include`, and it means a column rename
 * silently becomes a breaking API change.
 *
 * Conventions the app can rely on everywhere:
 *   * instants are ISO 8601 UTC strings (`2026-12-04T07:00:00.000Z`)
 *   * money is `priceCents` (integer, ZAR) and never a formatted string
 *   * times of day are both a minute count and an `HH:MM` label
 */
import type {
  Appointment,
  BusinessHours,
  Review,
  Service,
  Stylist,
  StylistSchedule,
  TimeOff,
  User,
} from '@prisma/client';

import { minuteOfDayToLabel } from './time';

export const userPublic = (user: User) => ({
  id: user.id,
  email: user.email,
  fullName: user.fullName,
  phone: user.phone,
  role: user.role,
  createdAt: user.createdAt.toISOString(),
});

export const servicePublic = (service: Service) => ({
  id: service.id,
  name: service.name,
  description: service.description,
  category: service.category,
  priceCents: service.priceCents,
  durationMinutes: service.durationMinutes,
  imageAsset: service.imageAsset,
  active: service.active,
});

type StylistWithUser = Stylist & {
  user?: Pick<User, 'id' | 'fullName' | 'email' | 'phone'> | null;
  services?: { service: Service }[];
  schedules?: StylistSchedule[];
};

export const stylistPublic = (stylist: StylistWithUser) => ({
  id: stylist.id,
  userId: stylist.userId,
  fullName: stylist.user?.fullName ?? null,
  title: stylist.title,
  specialization: stylist.specialization,
  bio: stylist.bio,
  experienceYears: stylist.experienceYears,
  rating: stylist.rating,
  reviewCount: stylist.reviewCount,
  imageAsset: stylist.imageAsset,
  active: stylist.active,
  ...(stylist.services
    ? { services: stylist.services.map((s) => servicePublic(s.service)) }
    : {}),
  ...(stylist.schedules ? { schedule: stylist.schedules.map(schedulePublic) } : {}),
});

export const schedulePublic = (row: StylistSchedule) => ({
  weekday: row.weekday,
  startMinute: row.startMinute,
  endMinute: row.endMinute,
  startTime: minuteOfDayToLabel(row.startMinute),
  endTime: minuteOfDayToLabel(row.endMinute),
});

export const businessHoursPublic = (row: BusinessHours) => ({
  weekday: row.weekday,
  isClosed: row.isClosed,
  openMinute: row.openMinute,
  closeMinute: row.closeMinute,
  openTime: minuteOfDayToLabel(row.openMinute),
  closeTime: minuteOfDayToLabel(row.closeMinute),
});

export const timeOffPublic = (row: TimeOff) => ({
  id: row.id,
  stylistId: row.stylistId,
  startsAt: row.startsAt.toISOString(),
  endsAt: row.endsAt.toISOString(),
  reason: row.reason,
});

type AppointmentWithRelations = Appointment & {
  service?: Service | null;
  stylist?: StylistWithUser | null;
  user?: Pick<User, 'id' | 'fullName' | 'email' | 'phone'> | null;
  review?: Review | null;
};

export const appointmentPublic = (appointment: AppointmentWithRelations) => ({
  id: appointment.id,
  status: appointment.status,
  startsAt: appointment.startsAt.toISOString(),
  endsAt: appointment.endsAt.toISOString(),
  durationMinutes: appointment.durationMinutes,
  priceCents: appointment.priceCents,
  notes: appointment.notes,
  createdAt: appointment.createdAt.toISOString(),
  cancelledAt: appointment.cancelledAt?.toISOString() ?? null,
  cancellationReason: appointment.cancellationReason,
  serviceId: appointment.serviceId,
  stylistId: appointment.stylistId,
  userId: appointment.userId,
  ...(appointment.service ? { service: servicePublic(appointment.service) } : {}),
  ...(appointment.stylist
    ? {
        stylist: {
          id: appointment.stylist.id,
          fullName: appointment.stylist.user?.fullName ?? null,
          title: appointment.stylist.title,
          imageAsset: appointment.stylist.imageAsset,
        },
      }
    : {}),
  // Clients never need the client block; staff always do, to know who is
  // walking in. Included whenever the caller asked for it.
  ...(appointment.user
    ? {
        client: {
          id: appointment.user.id,
          fullName: appointment.user.fullName,
          phone: appointment.user.phone,
          email: appointment.user.email,
        },
      }
    : {}),
  ...(appointment.review !== undefined
    ? { review: appointment.review ? reviewPublic(appointment.review) : null }
    : {}),
});

export const reviewPublic = (
  review: Review & { user?: Pick<User, 'fullName'> | null },
) => ({
  id: review.id,
  appointmentId: review.appointmentId,
  stylistId: review.stylistId,
  rating: review.rating,
  comment: review.comment,
  createdAt: review.createdAt.toISOString(),
  ...(review.user ? { authorName: review.user.fullName } : {}),
});
