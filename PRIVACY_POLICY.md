# Privacy Policy

**Last Updated:** 2026-06-05

## Introduction

Country Blocker is a free app. This service is provided at no cost and is intended for use as is.

This page explains what data the app collects, how it is used, and what stays on your device.

## What stays on your device

The following data is stored **locally only** and is never transmitted to any server or third party:

- **Phone numbers** — incoming caller numbers processed by the call-screening service.
- **Call logs** — records of calls that were blocked, including numbers, times, and country codes.
- **Contacts** — used only to optionally prevent blocking calls from people in your contacts list.
- **Your blocking configuration** — the list of countries you have chosen to block and whether blocking is enabled.

## What we collect to improve the app

To understand how the app is used and fix errors, we use **Firebase** (by Google), which collects:

### Crash diagnostics (always on)
When the app encounters an error, Firebase Crashlytics automatically collects:
- The type and location of the error (stack trace)
- Device model, operating system version
- App version
- A random device identifier and approximate IP address

This collection cannot be turned off. No phone numbers, call logs, or your blocking configuration are included in crash reports.

### Anonymous usage data (on by default, can be turned off)
Firebase Analytics collects anonymous usage signals to help understand how features are used:
- Which features you interact with (e.g. adding a country, toggling blocking)
- Whether permissions were granted
- Country codes of blocked calls (counts only — never the phone number)
- Theme and language preferences

This data is described as "anonymous" — it is tied to a random app installation identifier and your IP address, not to your name, phone number, or account.

**You can disable usage data collection at any time** in the app's Settings screen ("Usage analytics" toggle). Crash diagnostics continue regardless.

## Permissions used

- **Read Call Logs / Read Phone State** — detect incoming numbers and check country codes.
- **Answer Phone Calls / Call Screening** — automatically disconnect calls from blocked countries.
- **Read Contacts** — optionally prevent blocking numbers in your contacts.

## Third-party services

This app uses **Firebase** (Google LLC). Firebase's privacy policy is available at https://firebase.google.com/support/privacy.

## Security

No method of transmission over the internet is 100% secure. We use commercially reasonable means to protect any data that leaves your device, but cannot guarantee absolute security.

## Changes to this policy

This policy may be updated from time to time. Changes are effective immediately upon posting. You are advised to review this page periodically.

## Contact

For questions or concerns about this policy, open an issue on the app's GitHub repository.
