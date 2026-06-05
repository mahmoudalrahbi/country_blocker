# Bug Report — Country Blocker App

**Date:** 2026-05-01  
**Analyst:** Claude Code (automated codebase scan)  
**Branch:** `feature/claude-features`

---

## Executive Summary

| Severity | Count |
|----------|-------|
| Critical | 2 |
| High | 4 |
| Moderate | 9 |
| Low | 4 |
| **Total** | **19** |

---

## Critical

---

### BUG-001 — Race condition in `saveBlockedCall()` drops log entries

**File:** `android/app/src/main/kotlin/com/mahmoudalrahbi/countryblocker/CallBlockingService.kt` (lines 177–216)  
**Severity:** Critical  
**Category:** Logic Error / Data Loss

**Description:**  
`saveBlockedCall()` reads the existing JSON log array from SharedPreferences, prepends a new entry, and writes the array back — all without any synchronization. If two calls are blocked at nearly the same time (concurrent `onScreenCall` invocations), both threads read the same original array, both create a new array with their entry prepended, and whichever thread writes last silently overwrites the first. One log entry is permanently lost.

**Risk:** Silent, permanent data loss of blocked call logs under concurrent call traffic.

**Recommended Fix:**  
Wrap the read-modify-write in a `synchronized` block:
```kotlin
synchronized(this) {
    val existingJson = prefs.getString(logsKey, "[]")
    val jsonArray = org.json.JSONArray(existingJson)
    // ... prepend and write
}
```

---

### BUG-002 — Unguarded `DateTime.parse()` crashes on malformed timestamps

**File:** `lib/features/country_blocking/data/models/blocked_call_log_model.dart` (line 35)  
**Severity:** Critical  
**Category:** Crash Risk

**Description:**  
```dart
timestamp: DateTime.parse(map['timestamp'] as String),
```
There is no try-catch around `DateTime.parse()`. If the native Android layer writes a malformed or missing timestamp value, this throws an unhandled `FormatException`, crashing the app during log parsing. Because this is called inside `fromMap()`, it can crash any screen that loads the call log.

**Risk:** App crash whenever a log entry contains an invalid or missing timestamp.

**Recommended Fix:**
```dart
timestamp: DateTime.tryParse(map['timestamp'] as String? ?? '') ?? DateTime.now(),
```

---

## High

---

### BUG-003 — `BlockReason.values[index]` has no bounds check

**File:** `lib/features/country_blocking/data/models/blocked_call_log_model.dart` (line 34)  
**Severity:** High  
**Category:** Crash Risk

**Description:**  
```dart
reason: BlockReason.values[map['reason'] as int? ?? 0],
```
If the stored integer index is outside the range of `BlockReason.values` (e.g., because native code writes a value not yet represented in the Dart enum, or data is corrupted), this throws a `RangeError` at runtime.

**Risk:** Crash when parsing any log entry with an unexpected reason index.

**Recommended Fix:**
```dart
final reasonIndex = (map['reason'] as int?) ?? 0;
reason: (reasonIndex >= 0 && reasonIndex < BlockReason.values.length)
    ? BlockReason.values[reasonIndex]
    : BlockReason.countryBlocked,
```

---

### BUG-004 — Silent data loss in `BlockedCountryModel.fromMap()` with empty-string fallbacks

**File:** `lib/features/country_blocking/data/models/blocked_country_model.dart` (lines 27–30)  
**Severity:** High  
**Category:** Data Corruption

**Description:**  
```dart
isoCode:   map['isoCode']   as String? ?? '',
phoneCode: map['phoneCode'] as String? ?? '',
name:      map['name']      as String? ?? '',
```
Missing or null keys silently produce `BlockedCountryModel` instances with empty strings. These invalid objects can be saved back to SharedPreferences, permanently corrupting stored data without any error signal reaching the caller.

**Risk:** Silent data corruption; invalid countries appear in the blocklist with no name or phone code.

