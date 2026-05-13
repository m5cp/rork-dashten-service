# Full DashTen fix plan — 6 phases from compliance to power features

I'll work through this in 6 phases, smallest risk first so nothing already working breaks. You can stop me after any phase.

---

## Phase 1 — Critical fixes (App Store safety net) ✅ DONE
- [x] Make the actual billed price ($59.99/year and $7.99/month) the biggest, most prominent number on the paywall — weekly equivalent only as small secondary text
- [x] Make auto-renewal disclosure clearly visible above the buy button, not buried at the bottom
- [x] Add **Account Deletion** flow inside Profile (required by Apple) — renamed "Delete Account & All Data" with clearer copy
- [x] Add **Sign in with Apple** option if any other social sign-in exists — N/A (no social sign-in; app is local-only)
- [x] Make sure **Restore Purchases** and **Redeem Code** appear on every paywall entry
- [x] Confirm Privacy Policy + Terms of Use are reachable from Profile and Paywall
- [x] Verify Privacy Manifest is complete and accurate — added FileTimestamp, SystemBootTime, DiskSpace reasons
- [x] Remove any unused frameworks/capabilities to reduce reviewer flags — entitlements file is empty (only Live Activity uses Info.plist key), nothing to remove

## Phase 2 — Quick wins (low risk, high impact)
- [x] Trigger the paywall right after the onboarding "aha" moment, not just after dismissal (already wired in Phase A)
- [x] Tighten onboarding to 3–4 screens, one action per step, outcome-led copy — reduced 5→4 by inlining disclaimer into goals page; CTA reads "Start My Plan"
- [x] Add a friendly empty state to every list (Documents, Networking Hub, Journal, etc.) — Journal empty state added; Mentor Tracker, Networking Scorecard, Goal Tracker, Documents already handle empty
- [ ] Add a loading shimmer on every async screen — skipped: all data is local/synchronous (no async fetches that block UI)
- [x] Add 44pt minimum tap targets everywhere a button is smaller today — Skip/Back in onboarding given 44pt frames; existing CTAs already meet
- [ ] Audit Dynamic Type + VoiceOver labels on the main flows
- [x] Confirm dark mode looks right across every screen — verified semantic colors (.systemGroupedBackground, .secondarySystemGroupedBackground, .primary/.secondary) used throughout

## Phase 3 — Retention loop
- [ ] Daily streak with a guilt-free "freeze" so missing a day doesn't punish users
- [ ] 7 / 30 / 90-day milestone celebrations with shareable cards
- [ ] Weekly summary card on Home: missions completed, XP gained, next step
- [ ] Monthly readiness reassessment prompt
- [ ] In-app feedback prompt after 3 sessions

## Phase 4 — Analytics & growth
- [ ] Add event tracking for: app open, every screen view, every onboarding step, paywall shown/dismissed/converted, redeem code, every core feature first use, subscription started/renewed/cancelled, crashes
- [ ] App Store metadata rewrite: new title, subtitle, and 100-char keyword string optimized for veteran transition search terms
- [ ] New screenshot copy outline focused on outcomes (job offer, VA rating, finances locked in) — not UI shots

## Phase 5 — Platform connections (the ones you picked)
- [ ] **WidgetKit**: Home Screen (Small/Medium/Large) showing days-to-EAS, next mission, readiness score. Lock Screen (Circular/Rectangular/Inline) for countdown + streak. Deep-link taps into the right screen. (Widget target already exists — needs expansion)
- [ ] **Live Activities / Dynamic Island**: countdown to separation date, today's mission progress, weekly mission status with compact/minimal/expanded views (LiveActivityService exists — needs Dynamic Island UI)
- [ ] **App Intents / Siri Shortcuts**: "Log today's check-in", "Show my readiness score", "Open today's mission", "Track a new contact". Donate on use, surface in Spotlight. (AppIntents.swift exists — needs audit + new intents)
- [ ] **Push Notifications**: daily reminder (smart-timed), streak protection, milestone reached, new guide unlocked, weekly summary. Full permission flow with rationale screen.
- [ ] **HealthKit**: read Mindfulness, Sleep, Steps to feed the Wellness Check-In trend chart; nothing is ever uploaded. Clear opt-in screen explaining what's read and why.

## Phase 6 — Major upgrades (higher risk, reviewed carefully)
- [ ] Refactor remaining services to a single DI pattern (no scattered singletons)
- [ ] Move sensitive keys/tokens to Keychain (anything currently in UserDefaults that shouldn't be)
- [ ] Convert any remaining `@StateObject`/`@ObservedObject` to `@Observable` + `@State`/`@Bindable`
- [ ] Strengthen typed error handling across services with user-facing messages
- [ ] Add a single source of truth for the paywall trigger (one service, all entry points use it)
- [ ] Add a lightweight offline cache layer so all read-only content works without network

---

Nothing on the DO NOT TOUCH list is changed. After each phase I build, verify, and pause for sign-off before starting the next.
