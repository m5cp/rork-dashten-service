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

## Phase 3 — Retention loop ✅ DONE
- [x] Daily streak with a guilt-free "freeze" — `RetentionService.recordActivity` wires into checklist toggle, journal, check-in, tool use; auto-earns 1 freeze every 7 days (max 2); bridges 1 missed day automatically
- [x] 7 / 30 / 90-day milestone celebrations with shareable cards — `RetentionMilestone` enum + celebration overlay + share via existing `ShareProgressSheet`
- [x] Weekly summary card on Home — `RetentionWeeklySummaryCard` shows missions/XP/journal + dynamic next-step
- [x] Monthly readiness reassessment prompt — `ReassessmentPromptCard` surfaces 30+ days after last self-assessment, deep-links to `SelfAssessmentView`, dismissible for 30 days
- [x] In-app feedback prompt after 3 sessions — `FeedbackPromptSheet` (positive → `requestReview`, negative → App Store "Report a Problem" path)

## Phase 4 — Analytics & growth
- [ ] Add event tracking for: app open, every screen view, every onboarding step, paywall shown/dismissed/converted, redeem code, every core feature first use, subscription started/renewed/cancelled, crashes
- [ ] App Store metadata rewrite: new title, subtitle, and 100-char keyword string optimized for veteran transition search terms
- [ ] New screenshot copy outline focused on outcomes (job offer, VA rating, finances locked in) — not UI shots

## Phase 5 — Platform connections ✅ DONE
- [x] **WidgetKit**: Small/Medium/Large home widgets + Circular/Rectangular/Inline lock screen widgets. Days-to-EAS, today's focus, readiness %, streak, tasks remaining. `widgetURL(dashten://today)` deep-links into Home.
- [x] **Live Activities / Dynamic Island**: `TransitionCountdownLiveActivity` registered in widget bundle. Lock Screen banner + expanded/compact/minimal Dynamic Island with countdown, phase, branch, today's focus.
- [x] **App Intents / Siri Shortcuts**: added `LogDailyCheckInIntent`, `OpenTodaysMissionIntent`, `TrackContactIntent` alongside existing OpenPlan/CheckReadiness/LogTask. Pending-intent flags consumed in `ContentView` on next launch (records streak activity, jumps to the right tab).
- [x] **Push Notifications**: `NotificationPermissionView` rationale screen + daily smart reminder, streak protection (7pm), weekly summary (Sun 5pm), milestone helper, plus existing separation / account milestone schedules.
- [x] **HealthKit**: `HealthKitService` reads Steps, Sleep, Mindful Minutes (last 7 days). `HealthKitOptInView` opt-in screen. HealthKit entitlement + `NSHealthShareUsageDescription` + `NSHealthUpdateUsageDescription` added. Read-only — never writes, never uploads.
- [x] Privacy Policy updated with HealthKit (optional, read-only) and Notifications (optional, on-device) disclosures.
- [x] Deep-link handler in `ContentView` (`dashten://today|plan|tools|learn|profile`).

## Phase 6 — Major upgrades (higher risk, reviewed carefully)
- [ ] Refactor remaining services to a single DI pattern (no scattered singletons)
- [ ] Move sensitive keys/tokens to Keychain (anything currently in UserDefaults that shouldn't be)
- [ ] Convert any remaining `@StateObject`/`@ObservedObject` to `@Observable` + `@State`/`@Bindable`
- [ ] Strengthen typed error handling across services with user-facing messages
- [ ] Add a single source of truth for the paywall trigger (one service, all entry points use it)
- [ ] Add a lightweight offline cache layer so all read-only content works without network

---

Nothing on the DO NOT TOUCH list is changed. After each phase I build, verify, and pause for sign-off before starting the next.
