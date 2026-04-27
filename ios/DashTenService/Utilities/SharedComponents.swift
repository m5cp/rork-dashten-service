import SwiftUI

struct ProgressRing: View {
    let progress: Double
    let size: CGFloat
    let lineWidth: CGFloat
    let color: Color

    init(progress: Double, size: CGFloat = 80, lineWidth: CGFloat = 8, color: Color = AppTheme.forestGreen) {
        self.progress = progress
        self.size = size
        self.lineWidth = lineWidth
        self.color = color
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.15), lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: min(progress, 1.0))
                .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 0.6), value: progress)
        }
        .frame(width: size, height: size)
    }
}

struct SectionHeader: View {
    let title: String
    let icon: String?
    let action: (() -> Void)?

    init(_ title: String, icon: String? = nil, action: (() -> Void)? = nil) {
        self.title = title
        self.icon = icon
        self.action = action
    }

    var body: some View {
        HStack {
            if let icon {
                Image(systemName: icon)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(AppTheme.forestGreen)
            }
            Text(title)
                .font(.headline.weight(.bold))
            Spacer()
            if let action {
                Button("See All", action: action)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppTheme.forestGreen)
            }
        }
    }
}

struct CardView<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(16)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))
    }
}

struct StatusBadge: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(.caption2.weight(.bold))
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(color.opacity(0.15))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }
}

struct SupportContactCard: View {
    private let supportURL: URL? = URL(string: "https://apps.apple.com/account/billing")

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Support & Billing", systemImage: "questionmark.circle.fill")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(AppTheme.forestGreen)
            Text("For purchase, billing, refund, or restore questions, manage your purchase from your Apple ID. For app feedback or bug reports, use the App Store \"Report a Problem\" link on the DashTen listing.")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.primary.opacity(0.8))
            if let supportURL {
                Link(destination: supportURL) {
                    HStack(spacing: 6) {
                        Image(systemName: "creditcard.fill")
                            .font(.caption.weight(.bold))
                        Text("Manage Apple ID Purchases")
                            .font(.caption.weight(.bold))
                        Image(systemName: "arrow.up.right")
                            .font(.caption2.weight(.bold))
                    }
                    .foregroundStyle(AppTheme.forestGreen)
                    .frame(minHeight: 44)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(AppTheme.forestGreen.opacity(0.06))
        .clipShape(.rect(cornerRadius: 12))
    }
}

struct NonAffiliationBanner: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Independent App", systemImage: "info.circle.fill")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(AppTheme.forestGreen)
            Text("This app is independently built and is not affiliated with, endorsed by, or sponsored by any branch of the U.S. military, the Department of Defense, or any federal, state, or local government agency.")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.primary.opacity(0.8))
        }
        .padding(14)
        .background(AppTheme.forestGreen.opacity(0.06))
        .clipShape(.rect(cornerRadius: 12))
    }
}

struct WelcomeFeaturePill: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption.weight(.bold))
            Text(text)
                .font(.caption.weight(.bold))
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(.white.opacity(0.15))
        .clipShape(Capsule())
    }
}

struct OfficialLinkButton: View {
    let title: String
    let url: String

    var body: some View {
        if let linkURL = URL(string: url) {
            Link(destination: linkURL) {
                HStack {
                    Image(systemName: "arrow.up.right.square")
                    Text(title)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.primary.opacity(0.5))
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(AppTheme.forestGreen)
                .padding(14)
                .background(AppTheme.forestGreen.opacity(0.08))
                .clipShape(.rect(cornerRadius: 10))
            }
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption.weight(.bold))
                .foregroundStyle(isSelected ? .white : .primary)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(isSelected ? AppTheme.forestGreen : Color(.secondarySystemGroupedBackground))
                .clipShape(Capsule())
        }
    }
}

struct CelebrationOverlay: View {
    @Binding var isShowing: Bool
    let title: String
    let subtitle: String

    var body: some View {
        if isShowing {
            ZStack {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture { withAnimation(.spring) { isShowing = false } }

                VStack(spacing: 20) {
                    Image(systemName: "party.popper.fill")
                        .font(.system(size: 56))
                        .foregroundStyle(AppTheme.gold)
                        .symbolEffect(.bounce, value: isShowing)

                    Text(title)
                        .font(.title2.bold())

                    Text(subtitle)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary.opacity(0.8))
                        .multilineTextAlignment(.center)

                    Button {
                        withAnimation(.spring) { isShowing = false }
                    } label: {
                        Text("Keep Going!")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 14)
                            .background(AppTheme.forestGreen)
                            .clipShape(Capsule())
                    }
                }
                .padding(32)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 24))
                .shadow(color: .black.opacity(0.2), radius: 20, y: 10)
                .padding(32)
                .transition(.scale.combined(with: .opacity))
            }
        }
    }
}

struct GradientHeroCard<Content: View>: View {
    let color: Color
    @ViewBuilder let content: Content

    var body: some View {
        content
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                LinearGradient(
                    colors: [color, color.opacity(0.8)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(.rect(cornerRadius: 20))
    }
}

struct CompactStatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.body.weight(.semibold))
                .foregroundStyle(color)
            Text(value)
                .font(.headline.weight(.bold))
                .foregroundStyle(color)
            Text(label)
                .font(.caption2.weight(.bold))
                .foregroundStyle(.primary.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(color.opacity(0.08))
        .clipShape(.rect(cornerRadius: 12))
    }
}
