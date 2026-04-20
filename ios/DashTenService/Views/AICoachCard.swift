import SwiftUI

struct AICoachCard: View {
    let storage: StorageService
    @State private var coach = AICoachService()

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "sparkles")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(AppTheme.gold)
                    .frame(width: 28, height: 28)
                    .background(AppTheme.gold.opacity(0.15))
                    .clipShape(.rect(cornerRadius: 8))
                VStack(alignment: .leading, spacing: 1) {
                    Text("Where You Are")
                        .font(.subheadline.weight(.bold))
                    Text(coach.usedAI ? "On-device AI coach" : "Your status")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button {
                    Task { await coach.generate(storage: storage) }
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(AppTheme.forestGreen)
                        .frame(width: 30, height: 30)
                        .background(AppTheme.forestGreen.opacity(0.1))
                        .clipShape(Circle())
                        .rotationEffect(.degrees(coach.isGenerating ? 360 : 0))
                        .animation(coach.isGenerating ? .linear(duration: 1).repeatForever(autoreverses: false) : .default, value: coach.isGenerating)
                }
                .disabled(coach.isGenerating)
            }

            if coach.message.isEmpty {
                HStack(spacing: 8) {
                    ProgressView().controlSize(.small)
                    Text("Reading your progress…")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)
                }
            } else {
                Text(coach.message)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.primary.opacity(0.9))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: [AppTheme.gold.opacity(0.10), AppTheme.forestGreen.opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(.rect(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(AppTheme.gold.opacity(0.2), lineWidth: 1)
        )
        .task {
            if coach.message.isEmpty {
                await coach.generate(storage: storage)
            }
        }
    }
}
