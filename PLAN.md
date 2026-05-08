# Redesign Home tab with premium liquid-glass feel

## Overview
Rename **Today** → **Home**, remove the Roadmap section, and rebuild the screen so a user understands their status in under 3 seconds. The new layout uses a calm, premium liquid-glass aesthetic with large typography and soft gradients — nothing busy, nothing redundant.

## What changes

**Tab rename**
- Bottom tab labeled "Today" becomes "Home" with a house icon.

**Removed from Home**
- The Roadmap / phase section (and any duplicate phase progress block).
- Any redundant scroll-padding sections that made the page feel long.

## New Home screen — top to bottom

1. **Greeting + status hero (the 3-second answer)**
   - Personal greeting ("Good morning, [Name]")
   - One line that adapts to status:
     - Active/transitioning: "**147 days** until separation"
     - Retired/separated: "**Retired** · 4 months out"
   - Below it, a soft status pill: "On track" / "Needs attention" / "Civilian chapter"
   - Set on a soft gradient background with subtle liquid-glass layers — large, confident type.

2. **Readiness ring card**
   - A single elegant circular ring showing overall % ready, with a short caption ("Documents, benefits, and checklist combined"). Tap to open Readiness Dashboard.

3. **Today's Focus**
   - One single task card — the most important next action.
   - Big check button with haptic + celebration when completed.
   - Small "See all tasks" link to the Plan tab.

4. **Streak strip**
   - A clean 7-day dot row with today highlighted, plus current streak number. No extra chrome.

5. **Daily Insight**
   - One rotating insight card (tip, common mistake, or benefit spotlight) — glass card with a soft accent.

That's it. No quick-actions row, no roadmap, no duplicate progress bars. The page fits roughly one scroll on most phones.

## Visual design
- **Liquid-glass** layered cards with translucent fills and soft inner highlights (uses iOS 26 glass effect where available, ultra-thin material fallback).
- **Soft gradient backdrop** that shifts subtly based on time of day (dawn / day / dusk / night).
- **Large display typography** for the hero number (days remaining or "Retired") — confident, magazine-style.
- **Forest green + gold accents** kept consistent with the rest of the app.
- **Micro-interactions**: gentle entrance animations, spring on tap, haptic on completion, ring fills with a smooth animation when readiness changes.

## Pages affected
- **Home tab** (formerly Today): fully redesigned as described.
- **Tab bar**: label and icon update only.

No other tabs, data, or flows are changed.