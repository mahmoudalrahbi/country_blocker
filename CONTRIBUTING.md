# Contributing

## Workflow

1. Fork the repo and create a branch from `main`: `fix/your-fix` or `feature/your-feature`
2. Follow the TDD workflow — write tests before implementation (see `CLAUDE.md`)
3. Run the full test suite before opening a PR: `flutter test`
4. Open a PR against `main` — all PRs require at least one review

## Development setup

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter test
```

## Branch naming

| Type | Pattern |
|------|---------|
| Bug fix | `fix/short-description` |
| Feature | `feature/short-description` |
| Refactor | `refactor/short-description` |

## Commit messages

Use the `[TYPE]` prefix:

```
[FIX] short description of what was fixed
[FEAT] short description of new feature
[REFACTOR] short description
[TEST] short description
```

## Native code (Android)

Changes to `CallBlockingService.kt` should include Android unit tests under
`android/app/src/test/`. Run them with:

```bash
cd android && ./gradlew test
```
