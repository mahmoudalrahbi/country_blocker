# Label pseudonymous telemetry as "anonymous" in all surfaces

Firebase telemetry is technically *pseudonymous* — Crashlytics and Analytics tie data to an app-instance / installation ID and IP, so it can be correlated to a device. The recommendation was to keep formal surfaces (privacy policy, Play Data Safety form) precise and reserve "anonymous" for casual UI copy. **We decided instead to use the word "anonymous" across all surfaces** — Settings toggle, privacy policy, and Play Data Safety form — for wording consistency.

## Status

accepted (against recommendation)

## Consequences

- Known risk: Google Play's Data Safety form defines "anonymous" as data that *cannot* be linked to a device. Describing Firebase data as anonymous there is a potential misdeclaration; apps have been suspended for this exact mismatch.
- If Play review challenges it, the fix is to reword the policy + form to "tied to a device identifier and IP; not used to identify you personally" — this ADR records that the wording was a deliberate choice, not an oversight.
- See `CONTEXT.md` → Flagged ambiguities → "Anonymous".
