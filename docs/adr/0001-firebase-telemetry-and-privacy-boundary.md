# Adopt Firebase for telemetry and redraw the privacy boundary

We need crash diagnostics and usage analytics for a published call-blocking app, but the original `PRIVACY_POLICY.md` promised that nothing — including blocking preferences — is transmitted off-device. We chose **Firebase Crashlytics + Analytics** (free, unlimited, captures Dart *and* native crashes, single setup) and redrew the boundary: **raw phone numbers, full call logs, and contacts stay on the device (Local-only Data); aggregate non-identifying signals — country codes, counts, crash diagnostics — may be sent (Shareable Signal)**. The privacy policy is rewritten to state this precisely, replacing its self-contradictory "no transmission" + boilerplate "third-party log data" clauses.

## Considered Options

- **Sentry** — best-in-class errors, but weak product analytics; would need a second tool.
- **PostHog** — one tool for both, EU/self-host for stronger privacy; rejected for less mature crash reporting and extra hosting overhead for a solo dev.
- **Honor the original "transmit nothing" promise** — rejected because it makes "which countries are most blocked" impossible and leaves us blind to user-side errors.

## Consequences

- Crash diagnostics are always on (no toggle); usage analytics are on by default with one Settings toggle (opt-out).
- Collection is disabled when `kDebugMode` so developer testing never reaches production dashboards.
- A strict scrubbing rule applies: phone numbers and the blocklist must never appear in any event or non-fatal. Only country codes, counts, and sanitized failure types/messages.
- A Google Play Data Safety disclosure is now required.
