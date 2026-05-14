# Polish all tools, plans & guides to Apple-grade quality

## Theme & Appearance
- [x] Appearance setting in Profile (Light / Dark / System) — already wired via `ThemePreference` and `.preferredColorScheme` in `ContentView`.

## iPad-ready everywhere
- [x] `readableContentWidth()` modifier added (`Utilities/ReadableWidth+Extension.swift`) and applied across all Tools, Plan, Roadmap, Learn, Benefits, Wellness, Today, Documents, Search, calculators and planning wrappers.

## Fix what's broken or half-finished
- [x] Daily Power-Up Quick Actions wired to Journal / Check-In / Goals / Networking routes.
- [x] Resume Translator "Try AI Lookup" replaced with a working "Search Jargon Lookup" handoff into the Jargon tab.
- [x] GI Bill BAH Calculator: added Full-time / 3/4 / Half-time / Online segmented picker; results react to selection.
- [x] Interview Prep: coaching tips now shown inline under every question — no hidden toggle.
- [x] BRS / all `PayInputRow` fields: switched to `.decimalPad` keyboard.

## Merge duplicates & remove dead code
- [x] Deleted unused `BulletPoint` helper.
- [x] Deleted orphaned `PlanningHubView`; extracted `PlanningRoute`, planning wrappers and `Guide*` primitives into proper homes.
- [ ] (Out of scope per plan) GuideContents duplicates and consolidating the two Plan views.

## Negotiation Playbook
- [x] Rebuilt `SalaryNegotiationView` as a Negotiation Playbook: Know-Your-Number worksheet, levers, email + verbal scripts (copy to clipboard), objection handling, veteran angles, pre-call checklist.

## Sweep small consistency issues
- [x] SCRA: hero now spells out "Servicemembers Civil Relief Act" with subtitle context.
- [x] Renamed "Pay Help" → "Financial Counseling".
- [x] Cost of Living: 2024 baseline footnote added.
- [x] Move Budget: "How this is estimated" disclosure added.

## Out of scope
- iPad sidebar/detail layout
- Apple-Intelligence jargon lookup
- Consolidating PlanView vs PlanTabView
