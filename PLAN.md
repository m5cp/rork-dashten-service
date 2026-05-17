# Remove Plan tab and rebuild Roadmap as a tool inside the Planning section

## What changes

**Bottom tab bar** drops from 5 tabs to 4: Home · Tools · Learn · Profile. The Plan tab and its "Your Roadmap" timeline view go away as a tab destination.

**Roadmap moves into Tools → Planning** as a new tool entry that opens the full phased roadmap (pre-separation phases, post-service phases, current phase tasks, overdue tasks, export to PDF — everything the Plan tab did, styled to match the other planning tools).

## Pages / Screens

- **Tools tab → Planning category**: A new "Transition Roadmap" tool appears at the top of the Planning list with a map icon. Tapping it opens the full roadmap experience (your phases, current focus, tasks per phase, PDF export, manual phase override) — same content the Plan tab had, just re-skinned to match the other tools.
- **Home tab**: Any buttons or cards that previously jumped to the Plan tab (e.g. "View Roadmap", readiness boost rows, "Open in Roadmap" callouts) now route to Tools → Planning → Transition Roadmap.
- **Deep links**: `dashten://plan` continues to work and now lands on Tools → Planning → Transition Roadmap so widgets, Siri shortcuts, and notifications keep functioning.
- **iPad sidebar**: The Plan section is removed from the sidebar; Roadmap stays accessible under Tools → Planning to mirror the phone layout.
- **Tab bar**: Now Home · Tools · Learn · Profile. Selected indices and analytics names update to match.

## Design

- The new Roadmap tool entry uses the same row styling as other Planning tools (icon tile, title, subtitle, chevron). Opens into a full screen that keeps the phase cards, task list, current-phase header, PDF export menu, and manual phase override exactly as they work today — re-using the existing roadmap UI so nothing visual is lost.
- No changes to colors, fonts, or layout language elsewhere; the rest of Tools, Home, Learn, and Profile are untouched.

## Connectors verified

- Home "open roadmap" actions, readiness dashboard "Open in Roadmap" links, the Getting Started walkthrough's "Review Your Roadmap" step, search results for "roadmap", widget deep links, and Siri intents are all rewired to land on the new Tools → Planning → Roadmap location.
- PDF export, notifications (`scrollToRoadmap`), and the post-service roadmap variant continue to work unchanged inside the new location.
- Build and run checks after the changes to confirm no broken references.

## What stays the same

- The roadmap content, phase logic, post-service vs pre-separation switching, and PDF export are unchanged — only the entry point moves.
- Tools, Learn, Profile, Home, onboarding, and paywall behavior are untouched.

