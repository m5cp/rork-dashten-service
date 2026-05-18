# Wire the "Why DashTen" stats screen into onboarding

**The issue**

The new stats screen ("Why this matters") was added to the onboarding file but never inserted into the actual page sequence, so it never appeared during onboarding.

**The fix**

- Slot the "Why DashTen" stats screen into the onboarding flow as the second-to-last page, right before the Disclaimer.
- New order: Welcome → Branch → Timeline → Concerns → **Why DashTen (stats)** → Disclaimer (6 pages total).
- Update the progress bar and page counter so it reflects the new total.
- Make sure the Skip button, Next/Continue button, and bottom bar logic all still work correctly on the new page.
- Verify the entrance animations on each stat card fire when the page first appears (not just on first app load).

**Result**

During onboarding, after answering the concerns step, users will see the stats screen with the five real-world numbers (200K+ separating, 63% unaware of VA financial counseling, 40% never use GI Bill, 36% claims denied, 100K+ records backlog) before reaching the final disclaimer.