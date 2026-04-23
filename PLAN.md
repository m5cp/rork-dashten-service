# Fix text wrapping on Today countdown and Document status chips

**What I found**

1. **Today page hero card** — The big "days until separation" number is wrapping mid-number (e.g. "1,09 / 5") because the digits are being squeezed next to the "days / until separation" label. For long stays (over a year), showing 1,095 days is also hard to read.

2. **Documents page status chips** — The status buttons ("Needed", "Requested", "Received", "Verified") are hyphenating into "Need-ed", "Request-ed", "Re-ceived", "Veri-fied" because the chip row is too tight.

**What I'll change**

- **Today countdown display**
  - When the countdown is 365 days or less: show the whole number of days (e.g. "180 days until separation") as today.
  - When it's more than 365 days: switch to a "Years · Months · Days" format (e.g. "2y 11mo 30d until separation"), so the number stays short and never splits.
  - Make sure the number never breaks across lines — it will shrink slightly if needed to fit, and keep its big bold styling.

- **Document status chips**
  - Remove hyphenation so words like "Requested" and "Received" wrap to a second line instead of breaking with a dash.
  - Allow the chip to grow to two lines of text when space is tight, keeping the full word readable.

No other screens, features, or content will be touched.