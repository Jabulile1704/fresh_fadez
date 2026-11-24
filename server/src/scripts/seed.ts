/**
 * Seeds the real salon.
 *
 * Every name, price and duration here is lifted from the app's own
 * `lib/screens/home_screen.dart`, where it was hardcoded in a
 * `List<Map<String, dynamic>>`. Moving it into the database verbatim means the
 * revamped app shows exactly what the prototype showed on day one, so the
 * change the owner sees is that booking works — not that the prices moved.
 *
 * Idempotent: every write is an upsert keyed on something stable (email, name,
 * weekday), so running this twice is harmless. That matters because it is also
 * the fastest way to add a service the owner asked for, and because
 * `npm run db:reset` runs it unattended.
 *
 *   npm run seed
 */
import { Role } from '@prisma/client';

import { Config } from '../config';
import { hashPassword } from '../lib/password';
import { disconnect, prisma } from '../lib/prisma';
import { labelToMinuteOfDay } from '../lib/time';

/** Weekday constants, JavaScript numbering. */
const SUN = 0;
const MON = 1;
const TUE = 2;
const WED = 3;
const THU = 4;
const FRI = 5;
const SAT = 6;

/**
 * 9:00 AM – 8:00 PM, as the home screen states it. Closed Sundays: the
 * prototype did not say so, but a salon that is open seven days is unusual and
 * the owner can flip one row if it is wrong. It also makes the "closed day"
 * path real rather than theoretical.
 */
const BUSINESS_HOURS = [
  { weekday: SUN, isClosed: true, open: '09:00', close: '20:00' },
  { weekday: MON, isClosed: false, open: '09:00', close: '20:00' },
  { weekday: TUE, isClosed: false, open: '09:00', close: '20:00' },
  { weekday: WED, isClosed: false, open: '09:00', close: '20:00' },
  { weekday: THU, isClosed: false, open: '09:00', close: '20:00' },
  { weekday: FRI, isClosed: false, open: '09:00', close: '20:00' },
  { weekday: SAT, isClosed: false, open: '09:00', close: '20:00' },
];

/** Prices in cents: R45 is 4500. */
const SERVICES = [
  {
    name: 'Hair Cutting',
    category: 'Hair Services',
    description: 'Professional haircut with styling',
    priceCents: 4500,
    durationMinutes: 45,
    imageAsset: 'assets/images/haircut.jpg',
  },
  {
    name: 'Hair Coloring',
    category: 'Hair Services',
    description: 'Full color treatment with consultation',
    priceCents: 18500,
    durationMinutes: 90,
    imageAsset: 'assets/images/coloring.jpg',
  },
  {
    name: 'Facial Treatment',
    category: 'Skincare',
    description: 'Deep cleansing and rejuvenation',
    priceCents: 16500,
    durationMinutes: 60,
    imageAsset: 'assets/images/facial.jpg',
  },
  {
    name: 'Manicure & Pedicure',
    category: 'Nails',
    description: 'Full nail care and polish',
    priceCents: 15500,
    durationMinutes: 60,
    imageAsset: 'assets/images/nails.jpg',
  },
];

/**
 * The team, with the service each one performs — read off the `specialty`
 * field the prototype showed under each name.
 *
 * Lwando Ndulula's specialty is "Makeup & Bridal", which has no matching
 * service in the catalogue yet. Rather than invent a price, the profile is
 * seeded with no services attached: they appear in the team list and are
 * simply not offered by availability until the owner adds the service. That is
 * the honest state of the data, and it exercises the "no stylist for this
 * service" path for free.
 */
const STYLISTS = [
  {
    email: 'jabulile@after8salon.co.za',
    fullName: 'Jabulile Mashibini',
    phone: '+27 51 123 4567',
    title: 'Senior Stylist',
    specialization: 'Hair Cutting & Coloring',
    experienceYears: 8,
    rating: 4.9,
    reviewCount: 156,
    imageAsset: 'assets/images/staff_sarah.jpg',
    bio: 'Eight years behind the chair, specialising in precision cuts and full colour work.',
    services: ['Hair Cutting', 'Hair Coloring'],
    /** Tuesday to Saturday, with an hour off at one. */
    shifts: [
      { weekdays: [TUE, WED, THU, FRI], blocks: [['09:00', '13:00'], ['14:00', '18:00']] },
      { weekdays: [SAT], blocks: [['09:00', '15:00']] },
    ],
  },
  {
    email: 'oscar@after8salon.co.za',
    fullName: 'Oscar Poco',
    phone: '+27 51 123 4568',
    title: 'Beauty Specialist',
    specialization: 'Facial & Skincare',
    experienceYears: 6,
    rating: 4.7,
    reviewCount: 98,
    imageAsset: 'assets/images/staff_emma.jpg',
    bio: 'Six years in skincare, with a focus on deep-cleansing and rejuvenating facials.',
    services: ['Facial Treatment'],
    shifts: [
      { weekdays: [MON, TUE, WED, THU, FRI], blocks: [['10:00', '19:00']] },
    ],
  },
  {
    email: 'sebabatso@after8salon.co.za',
    fullName: 'Sebabatso Molelle',
    phone: '+27 51 123 4569',
    title: 'Nail Technician',
    specialization: 'Manicure & Pedicure',
    experienceYears: 5,
    rating: 4.8,
    reviewCount: 127,
    imageAsset: 'assets/images/staff_lisa.jpg',
    bio: 'Five years of nail care, from everyday polish to full sets.',
    services: ['Manicure & Pedicure'],
    shifts: [
      { weekdays: [WED, THU, FRI, SAT], blocks: [['09:00', '17:00']] },
    ],
  },
  {
    email: 'lwando@after8salon.co.za',
    fullName: 'Lwando Ndulula',
    phone: '+27 51 123 4570',
    title: 'Makeup Artist',
    specialization: 'Makeup & Bridal',
    experienceYears: 7,
    rating: 4.9,
    reviewCount: 142,
    imageAsset: 'assets/images/staff_jessica.jpg',
    bio: 'Seven years of makeup artistry, with a bridal portfolio across the Free State.',
    services: [],
    shifts: [
      { weekdays: [THU, FRI, SAT], blocks: [['11:00', '19:00']] },
    ],
  },
];

