# Fix the broken Roadmap screen and audit cross-app links

## The bug

When you tap the Roadmap card in Tools (or open Roadmap from Home's "See all tasks", Learn, Search, or the Readiness dashboard), it pushes onto a navigation stack that **already exists** — but the Roadmap screen also creates its own navigation stack inside itself. Two stacks nested together is why you see a blank white screen with just a tiny warning icon and a back button.

## The fix

- **Remove the duplicate navigation wrapper inside the Roadmap screen** so it renders correctly wherever it's opened from — Tools, Home, Learn, Search, the iPad sidebar, and the Readiness dashboard.
- **Verify the Roadmap title, menu (Add Custom Task / Export PDF), and inner navigation** (tapping a category → tasks → phase detail) all still work after the wrapper is removed.

## Full app audit at the same time

I'll walk every navigation entry point and confirm nothing is dead or orphaned:

- **Home tab** — "See all tasks", "Today's focus" buttons, milestone cards, retention cards, the AI coach button, profile/streak shortcuts.
- **Tools tab** — every category card, every tool row inside Money / Career / Planning, the State Benefits hero card, search results.
- **Learn tab** — every benefit, guide, and article link, plus the "First Year Guide" cross-link.
- **Profile tab** — Edit profile, subscription, notifications, theme, share progress, delete data, getting-started walkthrough.
- **Deep links** — `dashten://today`, `dashten://plan`, `dashten://tools`, `dashten://learn`, `dashten://profile`.
- **Widgets and Siri shortcuts** — daily check-in, open mission, track contact.
- **Paywall** — opens from onboarding finish, locked tools, and Profile upgrade.

For anything dead or misrouted, I'll wire it to the correct destination and note it in the summary.

## What you'll see after

- Tapping **Transition Roadmap** from any place in the app opens the real Roadmap screen with the overall progress card, current-phase pill, and the category grid (Admin, Health, Finance, Employment, Family, Housing, Education) — no more blank screen.
- The top-right "⋯" menu still offers **Add Custom Task** and **Export to PDF**.
- Category → task → phase detail navigation works end-to-end.
- The post-service version of the roadmap (for already-separated users) renders correctly too.

Build will be verified before I hand it back.