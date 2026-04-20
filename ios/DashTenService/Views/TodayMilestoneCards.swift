import SwiftUI

struct MilestoneCelebrationCard: View {
    let days: Int
    let title: String
    let subtitle: String
    let onShare: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(AppTheme.gold.opacity(0.15))
                        .frame(width: 48, height: 48)
                    Image(systemName: "trophy.fill")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(AppTheme.gold)
                }
                .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 3) {
                    Text("\(days)-Day Milestone")
                        .font(.caption.weight(.heavy))
                        .foregroundStyle(AppTheme.gold)
                        .textCase(.uppercase)
                    Text(title)
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.primary)
                }

                Spacer()
            }

            Text(subtitle)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            Button {
                onShare()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.subheadline.weight(.bold))
                    Text("Share this win")
                        .font(.subheadline.weight(.bold))
                }
                .foregroundStyle(AppTheme.forestGreen)
                .frame(maxWidth: .infinity)
                .frame(minHeight: 44)
                .background(AppTheme.forestGreen.opacity(0.1))
                .clipShape(.rect(cornerRadius: 12))
            }
            .accessibilityLabel("Share your \(days) day milestone")
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: [AppTheme.gold.opacity(0.12), AppTheme.gold.opacity(0.03)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(.rect(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .strokeBorder(AppTheme.gold.opacity(0.25), lineWidth: 1)
        )
    }
}

struct WeeklySummaryCard: View {
    let tasksCompleted: Int
    let documentsVerified: Int
    let journalEntries: Int
    let readinessPercent: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "chart.bar.fill")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(AppTheme.forestGreen)
                Text("Your Week in Review")
                    .font(.headline.weight(.bold))
                Spacer()
                Text("Sunday")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 10) {
                summaryCell(value: "\(tasksCompleted)", label: "tasks done", icon: "checkmark.circle.fill", color: AppTheme.forestGreen)
                summaryCell(value: "\(documentsVerified)", label: "docs verified", icon: "doc.text.fill", color: .orange)
                summaryCell(value: "\(journalEntries)", label: "journal entries", icon: "book.fill", color: .purple)
            }

            HStack(spacing: 8) {
                Image(systemName: "gauge.with.dots.needle.50percent")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(AppTheme.forestGreen)
                Text("Readiness: \(readinessPercent)%")
                    .font(.subheadline.weight(.bold))
                Spacer()
                Text("Keep it going")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 4)
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 16))
    }

    private func summaryCell(value: String, label: String, icon: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption.weight(.bold))
                .foregroundStyle(color)
            Text(value)
                .font(.title3.weight(.bold))
                .foregroundStyle(.primary)
            Text(label)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(color.opacity(0.06))
        .clipShape(.rect(cornerRadius: 12))
    }
}