**Recommended Fix:** Validate required fields and throw `CacheException` if any are absent:
```dart
if (map['isoCode'] == null || map['phoneCode'] == null || map['name'] == null) {
  throw CacheException('Corrupt country record: missing required fields');
}
```

---

### BUG-005 — `toggleCountryBlocking()` silently succeeds when no country matches

**File:** `lib/features/country_blocking/data/repositories/country_blocking_repository_impl.dart` (lines 70–93)  
**Severity:** High  
**Category:** Logic Error

**Description:**  
The method maps over `countries` and returns `Right(null)` regardless of whether any country matched `phoneCode`. If a caller passes an unknown or stale phone code, the underlying list is saved unchanged while the caller receives a success result and assumes the toggle took effect.

**Risk:** Silent no-op; UI shows a country toggled when nothing actually changed in storage.

**Recommended Fix:**
```dart
bool matched = false;
final updatedCountries = countries.map((country) {
  if (country.phoneCode == phoneCode) {
    matched = true;
    return country.copyWith(isEnabled: isEnabled);
  }
  return country;
}).toList();
if (!matched) return Left(ValidationFailure('Country not found: $phoneCode'));
```

---

### BUG-006 — Blocked calls counter has no overflow guard

**File:** `lib/features/country_blocking/presentation/notifiers/country_blocking_notifier.dart` (line 185)  
**Severity:** High  
**Category:** Logic Error

**Description:**  
```dart
blockedCallsCount: state.blockedCallsCount + 1
```
Dart's `int` on 64-bit platforms is bounded but on JavaScript targets (web) it is limited to 53 bits. More importantly, there is no guard, so an extremely active blocking scenario (or data corruption that sets the counter to `maxInt`) will cause the counter to wrap or throw.

**Risk:** Counter corruption; potential crash on web builds.

**Recommended Fix:**
```dart
blockedCallsCount: (state.blockedCallsCount < 0x7FFFFFFFFFFFFFFF)
    ? state.blockedCallsCount + 1
    : state.blockedCallsCount,
```

---

## Moderate

---

### BUG-007 — `MainActivity.kt` returns `true` for `ROLE_CALL_SCREENING` on Android < Q

**File:** `android/app/src/main/kotlin/com/mahmoudalrahbi/countryblocker/MainActivity.kt` (line 34)  
**Severity:** Moderate  
**Category:** Logic Error

**Description:**  
`ROLE_CALL_SCREENING` was introduced in Android Q (API 29). The `else` branch for pre-Q devices calls `result.success(true)`, telling the Flutter layer that call screening is available when it is not. This can cause the app to display an active blocking state that never actually blocks any calls.

**Risk:** Users on Android < Q believe blocking is active; no calls are actually screened.

**Recommended Fix:**
```kotlin
} else {
    result.success(false)
}
```

---

### BUG-008 — `item.getString("phoneCode")` throws `JSONException` if key is absent

**File:** `android/app/src/main/kotlin/com/mahmoudalrahbi/countryblocker/CallBlockingService.kt` (line 133)  
**Severity:** Moderate  
**Category:** Error Handling

**Description:**  
`JSONObject.getString()` throws `JSONException` when the key does not exist. If a stored entry is missing the `phoneCode` field (e.g., due to a schema change or corruption), the exception propagates out of the parsing loop. Although there is an outer catch block, the entire blocking logic for that call is aborted.

**Risk:** A single corrupt entry prevents all country code matching for the incoming call.

**Recommended Fix:**
```kotlin
val blockedCodeStr = item.optString("phoneCode", "")
```

---

### BUG-009 — No log rotation; unbounded SharedPreferences growth

**File:** `android/app/src/main/kotlin/com/mahmoudalrahbi/countryblocker/CallBlockingService.kt` (lines 207–208)  
**Severity:** Moderate  
**Category:** Performance / Scalability

