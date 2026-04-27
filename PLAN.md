# Add "Redeem Code" option on paywall and in Settings

## Overview

Add a way for users to redeem **Offer Codes** you create in App Store Connect — perfect for giving out free subscriptions to testers, reviewers, friends, or promotional partners. When a user taps "Redeem Code," Apple's official redemption sheet slides up, they paste or type the code, and Apple handles the rest. RevenueCat automatically detects the new subscription and unlocks DashTen Pro instantly.

## How it will work for you (the developer)

1. In App Store Connect → your subscription → **Promotions** → **Offer Codes**, you create a campaign (e.g. "Free 3 months for beta testers")
2. Apple generates either a single shareable URL or a batch of one-time codes (up to 150,000 per quarter)
3. You share the code(s) with users
4. They tap "Redeem Code" inside DashTen and paste it in

## How it will work for users

- **On the paywall:** A small row with a gift icon labeled "Have a code? Redeem here" sits beneath the subscribe button, next to "Restore Purchases"
- **In Settings (Profile):** A new "Redeem a Code" row appears in the subscription/account area, so existing users (or someone you give a code to after they've installed the app) can redeem without seeing the paywall first
- Tapping either one launches Apple's native, trusted redemption sheet — no custom code entry UI, which means it works exactly like every other App Store redemption users have seen
- After successful redemption, the paywall (if open) automatically dismisses and Pro features unlock

## Design

- **Paywall button:** Small horizontal row — gift symbol on the left, "Have a code? Redeem" label, subtle secondary text styling so it sits quietly under the main subscribe button without competing visually
- **Settings row:** Standard list row with a gift icon and "Redeem a Code" title, matching the existing rows in the profile/subscription section
- Native iOS redemption sheet handles the rest — Apple-styled, dark-mode aware, accessible

## Notes

- Works on real devices and TestFlight; the simulator shows a placeholder since the App Store isn't available there
- No additional permissions or capabilities needed — uses StoreKit which is already part of the project via RevenueCat
- Once redeemed, the subscription appears in the user's Apple ID just like a normal purchase, and they can manage/cancel it the same way

