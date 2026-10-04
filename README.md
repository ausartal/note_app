<div align="center">

# Note App

**A clean, offline-first notes application built with Flutter**

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLite-sqflite-003B57?style=for-the-badge&logo=sqlite&logoColor=white)
![Provider](https://img.shields.io/badge/State-Provider-6A1B9A?style=for-the-badge)

![License](https://img.shields.io/badge/license-MIT-green)
![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-blue)

</div>

---

## Overview

Note App is a lightweight, fully offline note-taking application. Notes are stored locally with SQLite, so everything stays on your device — no account, no network required. The UI supports light and dark themes and lays notes out in a responsive staggered grid.

## Features

- Create, view, edit, and delete notes
- Local persistence with **SQLite** (sqflite) — works fully offline
- Light & dark theme toggle (persisted across sessions)
- Staggered grid layout that adapts to screen size
- Note detail view with timestamp metadata
- Provider-based state management

## Screenshots

> Screenshots are not yet available. Run the app locally to explore the UI.

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.x
- Dart 3.x
- A device, emulator, or Chrome for web

### Install & Run

```bash
git clone https://github.com/ausartal/note_app.git
cd note_app

flutter pub get
flutter run
```

To target a specific platform:

```bash
flutter run -d chrome     # web
flutter run -d windows    # desktop
```

### Tests

```bash
flutter test
```

## Project Structure

```
note_app/
├── lib/
│   ├── main.dart                 # App entry, providers, theming
│   ├── database/
│   │   └── note_database.dart    # SQLite helper (CRUD)
│   ├── models/
│   │   └── note.dart             # Note model
│   ├── pages/
│   │   ├── note_page.dart        # Notes list (home)
│   │   ├── add_edit_note_page.dart
│   │   └── note_detail_page.dart
│   ├── providers/
│   │   ├── note_provider.dart    # Notes state
│   │   └── theme_provider.dart   # Theme state
│   └── widgets/
│       ├── note_card_widget.dart
│       └── note_form_widget.dart
├── docs/
│   └── ARCHITECTURE.md
├── test/
│   └── widget_test.dart
├── android/ ios/ web/ linux/ macos/ windows/
└── pubspec.yaml
```

## Tech Stack

| Layer      | Choice                          |
| ---------- | ------------------------------- |
| Framework  | Flutter / Dart                  |
| Local DB   | sqflite + path                  |
| State      | provider                        |
| UI         | Material 3, flutter_staggered_grid_view |
| Formatting | intl                            |

## Author

**Ahmad Nabah Falah** — [@ausartal](https://github.com/ausartal)

## License

This project is available for educational and personal use.
