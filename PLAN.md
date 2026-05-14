# Consolidate Plan tab, unify guides, iPad sidebar, label streak, fix paywall

### What you'll get

**1. One single Plan tab (no more duplicates)** - [x]

- The leftover unused Plan screen has been removed so there's only one Plan experience to maintain.
- Useful pieces from the unused version (planning areas grid, documents card with progress, tools list) were merged into the live Plan screen.

**2. One source of truth for guide content** - [x]

- First 30 Days, Mindset Shifts, and Civilian Playbook now live in `GuideContents.swift` only.
- Both the guide screens and the Learn tab read from those shared content structs.

**3. iPad sidebar layout** - [x]

- On iPad, the Plan and Tools tabs use a true `NavigationSplitView` sidebar + detail layout.
- iPhone layout is unchanged.

**4. Home screen streak — clearer label** - [x]

- Streak strip is now titled **"ACTIVE DAYS"** with helper copy: *"Open the app or complete any task each day to grow your streak. Snowflakes protect a missed day."*

**5. Paywall pricing fix** - [x]

- Paywall iterates every package RevenueCat returns (Monthly + Annual when configured).
- Fallback shows both Monthly and Annual placeholders when offerings haven't loaded.
- If only $0.99 appears in production, that's a RevenueCat dashboard config issue — the app code is ready for both.

### Validation

- iOS build checks passed.
