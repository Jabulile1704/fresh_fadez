# 💈 Fresh Fadez — Salon Booking App

A Flutter front-end prototype for a hair salon booking app. Clients sign in, browse services and the stylist team, and manage their appointments from a clean, animated mobile UI.

> **Status:** UI prototype. The screens run on sample data. Real authentication, a booking flow and a backend are the next milestones (see [Roadmap](#-roadmap)).

---

## ✨ Features

### Built
- **Login** — email/password form with validation and an animated login button (sign-in is simulated for now)
- **Home** — salon header, service cards, a preview of the team and quick actions for *Book Now* and *View Services*
- **Our Team** — stylist profiles with roles, shown as animated staff cards
- **My Appointments** — upcoming bookings with service, stylist, date, time, price (in Rand) and status, plus *Edit* and *Cancel* actions
- **Profile** — contact details, appointment and favourite-salon counts, settings menu and logout
- **Custom widgets** — a reusable widget library including spinning salon cards, service and staff cards, custom text fields and bottom navigation bars
- **Theming** — a central olive-and-beige colour palette and shared styles in `utils/constants.dart` and `utils/theme.dart`

### Data models
Typed Dart models for `Salon`, `Service`, `Stylist`, `Appointment` and `User`, including helpers such as formatted prices, durations and an `isUpcoming` check, ready to connect to a real data source.

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart, SDK >= 2.19) |
| UI | Material Design, custom animations (`AnimationController`) |
| Formatting | `intl` |
| Platforms | Android, iOS, Web, Windows, macOS, Linux (Flutter targets) |

---

## 📂 Project Structure

```
lib/
├── main.dart              → App entry point, theme and routes
├── models/                → Salon, Service, Stylist, Appointment, User
├── screens/               → login, home, staff ("Our Team"), appointments, profile
├── widgets/               → cards, buttons, text fields, navigation bars, animations
├── routes/                → route names
└── utils/                 → constants (colours, routes, categories), theme, validators
```

`screens/booking_screen.dart`, `controllers/appointment_controller.dart` and `providers/state_management.dart` are placeholders for the booking flow and state management still to be built.

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel)
- Android Studio / Xcode, or VS Code with the Flutter extension

### Run

```bash
git clone https://github.com/Jabulile1704/fresh_fadez.git
cd fresh_fadez
flutter pub get
flutter run
```

---

## 🗺️ Roadmap

- [ ] Booking flow: pick a service, stylist, date and time slot
- [ ] State management for appointments (e.g. Provider)
- [ ] Real authentication (Firebase Auth)
- [ ] Persist salons, services and appointments (Cloud Firestore)
- [ ] Booking confirmations and reminders (push notifications)
- [ ] Stylist/admin view to manage services, availability and appointment status

---

## 👩🏾‍💻 Author

**Jabulile Mashibini** — [GitHub](https://github.com/Jabulile1704) · [LinkedIn](https://linkedin.com/in/jabulile-mashibini) · [Portfolio](https://jabulile1704.github.io/JM-Mashibini-Website-Portfolio-/)
