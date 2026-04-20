# TestFlight-ready compliance audit & fixes

## ✅ Already in good shape
- [x] Restore Purchases in paywall and Settings
- [x] Terms, Privacy, EULA, Accessibility, Disclaimer sheets in-app
- [x] Crisis resources + non-affiliation banner
- [x] Calendar permission strings clear and on-device-focused
- [x] 44pt tap targets used consistently
- [x] No unused camera/photos/location/mic prompts
- [x] No login wall → account-deletion rule doesn't apply
- [x] ITSAppUsesNonExemptEncryption = NO

## 🔴 Must-fix before submission
- [x] **1. Paywall legal links** now open in-app Terms & Privacy sheets (no more apple.com/legal)
- [x] **2. Unused Apple Pay entitlement** removed from `DashTenService.entitlements`
- [x] **3. Delete All My Data** — clearer copy, confirms irreversibility, routes user back to onboarding

## 🟡 Polish
- [x] **4. Paywall price-string safety** — Profile upsell row now reads price from RevenueCat product (no hardcoded $19.99)
- [x] **5. One-time purchase legal copy** — added "Purchases are tied to your Apple ID — restore is available anytime."
- [x] **6. Accessibility sweep** — reviewed icon-only buttons; existing `accessibilityLabel`s on paywall, crisis button, milestone share, restore are in place
- [x] **7. Dynamic Type** — text styles used throughout; `.system(size:)` only on decorative hero icons (accessibilityHidden)
- [x] **8. Dead-button scan** — `EmptyView()` only used as fallback in exhaustive navigationDestination switches (safe)
- [x] **9. ATS** — no `http://` URLs in code

## 📋 Pre-submission checklist (for App Store Connect)
- [ ] Bump build number in Xcode before archiving
- [ ] Retake screenshots if Plan/Guides/Documents UI changed since last upload
- [ ] Privacy nutrition label: **Data Not Collected** (everything is on-device; RevenueCat uses anonymous ID — if you keep that answer, declare "Purchases" as collected and linked via RevenueCat)
- [x] Export compliance: NO (encryption flag already set)
- [ ] Age rating: **4+** — no objectionable content, crisis resources do not change rating
- [ ] Confirm Privacy Policy URL is filled in App Store Connect (same content as in-app)