/**
 * Test logins, for the Flutter side and for curl.
 *
 * Deliberately obvious and deliberately weak. They are created outside
 * production only — see the guard in `main` — and the password is in the
 * README because a test account whose password is a secret is a test account
 * nobody uses.
 */
const TEST_PASSWORD = 'Password123!';
const TEST_CLIENT = {
  email: 'client@freshfadez.test',
  fullName: 'Thabo Mokoena',
  phone: '+27 82 555 0101',
};
/** Jabulile is also the owner — it is her salon. */
const OWNER_EMAIL = 'jabulile@after8salon.co.za';

async function main(): Promise<void> {
  if (Config.isProduction) {
    throw new Error(
      'Refusing to seed in production: this script creates accounts with a known password.',
    );
  }

  console.log(`Seeding ${Config.salon.name} (${Config.salon.address})`);

  // ---------------------------------------------------------- hours ---
  for (const row of BUSINESS_HOURS) {
    const data = {
      isClosed: row.isClosed,
      openMinute: labelToMinuteOfDay(row.open),
      closeMinute: labelToMinuteOfDay(row.close),
    };
    await prisma.businessHours.upsert({
      where: { weekday: row.weekday },
      create: { weekday: row.weekday, ...data },
      update: data,
    });
  }
  console.log(`  business hours: ${BUSINESS_HOURS.length} days`);

  // ------------------------------------------------------- services ---
  const serviceByName = new Map<string, string>();
  for (const service of SERVICES) {
    const row = await prisma.service.upsert({
      where: { name: service.name },
      create: { ...service, active: true },
      update: {
        description: service.description,
        category: service.category,
        priceCents: service.priceCents,
        durationMinutes: service.durationMinutes,
        imageAsset: service.imageAsset,
        active: true,
      },
    });
    serviceByName.set(service.name, row.id);
  }
  console.log(`  services: ${SERVICES.length}`);

  // ------------------------------------------------------- stylists ---
  const passwordHash = await hashPassword(TEST_PASSWORD);

  for (const person of STYLISTS) {
    const role = person.email === OWNER_EMAIL ? Role.OWNER : Role.STYLIST;

    const user = await prisma.user.upsert({
      where: { email: person.email },
      create: {
        email: person.email,
        passwordHash,
        fullName: person.fullName,
        phone: person.phone,
        role,
      },
      // The password is not reset on re-seed: someone may have changed it.
      update: { fullName: person.fullName, phone: person.phone, role },
    });

    const profile = {
      title: person.title,
      specialization: person.specialization,
      bio: person.bio,
      experienceYears: person.experienceYears,
      rating: person.rating,
      reviewCount: person.reviewCount,
      imageAsset: person.imageAsset,
      active: true,
    };
    const stylist = await prisma.stylist.upsert({
      where: { userId: user.id },
      create: { userId: user.id, ...profile },
      update: profile,
    });

    // Which services they perform — replaced wholesale, so removing one from
    // the list above removes it from the database on the next run.
    await prisma.stylistService.deleteMany({ where: { stylistId: stylist.id } });
    const serviceIds = person.services
      .map((name) => serviceByName.get(name))
      .filter((id): id is string => Boolean(id));
    if (serviceIds.length > 0) {
      await prisma.stylistService.createMany({
        data: serviceIds.map((serviceId) => ({ stylistId: stylist.id, serviceId })),
      });
    }

    // Their roster, likewise replaced wholesale.
    await prisma.stylistSchedule.deleteMany({ where: { stylistId: stylist.id } });
    const rows = person.shifts.flatMap((shift) =>
      shift.weekdays.flatMap((weekday) =>
        shift.blocks.map(([start, end]) => ({
          stylistId: stylist.id,
          weekday,
          startMinute: labelToMinuteOfDay(start),
          endMinute: labelToMinuteOfDay(end),
        })),
      ),
    );
    await prisma.stylistSchedule.createMany({ data: rows });

    console.log(
      `  ${role === Role.OWNER ? 'owner  ' : 'stylist'}: ${person.fullName} — ` +
        `${serviceIds.length} service(s), ${rows.length} shift block(s)`,
    );
  }

  // ----------------------------------------------------- test client ---
  await prisma.user.upsert({
    where: { email: TEST_CLIENT.email },
    create: { ...TEST_CLIENT, passwordHash, role: Role.CLIENT },
    update: { fullName: TEST_CLIENT.fullName, phone: TEST_CLIENT.phone },
  });

  console.log('\nTest logins (password for both: %s)', TEST_PASSWORD);
  console.log(`  client : ${TEST_CLIENT.email}`);
  console.log(`  staff  : ${OWNER_EMAIL}  (role OWNER — also a bookable stylist)`);
  console.log(`  stylist: oscar@after8salon.co.za  (role STYLIST)`);
  console.log('\nDone.');
}

main()
  .catch((error) => {
    console.error('Seed failed:', error);
    process.exitCode = 1;
  })
  .finally(disconnect);
