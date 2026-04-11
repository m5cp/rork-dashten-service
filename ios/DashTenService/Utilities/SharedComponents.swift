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
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppTheme.forestGreen)
            }
            Text(title)
                .font(.headline)
            Spacer()
            if let action {
                Button("See All", action: action)
                    .font(.subheadline)
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
            .font(.caption2.weight(.semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(color.opacity(0.15))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }
}

struct CountdownView: View {
    let targetDate: Date

    private var components: (days: Int, label: String) {
        let calendar = Calendar.current
        let now = Date()
        let days = calendar.dateComponents([.day], from: now, to: targetDate).day ?? 0
        if days > 0 {
            return (days, days == 1 ? "day until separation" : "days until separation")
        } else if days == 0 {
            return (0, "Separation day")
        } else {
            return (abs(days), abs(days) == 1 ? "day since separation" : "days since separation")
        }
    }

    var body: some View {
        let info = components
        VStack(spacing: 4) {
            Text("\(info.days)")
                .font(.system(size: 44, weight: .bold, design: .default))
                .foregroundStyle(AppTheme.forestGreen)
                .contentTransition(.numericText())
            Text(info.label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

struct NonAffiliationBanner: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Independent App", systemImage: "info.circle.fill")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(AppTheme.forestGreen)
            Text("This app is independently built and is not affiliated with, endorsed by, or sponsored by any branch of the U.S. military, the Department of Defense, or any federal, state, or local government agency.")
                .font(.caption)
                .foregroundStyle(.secondary)
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
                .font(.caption.weight(.semibold))
            Text(text)
                .font(.caption.weight(.semibold))
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
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
                .font(.subheadline.weight(.medium))
                .foregroundStyle(AppTheme.forestGreen)
                .padding(14)
                .background(AppTheme.forestGreen.opacity(0.08))
                .clipShape(.rect(cornerRadius: 10))
            }
        }
    }
}
