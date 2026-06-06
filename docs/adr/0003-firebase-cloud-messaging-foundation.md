# Add Firebase Cloud Messaging as the push notification foundation

The app needs a push notification channel for update announcements, monthly blocked-call summaries, and future broadcast messages. We chose **Firebase Cloud Messaging (FCM)** with a Firestore-backed **Device Record** per installation, a global `NavigatorKey`-based **Notification Router**, and a split Firebase initialisation guard.

## Decisions

**Targeting model**: both topic-based broadcast (all devices subscribe to `"all_users"`) and token-based per-device targeting. Per-device targeting is required for personalised messages (e.g. monthly blocked-calls count).

**Firestore schema**: flat collection `devices/{deviceToken}`. Each document holds `token`, `blockedCallsCount`, `platform`, `appVersion`, `lastSyncedAt`. The **Blocking Preference** (blocklist) is explicitly excluded — it is **Local-only Data** under the privacy boundary defined in ADR 0001.

**`blockedCallsCount` in Firestore**: treated as a **Shareable Signal** — it is a count, carries no phone numbers, and is no more identifying than the pseudonymous data already collected by Firebase Analytics (see ADR 0002). The blocklist is never stored remotely.

**Sync triggers**: on app launch, on every call blocked, on every country add/remove. Keeps the Device Record fresh for Cloud Function reads.

**Notification permission**: requested on first launch; treated as required — the app is unusable until granted, consistent with the call-screening permission gate.

**Notification types**: every FCM payload carries a `type` field. Defined values: `update_available`, `monthly_summary`, `announcement`. The Notification Router switches on this field to navigate to the correct screen.

**Navigation**: global `NavigatorKey` + `NotificationRouter` in `lib/core/notifications/`. Rejected `go_router` — the app has one feature and three screens; a router package would be over-engineering.

**Foreground behaviour**: notifications arriving while the app is open are swallowed silently — no system banner, no in-app UI.

**Firebase initialisation guard (split)**: Firebase Core initialises unconditionally in both debug and release. Crashlytics error hooks and Analytics collection remain release-only (existing ADR 0001 behaviour). This allows FCM notification testing during development without polluting production telemetry dashboards.

**Architecture placement**: all notification infrastructure lives in `lib/core/notifications/` — `NotificationService` interface, `FirebaseNotificationService` implementation, and `NotificationRouter`.

## Considered Options

- **`go_router` for deep linking** — rejected; over-engineering for three routes.
- **Firestore user-centric schema (`users/{id}/devices/{token}`)** — rejected; no auth/login in the app. Device install = identity.
- **Store blocklist in Firestore** — rejected; violates the Local-only Data boundary (ADR 0001).
- **Keep `kDebugMode` guard for all Firebase** — rejected; would make FCM untestable in development.
- **Separate Firebase project for debug** — rejected; adds maintenance overhead for a solo dev.

## Consequences

- `firebase_messaging` and `cloud_firestore` are added as dependencies.
- Notification permission denial blocks app use — same UX as call-screening permission denial.
- The Play Data Safety form must be updated to declare FCM token and blocked-calls count storage in Firestore.
- Cloud Functions (not part of this ADR) will read `devices/` to send personalised and broadcast notifications.
