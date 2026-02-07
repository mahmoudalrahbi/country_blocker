# Country Blocker - Architecture & Context

This document is designed to help AI agents and developers quickly understand the project's architecture, patterns, and structure.

## 1. Project Overview
A Flutter application for blocking incoming calls based on country codes. It features a modern UI with dark/light theme support and follows Clean Architecture principles.

## 2. Tech Stack
- **Framework**: Flutter
- **State Management**: `flutter_riverpod` (v2+)
- **Dependency Injection**: Riverpod (`ProviderScope`, `Provider`, `StateNotifierProvider`)
- **Functional Error Handling**: `dartz` (`Either<Failure, T>`)
- **Value Equality**: `equatable`
- **Utility**: `country_picker` for UI.
- **Persistence**: `shared_preferences` (via Repository implementation).

## 3. Architecture: Feature-First Clean Architecture

The project is structured by feature, with each feature containing Domain, Data, and Presentation layers.

### Folder Structure
```
lib/
├── core/                  # Core functionality shared across features
│   ├── error/             # Failures and Exceptions
│   ├── usecase/           # Base UseCase class
│   ├── utils/             # Utilities (formatting, etc.)
│   └── providers.dart     # CENTRALIZED DEPENDENCY INJECTION (All providers live here)
│
├── features/              # Feature modules
│   └── country_blocking/  # Main feature: Blocking logic
│       ├── domain/        # Pure Dart logic (Entities, Use Cases, Repository Interfaces)
│       ├── data/          # Implementation (Models/DTOs, Data Sources, Repositories Impl)
│       └── presentation/  # UI (Screens, Notifiers, Widgets)
│
├── shared/                # Shared UI/Services across app
│   ├── presentation/      # Shared Screens (HomeScreen, Settings) & Widgets
│   ├── services/          # Platform Services (Permissions)
│   └── notifiers/         # Shared Notifiers (ThemeNotifier)
│
├── theme/                 # App Theme (AppTheme, AppColors)
└── main.dart              # App Entry Point (ProviderScope setup)
```

## 4. Key Patterns & Conventions

### Dependencies & Setup
- All **Providers** are defined in `lib/core/providers.dart`. This is the single source of truth for Dependency Injection.
- `main.dart` initializes `SharedPreferences` and overrides the `sharedPreferencesProvider` in the `ProviderScope`.

### State Management (Riverpod)
- **Notifiers**: Utilize `StateNotifier` for managing complex state (e.g., `CountryBlockingNotifier`).
- **Access logic**: Use `ref.watch(provider)` for UI rebuilds and `ref.read(provider.notifier)` for actions.
- `ConsumerWidget` and `ConsumerStatefulWidget` are used for all screens needing state access.

### Data Flow
1.  **UI** calls a method on a **Notifier** (e.g., `notifier.addCountry()`).
2.  **Notifier** executes a **UseCase** (e.g., `AddBlockedCountry`).
3.  **UseCase** calls a **Repository** (e.g., `CountryBlockingRepository`).
4.  **Repository** interacts with a **DataSource** (e.g., `LocalDataSource`).
5.  **Result** flows back up as `Either<Failure, T>`.

### Theming
- `AppTheme` defines `lightTheme` and `darkTheme` utilizing `AppColors`.
- Theme switching is managed by `ThemeNotifier` (in `shared/presentation/notifiers/`).

## 5. Critical Files to Read First
1.  `lib/core/providers.dart`: To understand the dependency graph.
2.  `lib/main.dart`: To see app initialization.
3.  `lib/features/country_blocking/domain/entities/blocked_country.dart`: Core business entity.
4.  `lib/features/country_blocking/presentation/notifiers/country_blocking_notifier.dart`: Main business logic controller.
