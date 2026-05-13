# DashTen — App Store Listing (Phase 4 draft)

Built around the searcher's actual job: a service member or veteran trying to land strong on the civilian side, not just get out safely. All keywords below were chosen from veteran-transition-intent search patterns (resume, VA, GI Bill, TAP, transition).

## Title (30 char max)
**DashTen: Military Transition** (29)

Alternates:
- DashTen: Veteran Transition (27)
- DashTen Military to Civilian (28)

## Subtitle (30 char max)
**Plan your ETS. Land strong.** (29)

Alternates:
- Resume, VA, GI Bill in one (26)
- ETS countdown & resume coach (28)

## Promotional Text (170 char max)
New: Apple Intelligence on-device coach, weekly readiness summary, and a 3-day free trial of DashTen Pro — interview prep, networking, first 90 days, and more.

## Keywords (100 char max, comma-separated, no spaces)
Pasted as a single line for App Store Connect — total 99 chars including commas:

```
veteran,military,transition,ETS,resume,VA,GIBill,TAP,SkillBridge,DD214,benefits,career,interview,TSP
```

Rationale:
- High-intent veteran terms first (`veteran`, `military`, `transition`, `ETS`)
- Outcome terms next (`resume`, `interview`, `career`)
- Branch/program terms (`TAP`, `SkillBridge`, `DD214`, `GIBill`)
- Benefits cluster (`VA`, `benefits`, `TSP`)

## Description (4000 char max — opening 3 lines visible without "more")

```
Plan your transition. Land strong on the civilian side.

DashTen turns the chaos of leaving the military into a single, calm plan — your ETS countdown, your roadmap, your benefits, your resume, all in one place. Free forever for the essentials.

WHAT YOU GET FREE
• ETS / retirement countdown and personalized roadmap
• Resume translator — all 6 branches, jargon → civilian language
• Document vault: DD-214, awards, evals, legal & estate checklist
• VA Home Loan + Funding Fee Calculator
• TSP options, growth estimator, BRS snapshot
• GI Bill BAH and education benefits calculators
• SCRA protections quick reference
• State Benefits Finder
• VA Healthcare guide + benefits by disability rating
• Readiness Score, XP, weekly missions, streaks and badges
• Apple Intelligence coach — runs on-device, never sends your data anywhere

DASHTEN PRO (3-DAY FREE TRIAL)
• Interview Prep — flashcard practice by category
• Elevator Pitch Builder — 30 / 60 / 90 second versions
• Networking Hub — contact and follow-up tracker
• Personal Brand Audit — score your professional presence
• First 90 Days Planner — week-by-week post-hire roadmap
• Transition Journal — guided daily prompts
• Wellness Check-In — track readiness over time
• Civilian Playbook — the unwritten rules of civilian work
• First 30 Days Guide — hit the ground running

PRIVACY YOU CAN TRUST
DashTen stores everything locally on your device. No accounts. No tracking. No advertising SDKs. Anonymous diagnostic events (like which tab you opened) are written to a local log on your device only — they never leave your phone.

NOT AFFILIATED
DashTen is an independent planning tool. It is not affiliated with, endorsed by, or sponsored by the U.S. Department of Defense, the Department of Veterans Affairs, any branch of the U.S. Armed Forces, or any government agency. Information in this app is general guidance only and is not legal, medical, financial, or career advice. Always verify benefits with official sources. If you are in crisis, call or text 988.

SUBSCRIPTION TERMS
DashTen Pro is offered as a monthly or annual auto-renewing subscription with a 3-day free trial for new subscribers. Payment is charged to your Apple ID at confirmation. Subscriptions renew automatically at the same price unless cancelled at least 24 hours before the end of the current period. Manage or cancel in your App Store account settings at any time. Restore Purchases and Redeem Code are available on every paywall.

• Privacy Policy: in-app under Profile → Privacy Policy
• Terms of Use: in-app under Profile → Terms of Use
```

