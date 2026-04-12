import SwiftUI
import RevenueCat

struct PaywallView: View {
    var store: StoreViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var appeared: Bool = false

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
        ("flag.fill", "First 30 Days Guide", "Week-by-week separation plan"),
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    headerSection
                    featuresSection
                    purchaseSection
                    legalSection
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.secondary)
                    }
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
        }
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

            VStack(spacing: 8) {
                Text("DashTen Pro")
                    .font(.largeTitle.bold())

                Text("Unlock the full transition toolkit")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)
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
        .padding(.bottom, 28)
    }

    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "star.fill")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(AppTheme.gold)
                Text("What You Get")
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

    private var purchaseSection: some View {
        VStack(spacing: 14) {
            if store.isLoading {
                ProgressView()
                    .padding(.vertical, 20)
            } else if let current = store.offerings?.current {
                ForEach(current.availablePackages, id: \.identifier) { package in
                    Button {
                        Task { await store.purchase(package: package) }
                    } label: {
                        VStack(spacing: 6) {
                            Text(package.storeProduct.localizedPriceString)
                                .font(.title.bold())
                                .foregroundStyle(.white)
                            Text("Lifetime Access — One-Time Purchase")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.white.opacity(0.9))
                            Text("Includes all future updates")
                                .font(.caption.weight(.medium))
                                .foregroundStyle(.white.opacity(0.7))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
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
                }
                .padding(.vertical, 16)
            }

            Button {
                Task { await store.restore() }
            } label: {
                Text("Restore Purchases")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppTheme.forestGreen)
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
    }

    private var legalSection: some View {
        VStack(spacing: 8) {
            Text("Payment is charged at time of purchase. This is a one-time, non-recurring purchase. No subscription required.")
                .font(.caption2.weight(.medium))
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)

            HStack(spacing: 16) {
                Link("Terms of Use", destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!)
                Link("Privacy Policy", destination: URL(string: "https://www.apple.com/legal/privacy/")!)
            }
            .font(.caption2.weight(.semibold))
            .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 40)
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
