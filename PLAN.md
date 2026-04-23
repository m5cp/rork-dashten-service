# Redesign hero card so the countdown never gets cut off

## The problem

Right now the greeting, countdown, and phase badge all fight for space on the same row. When the countdown is long (like "2 yrs 1 mo 36 days until separation"), the numbers and unit labels get squished into things like "2y… 1'… 36(d…" — it looks broken.

## The fix — a cleaner two-row hero

**Top row (unchanged feel):** Greeting, name, and branch on the left. Progress ring on the right.

**Bottom area — redesigned countdown block:**
- The big countdown sits on its own full-width row, with plenty of breathing room. Numbers and unit labels ("yrs", "mos", "days") are always fully visible — no truncation, no dashes, no cut-offs.
- Each number+unit pair is grouped tightly so they never break apart mid-word. If the value is huge, the whole block scales down together instead of chopping letters.
- "until separation" sits directly beneath the numbers as a clean subtitle, left-aligned — not squeezed to the side.
- The phase badge ("18–24 Months Out • Start planning early") moves to its own subtle pill on a separate line below the countdown, so it never competes for width.

**Visual polish:**
- A thin gold divider separates the countdown from the phase pill for a premium, organized feel.
- Slightly tighter vertical padding so the card stays compact despite the extra row.
- Same green gradient background, same rounded corners — just a calmer, more readable layout.

## Result

The hero card reads top-to-bottom like a proper dashboard: who you are → your progress → how long until separation → what phase you're in. Nothing is ever abbreviated or cut off, regardless of whether the user has 12 days or 4 years left.