## What's New (recent version notes)
- Apple Intelligence on-device coach
- Streak with guilt-free freeze and 7 / 30 / 90 day milestone cards
- Weekly summary on Home, monthly reassessment prompt
- Cleaner 4-screen onboarding
- Bigger, clearer subscription pricing and auto-renewal terms

---

# Screenshot copy outline (10 screenshots, outcome-led)

Each screenshot is two layers: a bold outcome headline at the top and a single supporting line below, with the actual screen behind it. No bullet lists, no UI tours. Designed to convert from search results alone (frames 1–3 work without taps).

### Frame 1 — Hook (most important)
- Top: **"Out in 187 days. Already in motion."**
- Sub: ETS countdown · readiness score · today's mission
- Background: Home tab with countdown + Readiness Score card

### Frame 2 — Outcome (job)
- Top: **"Translate your MOS into a job offer."**
- Sub: Resume translator across all 6 branches
- Background: Resume translator showing a 25B → "Systems Administrator" bullet

### Frame 3 — Outcome (benefits)
- Top: **"Every VA benefit you've earned. In one place."**
- Sub: VA Healthcare · Home Loan · GI Bill · Disability ratings
- Background: Benefits hub

### Frame 4 — Outcome (money)
- Top: **"Lock in your finances before day one."**
- Sub: TSP, BRS, VA Home Loan, income-gap calculator
- Background: Civilian Income Gap calculator with filled numbers

### Frame 5 — Trust
- Top: **"Documents you cannot afford to lose."**
- Sub: DD-214, awards, evals, legal & estate checklist
- Background: Documents view

### Frame 6 — Pro outcome
- Top: **"Walk into interviews ready."**
- Sub: Flashcards + 30 / 60 / 90-second elevator pitch
- Background: Interview Prep flashcard front

### Frame 7 — Pro outcome
- Top: **"The first 90 days, planned out."**
- Sub: Week-by-week roadmap for your new civilian job
- Background: First 90 Days Planner week view

### Frame 8 — Retention
- Top: **"Small wins, every day."**
- Sub: Streaks, weekly missions, milestone cards
- Background: Weekly summary card + streak

### Frame 9 — Privacy
- Top: **"Private by design."**
- Sub: Local-only. No account. No tracking SDKs.
- Background: Privacy Policy screen with the local-only badge

### Frame 10 — Brand close
- Top: **"Your transition. Your terms."**
- Sub: Free forever for the essentials · 3-day Pro trial
- Background: Onboarding hero (forest green + gold)

---

# Analytics event coverage (Phase 4)

Local-only diagnostic events (UserDefaults queue, never transmitted):

| Event | Fires when |
| --- | --- |
| `app_open` | App launches |
| `screen_view` | Home, plan, tools, learn, profile tab opened |
| `onboarding_step_viewed` | Each onboarding page is shown |
| `onboarding_completed` | User finishes onboarding |
| `feature_used` (`onboarding_skipped`) | Skip tapped on onboarding |
| `paywall_shown` | PaywallView appears |
| `paywall_dismissed` | PaywallView closes without conversion |
| `paywall_converted` | Purchase completes successfully |
| `feature_used` (`redeem_code_tapped`) | Redeem code button tapped |
| `feature_used` (`restore_tapped`) | Restore tapped |
| `feature_used` (`purchase_attempt` / `purchase_cancelled`) | Buy button / user cancellation |
| `subscription_started` | New Pro entitlement detected after purchase |
| `subscription_restored` | Pro entitlement restored |
| `feature_used` (`tool_opened` / `locked_tool_tapped`) | Any toolbox row tap |
| `feature_used` (`ai_coach_opened`) | Floating coach button |
| `feature_used` (`feedback_prompt_shown` / `review_requested`) | Existing feedback flow |
| `milestone_reached` | 7 / 30 / 90-day streak milestone |

> Privacy: every event above is written to a capped (500-record) ring buffer in `UserDefaults` on the user's device. No PII is collected, no network call is made, and the buffer is destroyed when the app is uninstalled. This is disclosed verbatim in the in-app Privacy Policy.
