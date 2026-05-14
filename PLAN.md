# Fix blank page when tapping This Week's Mission

**The problem**

Tapping "This Week's Mission" on the home screen lands on a blank page because the home screen's navigation only knows how to open two destinations (the readiness dashboard and the self-assessment). The weekly missions destination was never wired up there, so the screen has nothing to show.

**The fix**

- Wire the home screen's navigation to open the full Weekly Missions screen when the mission card is tapped.
- Confirm the missions screen loads this week's missions (or generates them if empty) so users always see actionable tasks with tap-to-complete behavior and XP rewards.

