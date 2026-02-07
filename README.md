# Country Blocker

A Flutter application to block incoming calls based on Country Codes.

## Features
- **Block by Country**: Select a country from the list to block all calls starting with that country code.
- **Manual Entry**: Manually enter specific prefixes to block.
- **Native Efficiency**: Uses Android `CallScreeningService` for efficient blocking without being the default dialer.
- **Modern Architecture**: Built with Flutter Riverpod and Clean Architecture.

## Getting Started

### Android
1. **Run the App**: `flutter run`
2. **Grant Permissions**: 
   - Open the app.
   - Tap the **Shield Icon** in the top right corner.
   - Select "Call Shield" as your Call Screening App when prompted.
   - **Note**: This feature requires Android 10 (API 29) or higher to work via the simplified role request. For older versions, manual setting in "Default Apps" might be needed.

### iOS
iOS has stricter limitations on call blocking. CallKit extensions require exact numbers rather than prefixes.
To set up the iOS extension:
1. Follow the instructions in `ios_setup_instructions.md`.
2. Note that blocking *entire countries* is difficult on iOS due to API limitations (you cannot block ranges/prefixes easily). This project provides the template to get started.

## Project Structure & Architecture

This project follows **Feature-First Clean Architecture**.

Please refer to [ARCHITECTURE.md](ARCHITECTURE.md) for a detailed overview of the:
- Tech Stack (Riverpod, dartz, etc.)
- Folder Structure
- Key Patterns
- Data Flow

## Dependencies
- `flutter_riverpod`: State management and Dependency Injection.
- `country_picker`: For selecting country codes.
- `shared_preferences`: For persistence.
- `dartz`: Functional programming (Either<Failure, T>).
- `freezed` & `json_serializable`: Code generation.
