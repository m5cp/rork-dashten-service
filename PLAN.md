# Fix app launch crash caused by keyboard "Done" installer

**What's wrong**

The recent keyboard "Done" button setup hooks into the system in a way that accidentally affects every view in the app, causing it to crash immediately on launch before onboarding can show.

**Fix**

- Replace the global hook with a safe approach that only attaches the "Done" toolbar when a text field or text box actually appears on screen — without touching any shared system behavior.
- Keep the tap-anywhere-to-dismiss behavior intact.
- Keep the "Done" button look (forest green, semibold) unchanged.
- No changes to onboarding, screens, or any other logic.

**Result**

- App opens normally again.
- Onboarding flows through Welcome → Branch → Timeline → Goals → Disclaimer as before.
- Typing anywhere still shows a "Done" button above the keyboard, and tapping outside still dismisses it.

