# Consolidate Plan tab, unify guides, iPad sidebar, label streak, fix paywall

### What you'll get

**1. One single Plan tab (no more duplicates)**

- The leftover unused Plan screen will be removed so there's only one Plan experience to maintain.
- Anything useful from the unused version (planning areas grid, documents card with progress, tools list) will be merged into the live Plan screen where it adds value.

**2. One source of truth for guide content**

- The First 30 Days, Mindset Shifts, and Civilian Playbook content currently exists in two places. I'll keep one shared library of guide content and have both the guide screens and the "Learn" tab read from it. Edits made in one place will reflect everywhere automatically.

**3. iPad sidebar layout**

- On iPad, the Plan and Tools tabs will use a true sidebar + detail layout (Apple-style split view). Tap a category on the left, see its content on the right — no more giant stretched phone-style screens.
- iPhone layout stays exactly the same.

**4. Home screen streak — clearer label**

- The streak strip will be re-labeled so it's obvious what it tracks: **"Active days"** with a short helper line like *"Open the app or complete a task to keep it going."*
- A small info tap will explain the rules (one day per calendar day of activity).

**5. Paywall pricing fix**

- The paywall will correctly render every package RevenueCat returns (Monthly + Annual when both are configured).
- I'll also harden the fallback so if RevenueCat hasn't loaded yet, you see both Monthly and Annual placeholders instead of a single option.
- If only $0.99 is showing live, that's a RevenueCat dashboard config issue I'll flag with steps to fix on your side (the app code will be ready for both).

### Design feel

- Sidebar uses standard iOS materials and the app's forest-green accent for selection — feels like Settings on iPad.
- Streak strip keeps the same look, just gains a clear title and one-line description.
- Paywall keeps the current layout; just renders both plans correctly.

### Validation

- I'll run the iOS build checks after the changes and confirm everything compiles before handing back.