**Description:**  
The code contains a commented-out stub for limiting log size but never implements it. SharedPreferences is not designed for large JSON arrays. With thousands of blocked calls, the stored string grows without bound, slowing every read/write of `flutter.blocked_call_logs_native` and increasing memory pressure.

**Risk:** Degraded app performance and ANR risk on heavily-targeted devices.

**Recommended Fix:** Enforce a maximum of 100 entries after prepending:
```kotlin
while (newArray.length() > 100) {
    newArray.remove(newArray.length() - 1)
}
```

---

### BUG-010 — Cache errors in `loadLogs()` silently reset state to empty list

**File:** `lib/features/country_blocking/presentation/notifiers/block_log_notifier.dart` (line 21)  
**Severity:** Moderate  
**Category:** UX / Silent Failure

**Description:**  
```dart
failure: (failure) => state = [],
```
When loading logs fails (e.g., SharedPreferences is unavailable), the notifier replaces the current state with an empty list. The user sees no logs and receives no error message — indistinguishable from "there are no blocked calls."

**Risk:** Users cannot tell whether log loading failed or logs genuinely do not exist.

**Recommended Fix:** Preserve existing state and surface an error flag, or at minimum log the failure.

---

### BUG-011 — `Provider<List>` loses type safety for blocked countries list

**File:** `lib/core/providers.dart` (line 181)  
**Severity:** Moderate  
**Category:** Type Safety

**Description:**  
```dart
final blockedCountriesProvider = Provider<List>((ref) {
```
The unparameterized `List` type forces every consumer to cast manually and disables static type checking. Passing the wrong item type into the list is a silent runtime error rather than a compile-time error.

**Risk:** Type errors surfaced only at runtime; misleading API for consumers.

**Recommended Fix:**
```dart
final blockedCountriesProvider = Provider<List<BlockedCountry>>((ref) {
```

---

### BUG-012 — Language names hardcoded in `settings_screen.dart`

**File:** `lib/shared/presentation/screens/settings_screen.dart` (lines 455–456)  
**Severity:** Moderate  
**Category:** Localization

**Description:**  
```dart
currentLocale.languageCode == 'ar' ? 'العربية' : 'English'
```
These strings bypass the localization system. If a third language is added, this code must be manually updated. The Arabic string `'العربية'` is also invisible to translation tools.

**Risk:** Localization debt; breaks if new locales are added.

**Recommended Fix:** Use `AppLocalizations` keys (add `languageNameArabic` / `languageNameEnglish` if missing).

---

### BUG-013 — `CacheException` thrown without message discards error details

**File:** `lib/features/country_blocking/data/datasources/block_log_local_data_source.dart` (line 29)  
**Severity:** Moderate  
**Category:** Debugging / Error Handling

**Description:**  
```dart
} catch (e) {
  throw CacheException();
}
```
The original exception `e` is silently discarded. When debugging production failures, the only information available is "a cache exception occurred" with no detail about what went wrong.

**Risk:** Significantly harder to diagnose production storage failures.

**Recommended Fix:**
```dart
throw CacheException('Failed to parse block logs: $e');
```

---

### BUG-014 — `CacheFailure` created without message in `block_log_repository_impl.dart`

**File:** `lib/features/country_blocking/data/repositories/block_log_repository_impl.dart` (lines 18–19, 28–29)  
**Severity:** Moderate  
**Category:** Debugging / Error Handling

**Description:**  
```dart
return Left(CacheFailure());
```
Same pattern as BUG-013 — the `CacheException` message (if any) is not forwarded into `CacheFailure`, so the UI and any error-reporting layer receive a generic failure object with no actionable detail.

**Recommended Fix:**
```dart
return Left(CacheFailure(e.message));
```

---

### BUG-015 — Arabic ARB file missing `@metadata` entries for parameterized strings

**File:** `lib/l10n/app_ar.arb`  
**Severity:** Moderate  
**Category:** Localization

