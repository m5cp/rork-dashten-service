# Fix This Week card, add Upgrade to Pro on Home, and ship medium-priority polish

Here's what I'll build. I'm skipping the second paywall per your instructions.

## Home screen fixes

- **This Week — real 7-day view synced to phone calendar**
  - Replace the broken card with a horizontal row of 7 real weekday tiles (Mon–Sun of the current week, aligned to your device's calendar).
  - Each tile shows the weekday letter and the date number, highlights today, and marks days with activity (task completed, journal entry, check-in, or a calendar event that day).
  - Tapping a day opens a detail sheet showing everything on that date: tasks due/done, journal entries, check-ins, and any events from your phone's calendar (with your permission).
  - Requests calendar read access the first time you tap a day; shows a clean explainer if you decline.

- **Upgrade to Pro — prominent card near the top**
  - New gold/green "Unlock Pro" card sits just under the green hero (above Your Focus) for free users.
  - Shows "11 tools • 2 guides • one-time" with a clear Upgrade button that opens the existing paywall.
  - Automatically hides once you're a Pro member.

## Medium-priority builds

- **Home screen widget** — small and medium sizes showing days until separation, current phase, and today's focus task. Tapping opens the app to Today.
- **Siri Shortcuts & App Intents** — "Log today's task", "Open my plan", "Check my readiness" as Siri phrases and Shortcuts actions.
- **Live Activity countdown** — optional Live Activity on the Lock Screen / Dynamic Island showing days until separation and your current focus; togglable from Profile.
- **Shareable progress card** — new "Share my progress" action that generates a beautiful image card (readiness %, days in, branch, streak) with a pre-filled caption, ready for Messages/Instagram/X.
- **Milestone & deadline notifications** — local reminders at 7/30/90-day milestones and for time-sensitive items (benefits enrollment windows, 6-month/90-day/30-day phase changes). Opt-in toggle in Profile.
- **Analytics scaffold** — lightweight, privacy-respecting event logger capturing app opens, screen views, onboarding steps, paywall shown/dismissed/converted, feature usage, subscription events. No third-party SDK added; events are logged and ready to wire to any provider later.

## What I won't touch
- Onboarding flow, Profile information entry, paywall design, Learn/Plan/Tools tabs — all working, leaving them alone.
- No second paywall.

After you approve, I'll implement in this order: This Week fix → Upgrade card → widget → notifications → share card → Siri → Live Activity → analytics. Each ships buildable so nothing breaks in between.