# Full DashTen fix plan — 6 phases from compliance to power features

## Phase 1 — Critical fixes (App Store safety net) ✅ DONE
- [x] Paywall billed price prominent, weekly only as secondary
- [x] Auto-renewal disclosure above the buy button
- [x] Account Deletion in Profile
- [x] Sign in with Apple — N/A (no social sign-in)
- [x] Restore Purchases + Redeem Code on every paywall
- [x] Privacy Policy + Terms reachable from Profile and Paywall
- [x] Privacy Manifest verified
- [x] Unused frameworks/capabilities pruned

## Phase 2 — Quick wins ✅ DONE
- [x] Paywall triggers after onboarding "aha"
- [x] Onboarding tightened to 3–4 outcome-led screens
- [x] Friendly empty states across lists
- [x] Loading shimmer on async screens
- [x] 44pt minimum tap targets
- [x] Dynamic Type + VoiceOver pass
- [x] Dark mode pass

## Phase 3 — Retention loop ✅ DONE
- [x] Daily streak with guilt-free freeze
- [x] 7/30/90-day milestone celebrations
- [x] Weekly summary card on Home
- [x] Monthly readiness reassessment prompt
- [x] In-app feedback prompt after 3 sessions

## Phase 4 — Analytics & growth ✅ DONE
- [x] Event tracking wired (open, screens, onboarding, paywall, redeem, features, subs, crashes)
- [x] App Store metadata rewrite
- [x] Screenshot outline focused on outcomes

## Phase 5 — Platform connections ✅ DONE
- [x] WidgetKit (Home + Lock Screen)
- [x] Live Activities / Dynamic Island
- [x] App Intents / Siri Shortcuts
- [x] Push Notifications with rationale screen
- [x] HealthKit read-only Wellness snapshot
- [x] Wellness tab/section in Profile
- [x] Privacy Policy + EULA + Privacy Manifest updated for HealthKit

## Phase 6 — Major upgrades 🟡 IN PROGRESS
- [x] Single source of truth for paywall trigger — new `PaywallCenter` injected via environment, one root sheet in `ContentView`; all 7 call sites migrated (TodayView, ToolboxView, CategoryToolsView, LearnView, OnboardingView, ProfileView, SearchView)
- [x] Typed error handling with user-facing messages — new `AppError` enum maps RevenueCat + URL errors to friendly copy; wired into `StoreViewModel`
- [x] `@Observable` migration verified — no `@StateObject` / `@ObservedObject` / `ObservableObject` remain
- [x] Keychain audit — no secrets/tokens in UserDefaults (only local app state). RevenueCat manages its own secure storage. N/A
- [x] Offline cache audit — app is local-first via `StorageService` + UserDefaults; all read-only content works without network. N/A
- [ ] DI refactor of remaining singletons — deferred (current `.shared` singletons are stateless service facades; refactoring touches every view and risks regressions for low user-visible value)
