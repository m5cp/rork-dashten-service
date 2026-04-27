import SwiftUI
import StoreKit
import RevenueCat

struct PaywallView: View {
    var store: StoreViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var appeared: Bool = false
    @State private var showTerms: Bool = false
    @State private var showPrivacy: Bool = false
    @State private var showRedeemCode: Bool = false

    private let transformations: [(before: String, after: String, icon: String)] = [
        ("Overwhelm and scattered notes", "One clear roadmap you trust", "map.fill"),
        ("Missed enrollment deadlines", "Countdowns for every benefit", "calendar.badge.exclamationmark"),
        ("Military jargon on your resume", "Civilian-ready language", "doc.text.fill"),
        ("Guessing what comes next", "Week-by-week plan to day 90", "calendar.badge.clock"),
        ("Negotiating blind", "Know your number before you ask", "hand.raised.fill")
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    headerSection
                    transformationSection
                    featuresSection
                    purchaseSection
                    trustRow
                    restoreButton
                    redeemCodeButton
                    legalSection
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.secondary)
                    }
                    .accessibilityLabel("Close paywall")
                    .frame(minWidth: 44, minHeight: 44)
                }
            }
            .alert("Error", isPresented: .init(
                get: { store.error != nil },
                set: { if !$0 { store.error = nil } }
            )) {
                Button("OK") { store.error = nil }
            } message: {
                Text(store.error ?? "")
            }
            .onChange(of: store.isPremium) { _, isPremium in
                if isPremium { dismiss() }
            }
            .onAppear {
                withAnimation(.spring(response: 0.7)) { appeared = true }
            }
            .sheet(isPresented: $showTerms) {
                TermsOfUseView()
            }
            .sheet(isPresented: $showPrivacy) {
                PrivacyPolicyView()
            }
            .offerCodeRedemption(isPresented: $showRedeemCode) { _ in
                Task { await store.checkStatus() }
            }
        }
    }

    private var redeemCodeButton: some View {
        Button {
            showRedeemCode = true
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "gift.fill")
                    .font(.subheadline.weight(.bold))
                Text("Have a code? Redeem here")
                    .font(.subheadline.weight(.bold))
            }
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity)
            .frame(minHeight: 44)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
        .accessibilityLabel("Redeem an offer code for a free or discounted subscription")
    }

    private var headerSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [AppTheme.gold.opacity(0.3), AppTheme.forestGreen.opacity(0.15), .clear],
                            center: .center,
                            startRadius: 20,
                            endRadius: 80
                        )
                    )
                    .frame(width: 140, height: 140)
                    .blur(radius: 8)

                Image(systemName: "arrow.up.forward.circle.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(AppTheme.forestGreen)
                    .symbolEffect(.pulse, options: .repeating.speed(0.5))
            }
            .opacity(appeared ? 1 : 0)
            .scaleEffect(appeared ? 1 : 0.8)
            .accessibilityHidden(true)

            VStack(spacing: 8) {
                Text("DashTen Pro")
                    .font(.largeTitle.bold())

                Text("Your entire transition, handled")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 10)

            HStack(spacing: 20) {
                PaywallStatBadge(value: "11", label: "Pro Tools")
                PaywallStatBadge(value: "2", label: "Pro Guides")
                PaywallStatBadge(value: "∞", label: "Updates")
            }
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 10)
        }
        .padding(.top, 20)
        .padding(.bottom, 24)
        .padding(.horizontal, 16)
    }

    private var transformationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "arrow.triangle.swap")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(AppTheme.forestGreen)
                Text("What changes for you")
                    .font(.headline.weight(.bold))
            }
            .padding(.horizontal, 20)

            VStack(spacing: 10) {
                ForEach(Array(transformations.enumerated()), id: \.offset) { _, item in
                    HStack(alignment: .center, spacing: 12) {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 6) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.caption.weight(.bold))
                                    .foregroundStyle(.secondary)
                                Text(item.before)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.secondary)
                                    .strikethrough()
                            }
                            HStack(spacing: 6) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.caption.weight(.bold))
                                    .foregroundStyle(AppTheme.forestGreen)
                                Text(item.after)
                                    .font(.subheadline.weight(.bold))
                                    .foregroundStyle(.primary)
                            }
                        }
                        Spacer(minLength: 0)
                        Image(systemName: item.icon)
                            .font(.title3)
                            .foregroundStyle(AppTheme.forestGreen)
                            .frame(width: 36, height: 36)
                            .background(AppTheme.forestGreen.opacity(0.1))
                            .clipShape(.rect(cornerRadius: 10))
                    }
                    .padding(14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(.rect(cornerRadius: 14))
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.bottom, 24)
    }

    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "star.fill")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(AppTheme.gold)
                Text("Everything included")
                    .font(.headline.weight(.bold))
            }
            .padding(.horizontal, 20)

            VStack(spacing: 0) {
                ForEach(Array(proFeatures.enumerated()), id: \.offset) { index, feature in
                    HStack(spacing: 14) {
                        Image(systemName: feature.icon)
                            .font(.body.weight(.semibold))
                            .foregroundStyle(AppTheme.forestGreen)
                            .frame(width: 32, height: 32)
                            .background(AppTheme.forestGreen.opacity(0.1))
                            .clipShape(.rect(cornerRadius: 8))

                        VStack(alignment: .leading, spacing: 2) {
                            Text(feature.title)
                                .font(.subheadline.weight(.bold))
                            Text(feature.subtitle)
                                .font(.caption.weight(.medium))
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Image(systemName: "checkmark")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(AppTheme.forestGreen)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 11)

                    if index < proFeatures.count - 1 {
                        Divider()
                            .padding(.leading, 62)
                    }
                }
            }
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 16))
            .padding(.horizontal, 16)
        }
        .padding(.bottom, 24)
    }

    private let proFeatures: [(icon: String, title: String, subtitle: String)] = [
        ("doc.text.fill", "Resume Translator", "Convert military jargon to civilian language"),
        ("person.fill.questionmark", "Interview Prep", "Practice with flashcards & coaching tips"),
        ("mic.fill", "Elevator Pitch Builder", "Craft your 30/60/90-second intro"),
        ("person.3.fill", "Networking Hub", "Track contacts, events, and follow-ups"),
        ("scalemass.fill", "Job Offer Compare", "Side-by-side total compensation analysis"),
        ("hand.raised.fill", "Salary Negotiation", "Know your worth and ask for it"),
        ("calendar.badge.clock", "90-Day Planner", "Week-by-week post-hire plan"),
        ("book.fill", "Transition Journal", "Daily guided prompts and reflections"),
        ("chart.xyaxis.line", "Wellness Check-In", "Track well-being over time"),
        ("book.closed.fill", "Civilian Playbook", "Navigate unspoken civilian norms"),
        ("flag.fill", "First 30 Days Guide", "Week-by-week separation plan")
    ]

    private var purchaseSection: some View {
        VStack(spacing: 14) {
            if store.isLoading {
                ProgressView()
                    .padding(.vertical, 20)
            } else if let current = store.offerings?.current {
                ForEach(current.availablePackages, id: \.identifier) { package in
                    purchaseButton(package: package)
                }

                if store.isPurchasing {
                    ProgressView()
                        .tint(AppTheme.forestGreen)
                }
            } else {
                VStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                    Text("Unable to load pricing")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                    Button("Try Again") {
                        Task { await store.fetchOfferings() }
                    }
                    .font(.subheadline.weight(.bold))
                    .frame(minHeight: 44)
                }
                .padding(.vertical, 16)
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 14)
    }

    private func purchaseButton(package: Package) -> some View {
        let price = package.storeProduct.localizedPriceString
        let decimalPrice = package.storeProduct.price as NSDecimalNumber
        let anchorPrice = anchorPriceString(from: decimalPrice)
        let perDay = perDayString(from: decimalPrice)

        return Button {
            Task { await store.purchase(package: package) }
        } label: {
            VStack(spacing: 10) {
                HStack(alignment: .firstTextBaseline, spacing: 10) {
                    if let anchorPrice {
                        Text(anchorPrice)
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(.white.opacity(0.55))
                            .strikethrough()
                    }
                    Text(price)
                        .font(.system(size: 38, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }

                Text("Lifetime Access — One-Time Purchase")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.white)

                if let perDay {
                    Text("That's about \(perDay) a day for the next year — then free forever.")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.85))
                        .multilineTextAlignment(.center)
                }

                Text("BEST VALUE")
                    .font(.caption2.weight(.heavy))
                    .foregroundStyle(AppTheme.forestGreen)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(AppTheme.gold)
                    .clipShape(Capsule())
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 22)
            .padding(.horizontal, 16)
            .background(
                LinearGradient(
                    colors: [AppTheme.forestGreen, Color(red: 0.15, green: 0.32, blue: 0.15)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .clipShape(.rect(cornerRadius: 16))
            .shadow(color: AppTheme.forestGreen.opacity(0.3), radius: 12, y: 6)
        }
        .disabled(store.isPurchasing)
        .opacity(store.isPurchasing ? 0.7 : 1)
        .sensoryFeedback(.impact(weight: .medium), trigger: store.isPurchasing)
        .accessibilityLabel("Unlock DashTen Pro for \(price), one-time purchase")
    }

    private func anchorPriceString(from price: NSDecimalNumber) -> String? {
        let value = price.doubleValue
        guard value > 0 else { return nil }
        let anchor = value * 4
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: anchor))
    }

    private func perDayString(from price: NSDecimalNumber) -> String? {
        let value = price.doubleValue
        guard value > 0 else { return nil }
        let perDay = value / 365.0
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: perDay))
    }

    private var trustRow: some View {
        VStack(spacing: 8) {
            HStack(spacing: 14) {
                TrustBadge(icon: "checkmark.shield.fill", label: "One-time")
                TrustBadge(icon: "xmark.circle.fill", label: "No sub")
                TrustBadge(icon: "arrow.down.circle.fill", label: "Free updates")
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }

    private var restoreButton: some View {
        Button {
            Task { await store.restore() }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "arrow.clockwise")
                    .font(.subheadline.weight(.bold))
                Text("Restore Purchases")
                    .font(.subheadline.weight(.bold))
            }
            .foregroundStyle(AppTheme.forestGreen)
            .frame(maxWidth: .infinity)
            .frame(minHeight: 48)
            .background(AppTheme.forestGreen.opacity(0.1))
            .clipShape(.rect(cornerRadius: 12))
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
        .accessibilityLabel("Restore previous purchases")
    }

    private var legalSection: some View {
        VStack(spacing: 8) {
            Text("Payment is charged at time of purchase. This is a one-time, non-recurring purchase. No subscription required. Purchases are tied to your Apple ID — restore is available anytime.")
                .font(.caption2.weight(.medium))
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)

            HStack(spacing: 16) {
                Button("Terms of Use") { showTerms = true }
                Button("Privacy Policy") { showPrivacy = true }
            }
            .font(.caption2.weight(.semibold))
            .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 40)
    }
}

private struct TrustBadge: View {
    let icon: String
    let label: String

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption.weight(.bold))
                .foregroundStyle(AppTheme.forestGreen)
            Text(label)
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 10))
    }
}

private struct PaywallStatBadge: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3.weight(.bold))
                .foregroundStyle(AppTheme.forestGreen)
            Text(label)
                .font(.caption2.weight(.bold))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(AppTheme.forestGreen.opacity(0.06))
        .clipShape(.rect(cornerRadius: 12))
    }
}

