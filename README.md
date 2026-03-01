# HopeConnect 🌟

**HopeConnect** – *Connecting Hearts, Changing Lives*

A production-quality Flutter application for NGO volunteer management, built for Indian non-profit organisations.

---

## About

HopeConnect is a comprehensive mobile platform that empowers NGOs to:

- **Manage Volunteers & Members** – Role-based access for Super Admin, Admin, Member, and Volunteer tiers
- **Track Tasks** – Assign, monitor, and approve field tasks with optional photo-proof uploads
- **Schedule Meetings** – Plan meetings, track attendance, and record Minutes of Meeting (MOM)
- **Record Donations** – Log donors, payment modes (Cash / Online / Cheque), 80G eligibility, and receipt generation
- **Handle MOU Requests** – Submit and approve Memoranda of Understanding for patient/hospital support
- **Issue Certificates** – Request and generate volunteer service certificates and appreciation letters
- **Manage Documents** – Store legal, tax, financial, and governance documents (NGO registration, 12A, 80G, FCRA, etc.)
- **Generate Joining Letters** – Monthly and annual tenure letters for volunteers

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter 3.10+ / Dart 3.0+ |
| State Management | Provider 6 |
| Navigation | GoRouter 13 |
| Charts | fl_chart |
| Fonts | Google Fonts (Poppins) |
| Image Picker | image_picker |
| Progress | percent_indicator |

---

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── app.dart                     # MaterialApp.router + providers
├── config/
│   ├── router/app_router.dart   # GoRouter configuration
│   └── theme/
│       ├── app_colors.dart      # Colour constants
│       ├── dark_theme.dart      # Dark ThemeData
│       ├── light_theme.dart     # Light ThemeData
│       └── app_theme.dart       # Theme exports
├── core/
│   ├── constants/app_strings.dart
│   └── enums/
│       ├── user_role.dart
│       └── status.dart
├── models/
│   ├── user_model.dart
│   ├── task_model.dart
│   ├── donation_model.dart
│   ├── meeting_model.dart
│   ├── mou_model.dart
│   ├── certificate_model.dart
│   ├── document_model.dart
│   └── joining_letter_model.dart
└── providers/
    ├── theme_provider.dart
    ├── auth_provider.dart
    └── app_data_provider.dart
```

---

## Getting Started

### Prerequisites
- Flutter SDK >= 3.10.0
- Dart SDK >= 3.0.0
- Android Studio / Xcode

### Setup

```bash
# Install dependencies
flutter pub get

# Run on connected device / emulator
flutter run

# Build release APK
flutter build apk --release
```

---

## Demo Credentials

| Role | Email | Password |
|------|-------|----------|
| Super Admin | superadmin@hopeconnect.org | any 6+ chars |
| Admin | admin@hopeconnect.org | any 6+ chars |
| Admin | vikram@hopeconnect.org | any 6+ chars |
| Member | anjali@hopeconnect.org | any 6+ chars |
| Volunteer | amit@hopeconnect.org | any 6+ chars |

---

## Themes

HopeConnect ships with a **dark theme** (default) and a **light theme**, both using the Poppins typeface and the brand teal accent (`#00BFA6`).

---

## Licence

© 2025 HopeConnect. All rights reserved.