**Description:**  
`app_en.arb` defines `@blockingStateChanged`, `@copyright`, `@countryAddedToBlocklist`, and `@deleteBlocklistEntryMessage` metadata blocks that describe placeholders used by those strings. `app_ar.arb` contains the translated strings but none of the corresponding `@` metadata. While `flutter gen-l10n` derives metadata from the English file, this inconsistency can cause issues with some ARB tooling and linters.

**Recommended Fix:** Copy the `@metadata` entries from `app_en.arb` into `app_ar.arb`.

---

## Low

---

### BUG-016 — Informational log statements use `Log.e()` (error level)

**File:** `android/app/src/main/kotlin/com/mahmoudalrahbi/countryblocker/CallBlockingService.kt` (multiple lines)  
**Severity:** Low  
**Category:** Code Quality

**Description:**  
Debug and trace messages such as `"Global blocking is disabled"` and `"incoming number parsed"` are emitted with `Log.e()`, the error log level. This pollutes error monitoring tools (Crashlytics, logcat filters) with noise that looks like errors.

**Recommended Fix:** Use `Log.d()` for debug info and `Log.i()` for lifecycle events; reserve `Log.e()` for actual error conditions.

---

### BUG-017 — Log filtering runs O(n) work on every widget rebuild

**File:** `lib/features/country_blocking/presentation/screens/logs_screen.dart` (lines 46–48)  
**Severity:** Low  
**Category:** Performance

**Description:**  
`_filterLogs()` and `_groupLogsByDate()` are called during `build()` and iterate the full log list on every rebuild. With a large log history, this introduces measurable frame-time overhead, particularly when typing in a search field.

**Recommended Fix:** Memoize the filtered and grouped result using `useMemoized` (flutter_hooks) or cache it in the notifier/state, recomputing only when logs or the search query change.

---

### BUG-018 — Empty error handler in `clearLogs()` silently swallows failures

**File:** `lib/features/country_blocking/presentation/notifiers/block_log_notifier.dart` (line 29)  
**Severity:** Low  
**Category:** Silent Failure

**Description:**  
```dart
failure: (failure) {},
```
If clearing logs fails, the notifier does nothing — no state change, no error feedback to the user. The user taps "Clear logs" and nothing happens, with no indication of why.

**Recommended Fix:** Surface the failure as an error state or show a snackbar.

---

### BUG-019 — Flaky `Future.delayed(Duration.zero)` pattern in notifier tests

**File:** `test/features/country_blocking/presentation/notifiers/country_blocking_notifier_test.dart` (lines 73–92)  
**Severity:** Low  
**Category:** Test Reliability

**Description:**  
Tests use `await Future.delayed(Duration.zero)` to wait for the notifier's async `init()` to complete. This relies on microtask scheduling ordering that may not hold across Flutter versions or test environments, making these tests potentially flaky.

**Recommended Fix:** Use `container.read(provider)` and `await container.pump()` (Riverpod test utilities) or use `expectLater` with proper async matchers instead of manual delays.

---

## Appendix — File Index

| File | Bug IDs |
|------|---------|
| `android/.../CallBlockingService.kt` | BUG-001, BUG-008, BUG-009, BUG-016 |
| `android/.../MainActivity.kt` | BUG-007 |
| `lib/.../blocked_call_log_model.dart` | BUG-002, BUG-003 |
| `lib/.../blocked_country_model.dart` | BUG-004 |
| `lib/.../country_blocking_repository_impl.dart` | BUG-005 |
| `lib/.../country_blocking_notifier.dart` | BUG-006 |
| `lib/.../block_log_notifier.dart` | BUG-010, BUG-018 |
| `lib/core/providers.dart` | BUG-011 |
| `lib/.../settings_screen.dart` | BUG-012 |
| `lib/.../block_log_local_data_source.dart` | BUG-013 |
| `lib/.../block_log_repository_impl.dart` | BUG-014 |
| `lib/l10n/app_ar.arb` | BUG-015 |
| `lib/.../logs_screen.dart` | BUG-017 |
| `test/.../country_blocking_notifier_test.dart` | BUG-019 |
