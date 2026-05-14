# Fix cut-off text across the app

**The problem**
On screens like Achievements, badge names ("Mission Briefing", "Interview Sharp") wrap awkwardly, and descriptions like "Compared compensation pac…" get cut off with an ellipsis. Similar truncation happens in a few other lists and cards across the app.

**What I'll do**

- Switch the Achievements grid from 3 cramped columns to 2 roomier columns so every badge name and description fits in full, with extra vertical breathing room.
- Let badge titles and descriptions expand to as many lines as they need instead of being cut off.
- Sweep the rest of the app (Home cards, Plan items, Roadmap steps, Tools tiles, Learn cards, Profile rows, Search results) and remove or relax the strict line limits on any title or description that was being truncated, so users can always read the full text.
- Make sure long words still wrap cleanly and don't break card layouts.

**Result**
No more "…" cut-offs on titles or descriptions anywhere in the app — every label reads in full.