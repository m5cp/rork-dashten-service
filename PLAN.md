# Apply DashTen design standard across every tool and view


## What this does

This sweep turns DashTen into a clean, Apple-quality experience. Every tool screen will feel obvious, fast, and uncluttered — no explainer cards, no "Calculate" buttons, no loud disclaimers. Just inputs, live results, and a quiet one-line footer.

## Across every tool screen

- Remove intro/explainer cards at the top — the title and the controls do the talking.
- Remove "Calculate," "Estimate," and "Compare Options" buttons. Results update live as you change inputs.
- Replace big disclaimer banners and orange warning boxes with a single small line at the bottom:
  *"General information only · Not affiliated with any government agency"*
- Soften official-sounding language ("you must," "the VA requires," "under federal law," "consult a professional") into plain, friendly explanations.

## Visual standard

- Cards use a consistent grouped-background color, rounded corners (14pt outer, 10pt inner), 16pt horizontal / 14pt vertical padding, 16pt spacing between cards, and 40pt scroll bottom padding.
- Typography hierarchy: bold headlines for sections, readable subheadline/body inside cards, semibold secondary captions for supporting detail, and big bold numbers for results.
- Body text wraps cleanly — no more cut-off words or text bleeding outside cards.
- Sliders show their current value on the right in the accent color; number fields use the decimal keypad.
- Results are always visible. Before inputs are entered, show a clean "—" placeholder.
- Empty states show a centered muted icon plus one short line — never a blank screen.
- Smooth spring animations on expansions; subtle haptic feedback on toggles.

## Buttons and rows

- Primary buttons: full-width, bold white text on forest green, rounded 14pt.
- Every tappable row is at least 44pt tall and tappable across the full row (not just the text).
- Rows that navigate get a small chevron on the right.

## Navigation titles

All tool screens use inline titles with short, plain names:

- "TSP Options" instead of "Research TSP Tool View"
- "SCRA Protections" instead of "SCRA Protections Reference Guide"
- "VA Loan Basics" instead of "VA Home Loan Guide"
- "Move Budget" instead of "Relocation Cost Estimator"
- "Pay Help" instead of "Financial Readiness Resources"

## Scope

This pass applies to every existing tool view (the full Tools folder plus calculators, planners, and reference screens) and becomes the standard for any new screen going forward. No logic, data, routing, or navigation will change — only the look, copy, and interaction polish.

After the pass, the app will be built and verified so every tool still opens correctly.
