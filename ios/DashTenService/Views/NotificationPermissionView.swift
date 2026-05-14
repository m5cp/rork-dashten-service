import SwiftUI
import UserNotifications

struct NotificationPermissionView: View {
    let storage: StorageService
    @Environment(\.dismiss) private var dismiss
    @State private var working: Bool = false
    @State private var deniedSystemWide: Bool = false

    private let perks: [(icon: String, color: Color, title: String, body: String)] = [
        ("sun.max.fill", .orange, "Daily 5-minute reminder", "One small move keeps your transition on track."),
        ("flame.fill", .red, "Streak protection", "We'll nudge you before midnight if you haven't checked in."),
        ("star.circle.fill", AppTheme.gold, "Milestone wins", "Get a ping at 7, 30, and 90 days."),
        ("calendar.badge.clock", .blue, "Phase deadlines", "Heads-up at 18mo, 12mo, 6mo, 90, 30, 7, 1 day out."),
        ("chart.bar.doc.horizontal.fill", AppTheme.forestGreen, "Weekly recap", "Every Sunday: what you did, what's next.")
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    header

                    VStack(spacing: 12) {
                        ForEach(Array(perks.enumerated()), id: \.offset) { _, p in
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: p.icon)
                                    .font(.title3.weight(.bold))
                                    .foregroundStyle(p.color)
                                    .frame(width: 36, height: 36)
                                    .background(p.color.opacity(0.12))
                                    .clipShape(.rect(cornerRadius: 10))
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(p.title).font(.subheadline.weight(.bold))
                                    Text(p.body).font(.caption.weight(.semibold))
                                        .foregroundStyle(.secondary)
                                }
                                Spacer(minLength: 0)
                            }
                        }
                    }
                    .padding(14)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(.rect(cornerRadius: 14))

                    Label("Private by default. No marketing, no spam, no third-party SDK.", systemImage: "lock.shield.fill")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)

                    if deniedSystemWide {
                        VStack(alignment: .leading, spacing: 6) {
                            Label("Notifications are off in iOS Settings", systemImage: "exclamationmark.triangle.fill")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(.orange)
                            Button {
                                if let url = URL(string: UIApplication.openSettingsURLString) {
                                    UIApplication.shared.open(url)
                                }
                            } label: {
                                Text("Open Settings")
                                    .font(.caption.weight(.bold))
                            }
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.orange.opacity(0.12))
                        .clipShape(.rect(cornerRadius: 12))
                    }

                    Button {
                        Task { await enable() }
                    } label: {
                        HStack {
                            if working { ProgressView().tint(.white) }
                            Text(working ? "Setting up…" : "Turn on notifications")
                                .font(.body.weight(.bold))
                        }
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(AppTheme.forestGreen)
                        .foregroundStyle(.white)
                        .clipShape(.rect(cornerRadius: 14))
                    }
                    .disabled(working)

                    Button("Not now") { dismiss() }
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 4)
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Stay on track")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            let status = await NotificationService.shared.currentStatus()
            deniedSystemWide = (status == .denied)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: "bell.badge.fill")
                .font(.largeTitle.weight(.bold))
                .foregroundStyle(AppTheme.gold)
            Text("A few nudges, never noise")
                .font(.title2.weight(.heavy))
            Text("DashTen sends a handful of reminders that protect your streak and your timeline. You can turn them off anytime.")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
        }
    }

    private func enable() async {
        working = true
        defer { working = false }
        let granted = await NotificationService.shared.requestPermission()
        storage.profile.notificationsEnabled = granted
        if granted {
            NotificationService.shared.enableAllRecurring()
            NotificationService.shared.scheduleWeeklyReminder()
            NotificationService.shared.scheduleMilestoneReminders(accountCreated: storage.profile.createdAt)
            if let sepDate = storage.profile.separationDate {
                NotificationService.shared.scheduleSeparationCountdown(separationDate: sepDate)
            }
            dismiss()
        } else {
            let status = await NotificationService.shared.currentStatus()
            deniedSystemWide = (status == .denied)
        }
    }
}
