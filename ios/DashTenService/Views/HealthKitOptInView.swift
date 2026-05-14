import SwiftUI

struct HealthKitOptInView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var working: Bool = false
    @State private var snapshot: HealthSnapshot = .empty
    @State private var hasOptedIn: Bool = HealthKitService.shared.hasOptedIn

    private let reads: [(icon: String, color: Color, title: String, body: String)] = [
        ("figure.walk", .green, "Steps", "Last 7-day average — a simple proxy for how much you're moving."),
        ("bed.double.fill", .indigo, "Sleep", "Last 7-day average — sleep is the cheapest performance upgrade."),
        ("brain.head.profile", .purple, "Mindful minutes", "Last 7-day total — track your wind-down time.")
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    header

                    VStack(spacing: 12) {
                        ForEach(Array(reads.enumerated()), id: \.offset) { _, r in
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: r.icon)
                                    .font(.title3.weight(.bold))
                                    .foregroundStyle(r.color)
                                    .frame(width: 36, height: 36)
                                    .background(r.color.opacity(0.12))
                                    .clipShape(.rect(cornerRadius: 10))
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(r.title).font(.subheadline.weight(.bold))
                                    Text(r.body).font(.caption.weight(.semibold))
                                        .foregroundStyle(.secondary)
                                }
                                Spacer(minLength: 0)
                            }
                        }
                    }
                    .padding(14)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(.rect(cornerRadius: 14))

                    VStack(alignment: .leading, spacing: 6) {
                        Label("Read-only. Never uploaded.", systemImage: "lock.shield.fill")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(AppTheme.forestGreen)
                        Text("DashTen never writes to HealthKit, never sends your health data off-device, and never shares it with third parties.")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(AppTheme.forestGreen.opacity(0.08))
                    .clipShape(.rect(cornerRadius: 12))

                    if hasOptedIn {
                        snapshotCard
                    }

                    Button {
                        Task { await enable() }
                    } label: {
                        HStack {
                            if working { ProgressView().tint(.white) }
                            Text(working ? "Connecting…" : (hasOptedIn ? "Refresh" : "Connect to Apple Health"))
                                .font(.body.weight(.bold))
                        }
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(AppTheme.forestGreen)
                        .foregroundStyle(.white)
                        .clipShape(.rect(cornerRadius: 14))
                    }
                    .disabled(working || !HealthKitService.shared.isAvailable)

                    if !HealthKitService.shared.isAvailable {
                        Label("Apple Health isn't available on this device.", systemImage: "info.circle")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                    }

                    if hasOptedIn {
                        Button(role: .destructive) {
                            HealthKitService.shared.setOptedIn(false)
                            hasOptedIn = false
                            snapshot = .empty
                        } label: {
                            Text("Disconnect from this device")
                                .font(.subheadline.weight(.semibold))
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Wellness")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .fontWeight(.semibold)
                }
            }
        }
        .task {
            if hasOptedIn {
                snapshot = await HealthKitService.shared.loadSnapshot()
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: "heart.text.square.fill")
                .font(.largeTitle.weight(.bold))
                .foregroundStyle(.pink)
            Text("Your readiness includes you")
                .font(.title2.weight(.heavy))
            Text("Sleep, movement, and mindful minutes are baseline indicators for everything else. Connect Apple Health to see how you're trending.")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
        }
    }

    private var snapshotCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Last 7 days")
                .font(.caption.weight(.heavy))
                .foregroundStyle(.secondary)
            HStack(spacing: 12) {
                snapshotCell(value: "\(snapshot.avgStepsLast7Days)", label: "Steps/day", color: .green)
                snapshotCell(value: String(format: "%.1f", snapshot.avgSleepHoursLast7Days), label: "Sleep hrs", color: .indigo)
                snapshotCell(value: "\(snapshot.mindfulMinutesLast7Days)", label: "Mindful min", color: .purple)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 14))
    }

    private func snapshotCell(value: String, label: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(value)
                .font(.title3.weight(.heavy))
                .foregroundStyle(color)
            Text(label)
                .font(.caption2.weight(.bold))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(color.opacity(0.08))
        .clipShape(.rect(cornerRadius: 10))
    }

    private func enable() async {
        working = true
        defer { working = false }
        let granted = await HealthKitService.shared.requestAuthorization()
        hasOptedIn = granted
        if granted {
            snapshot = await HealthKitService.shared.loadSnapshot()
        }
    }
}
