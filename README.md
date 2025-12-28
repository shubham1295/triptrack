# TripTrack

Make every trip count — track journeys, log expenses, and understand your travel spending in seconds. TripTrack is a small, focused Flutter app that keeps all data local and private while providing quick insights into travel spending.

✨ Why TripTrack?
- Fast and lightweight — no accounts, no cloud required.
- Offline-first: all data stays on-device.
- Simple workflows for busy travelers: create trips, add expenses, and see useful summaries.

Highlights
- Create and manage trips (title, dates, notes)
- Add expenses to trips with amount, category, date, and note
- View totals and quick analytics per trip (category breakdowns, daily spend)
- Local persistence via Isar — efficient, type-safe Flutter DB
- Thoughtful UI: Poppins/Inter fonts, blue & warm orange accents, rounded cards

Quick demo
1. Open the app → Tap "New Trip" → Give it a name and dates.
2. Open a trip → Tap "Add Expense" → Enter amount, category, and note.
3. View the trip to see totals and a chart of spending by category.

Screenshots
Add screenshots to `assets/screenshots/` and update this section:
- Home / Trips list
- Trip detail with expense list
- Add/Edit expense form
- Analytics / charts view

Getting started (developer)
Prerequisites
- Flutter SDK (stable)
- Android Studio or Xcode (for emulators / builds)
- Optional: VS Code + Flutter/Dart extensions

Install & run
1. Clone:
   git clone https://github.com/shubham1295/triptrack.git
2. Enter project:
   cd triptrack
3. Get dependencies:
   flutter pub get
4. Run on a connected device or emulator:
   flutter run

Build (release)
- Android (APK): flutter build apk --release
- iOS (IPA): flutter build ipa --release (macOS + Xcode required)

Dependencies (notable)
- Flutter (Dart)
- Isar (local DB) — https://pub.dev/packages/isar
- isar_flutter_libs — https://pub.dev/packages/isar_flutter_libs
- charts (choose preferred package)
- google_fonts (Poppins / Inter)

Isar notes (important)
TripTrack uses Isar for local persistence (replacing SQLite). Isar is a fast, Flutter-friendly NoSQL DB with strong Dart typing and codegen for collections.

- Add Isar packages in `pubspec.yaml`:
  - isar
  - isar_flutter_libs (for mobile/runtime)
  - isar_generator (dev dependency)
  - build_runner (dev dependency)

- Generate Isar schema:
  flutter pub run build_runner build --delete-conflicting-outputs

- Typical model setup
  - Annotate collections with `@Collection()` (from `package:isar/isar.dart`)
  - Example:
    - Trip: id, title, startDate, endDate, notes
    - Expense: id, tripId, amount, category, date, note

- DB helper
  - Use a single Isar service/provider for opening the Isar instance, performing CRUD, and handling migrations.
  - Keep transactions for multi-write operations.
  - Isar supports queries, links, and indexes — use indexes for common queries (e.g., expenses by tripId, date).

Project structure
- lib/
  - main.dart — app entry
  - models/ — Trip, Expense (Isar collections)
  - services/ — isar_service.dart, analytics helpers
  - screens/ — Home, TripDetail, ExpenseForm, Analytics, Settings
  - widgets/ — reusable UI components
  - utils/ — colors, typography, date/number formatters

Database & models (example)
- Trip
  - id (int)
  - title (String)
  - startDate (DateTime)
  - endDate (DateTime)
  - notes (String)
- Expense
  - id (int)
  - tripId (int) — link/reference to Trip (or use Isar Link)
  - amount (double)
  - category (String)
  - date (DateTime)
  - note (String)

Usage examples
- Create a new trip: Home → + New Trip → Save
- Add expense to trip: Open trip → + Add Expense → Fill form → Save
- View analytics: Open a trip → Charts (total per category, daily spend)

Contributing
Contributions, feedback, and bug reports are welcome!
1. Fork the repo
2. Create a branch: git checkout -b feat/your-feature
3. Commit: git commit -m "Add: feature"
4. Push and open a PR

Please include tests for new functionality and try to follow the existing style. For Isar schema changes, ensure codegen is run and updated generated files are included in the PR (or provide instructions to run build_runner in your PR notes).

Roadmap (ideas)
- Export / import (CSV, JSON)
- Optional cloud sync with account (opt-in)
- Multi-currency and conversion support
- Recurring expenses, budgets, and alerts
- Dark mode and theme customization
- Improved analytics and filtering

License
This project is open source — add a LICENSE file (MIT recommended) to make licensing explicit.

Maintainer: [shubham1295](https://github.com/shubham1295)  

Have suggestions or want help setting up? Open an issue or send a message on GitHub.

Acknowledgements
- Fonts: Google Fonts — Poppins / Inter
- Iconography & images: (add sources)
- Database: Isar — https://isar.dev

Thanks for checking out TripTrack — safe travels and happy tracking! ✈️🧾
