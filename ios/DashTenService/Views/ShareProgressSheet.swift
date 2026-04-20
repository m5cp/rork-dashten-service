import SwiftUI

struct ShareProgressSheet: View {
    let storage: StorageService
    let readinessPercent: Int
    let streakDays: Int
    let tasksCompleted: Int
    let totalTasks: Int
    @Environment(\.dismiss) private var dismiss
    @State private var renderedImage: UIImage?
    @State private var showShare: Bool = false

    private var branch: String { storage.profile.branch?.rawValue ?? "Service Member" }
    private var daysUsing: Int {
        Calendar.current.dateComponents([.day], from: storage.profile.createdAt, to: Date()).day ?? 0
    }

    private var caption: String {
        "\(readinessPercent)% transition ready. \(daysUsing) days in with DashTen. Steady steps, real progress."
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    shareCard
                        .padding(.top, 8)

                    VStack(spacing: 12) {
                        Button {
                            Task { await render(); showShare = true }
                        } label: {
                            Label("Share image", systemImage: "square.and.arrow.up.fill")
                                .font(.headline.weight(.bold))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .frame(minHeight: 52)
                                .background(AppTheme.forestGreen)
                                .clipShape(.rect(cornerRadius: 14))
                        }

                        Text(caption)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 30)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Share progress")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(.body.weight(.bold))
                }
            }
            .sheet(isPresented: $showShare) {
                if let img = renderedImage {
                    ShareSheetView(items: [img, caption])
                }
            }
        }
    }

    private var shareCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.up.forward.circle.fill")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(AppTheme.gold)
                    Text("DashTen")
                        .font(.caption.weight(.heavy))
                        .foregroundStyle(.white.opacity(0.9))
                }
                Spacer()
                Text(branch.uppercased())
                    .font(.caption2.weight(.heavy))
                    .foregroundStyle(.white.opacity(0.8))
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("\(readinessPercent)%")
                    .font(.system(size: 68, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)
                Text("transition ready")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white.opacity(0.9))
            }

            Divider().background(.white.opacity(0.15))

            HStack(spacing: 16) {
                statPill(value: "\(daysUsing)", label: daysUsing == 1 ? "day in" : "days in")
                statPill(value: "\(tasksCompleted)", label: "tasks done")
                statPill(value: "\(streakDays)", label: "streak")
            }

            Text("Steady steps. Real progress.")
                .font(.caption.weight(.bold))
                .foregroundStyle(AppTheme.gold)
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(width: 340)
        .background(
            LinearGradient(
                colors: [AppTheme.forestGreen, AppTheme.darkGreen],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(.rect(cornerRadius: 24))
        .shadow(color: .black.opacity(0.15), radius: 16, y: 8)
    }

    private func statPill(value: String, label: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(value)
                .font(.title3.weight(.heavy))
                .foregroundStyle(.white)
            Text(label)
                .font(.caption2.weight(.bold))
                .foregroundStyle(.white.opacity(0.75))
        }
    }

    @MainActor
    private func render() async {
        let renderer = ImageRenderer(content: shareCard)
        renderer.scale = 3
        renderedImage = renderer.uiImage
    }
}
