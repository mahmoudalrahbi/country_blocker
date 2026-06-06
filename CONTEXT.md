# Country Blocker

A Flutter app that rejects incoming calls based on the caller's country. This glossary defines the shared language of the blocking domain, the precise boundary between data that stays on the device and data that may leave it, and the push notification infrastructure.

## Language

### Blocking

**Blocked Country**:
A country whose incoming calls the user has chosen to reject, identified by ISO country code / dial prefix.
_Avoid_: banned country, filtered country

**Blocking Preference**:
The user's private configuration — the set of **Blocked Countries** plus the global on/off switch. In identifiable, per-user form this is **Local-only Data**.
_Avoid_: settings, config (too generic when referring to this specifically)

**Blocked Call Log**:
The on-device record of calls that were screened and rejected, including the caller's number, time, and country.
_Avoid_: history, call record

### Data & Privacy

**Local-only Data**:
Data that must never leave the device — raw phone numbers, **Blocked Call Logs**, contacts, and **Blocking Preferences** in identifiable per-user form.

**Shareable Signal**:
Aggregate, non-identifying data that may be sent off-device — bare country codes, counts, and crash diagnostics — once decoupled from any phone number or person. The boundary is *identifiability + aggregation*, not the country code itself: "a call from +91 was blocked" is shareable; "this user's blocklist is [IN, RU]" is not. A `blockedCallsCount` stored in a **Device Record** is also a Shareable Signal: it is a count, carries no phone numbers, and is no more identifying than the pseudonymous data already collected by Firebase Analytics (see ADR 0002).

**Usage Analytics**:
Behaviour data — feature usage, the permission funnel, country-level block counts — collected via Firebase Analytics. On by default; the user can disable it with one Settings toggle.
_Avoid_: tracking, telemetry (as a loose synonym)

**Crash Diagnostics**:
Always-on error reporting via Firebase Crashlytics — stack traces plus device/OS/IP metadata. Covers both **Crashes** and reported **Non-fatals**. Has no off-switch.
_Avoid_: logging, telemetry (as a loose synonym)

### Notifications

**Device Token**:
The FCM registration token that uniquely identifies one app installation on one device. Stored in Firestore as the key of a **Device Record**. Rotated by FCM at any time; the app re-syncs it on every launch.
_Avoid_: FCM token, push token (use Device Token consistently in code and docs)

**Device Record**:
The Firestore document at `devices/{deviceToken}` that the app maintains for targeting purposes. Contains only: `token`, `blockedCallsCount`, `platform`, `appVersion`, `lastSyncedAt`. Never contains **Blocking Preferences** or any **Local-only Data**.

**Notification Type**:
The `type` field in every FCM payload that drives deep-link routing. Defined values: `update_available`, `monthly_summary`, `announcement`. Every notification sent must carry a `type`; the app ignores messages without one.

**Notification Router**:
The component that reads the `type` field from an incoming FCM message and navigates to the appropriate screen using the global `NavigatorKey`. Lives in `lib/core/notifications/`.
_Avoid_: deep link handler, push handler

## Flagged ambiguities

**"Error" / "Failure" / "Crash" / "Non-fatal"** — these are not interchangeable here:
- **Failure** — the in-code value: a `dartz` `Left<Failure>` (`CacheFailure`, `PermissionFailure`, …). A *handled* error; the app keeps running.
- **Non-fatal** — a **Failure** that has been reported to **Crash Diagnostics** via `recordError(fatal: false)`.
- **Crash** — an unhandled exception that terminates a flow (Dart or native), captured automatically.
Use "Failure" in code, "Non-fatal" for a reported handled Failure, "Crash" only for unhandled termination.

**"Anonymous"** — technically, the data is *pseudonymous*: Firebase ties it to an app-instance / installation ID and IP, so it can be correlated to a device. **Project decision:** the word "anonymous" is nonetheless used across all surfaces — Settings toggle, privacy policy, and Play Data Safety form — chosen for wording consistency over technical precision, against the recommendation that formal surfaces stay precise. Known risk: Play Data Safety treats "anonymous" as *not linkable to a device*, so this is a potential misdeclaration. See ADR 0002.

## Example dialogue

**Dev:** Can we send the blocklist to Firebase so we know the most-blocked countries?

**Privacy reviewer:** No — a user's blocklist is a Blocking Preference, that's Local-only Data. What you *can* send is a Shareable Signal: each time a call is blocked, emit the country code on its own, with no number and not tied to a specific user's configuration.

**Dev:** So "blocked a call from +91" is fine, but "user X blocks [IN, RU]" isn't?

**Privacy reviewer:** Exactly. The first is aggregate and non-identifying. The second reveals one person's preferences.

**Dev:** And if a SharedPreferences read fails?

**Privacy reviewer:** That's a Failure in code. Report it to Crash Diagnostics as a Non-fatal — but only the failure type and a static message, never the phone number that was being parsed.
