# Fix retired-user phase detection + smarter rating prompt

## What's wrong today
The Plan screen always says "18–24 Months Out" — even for retired users with every pre-separation task done. That phase logic ignores whether you've already separated, and there's no way to override it.

The rating prompt currently fires after 3 sessions and never again. It doesn't wait for a positive moment, and it can't return later.

## Fixes

**Smarter phase detection on the Plan tab**
- If you marked yourself as Separated / Retired in onboarding (or set a past separation date), the Plan screen will now show a post-service phase (First 30 / First 90 / First Year / Year 2+) instead of "18–24 Months Out."
- The big hero card, the "Recommended Tasks" section, and the timeline preview will all reflect the correct phase.

**Manual phase confirmation button**
- A small "Change phase" control appears on the Plan hero card.
- Tap it to pick the phase you're actually in — useful if dates are off, you retired early, or you just want to skip ahead.
- Your choice is saved and overrides the auto-detected phase everywhere on the Plan tab.
- A "Use auto-detect" reset option is included.

**Rating prompt tied to wins, throttled to ~30 days**
- The prompt only appears after a clearly positive moment: a streak milestone (7/30/90 days), a badge earned, a roadmap phase fully completed, or readiness crossing 50% / 75% / 100%.
- After it shows (or you dismiss it), it won't reappear for at least 30 days, regardless of trigger.
- Uses Apple's built-in review request — Apple additionally caps to 3 prompts/year automatically, so it can never feel spammy.
- "Not now" simply resets the 30-day window; "Could be better" still routes to feedback without nagging for a rating.

## Result
A retired user sees their real post-service phase the moment they open Plan, with a manual override if anything ever looks off. The rating ask shows up only when you've just done something great, and only every 30+ days.