import SwiftUI

struct NetworkingScorecardView: View {
    let storage: StorageService
    @State private var newContacts: String = ""
    @State private var followUps: String = ""
    @State private var interviews: String = ""
    @State private var showAddSheet: Bool = false

    private var currentWeek: NetworkingWeek? {
        let startOfWeek = Calendar.current.dateInterval(of: .weekOfYear, for: Date())?.start ?? Date()
        return storage.networkingWeeks.first { Calendar.current.isDate($0.weekStartDate, equalTo: startOfWeek, toGranularity: .weekOfYear) }
    }

    private var totalContacts: Int {
        storage.networkingWeeks.reduce(0) { $0 + $1.newContacts }
    }

    private var totalFollowUps: Int {
        storage.networkingWeeks.reduce(0) { $0 + $1.followUpsSent }
    }

    private var totalInterviews: Int {
        storage.networkingWeeks.reduce(0) { $0 + $1.informationalInterviews }
    }

    private var currentStreak: Int {
        var streak = 0
        let sorted = storage.networkingWeeks.sorted { $0.weekStartDate > $1.weekStartDate }
        for week in sorted {
            if week.totalActivity > 0 { streak += 1 } else { break }
        }
        return streak
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                streakHeader

                thisWeekCard

                allTimeStats

                weeklyHistory
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Networking Scorecard")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAddSheet) {
            addWeekSheet
        }
    }

    private var streakHeader: some View {
        HStack(spacing: 16) {
            VStack(spacing: 4) {
                Text("\(currentStreak)")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundStyle(.purple)
                Text("week streak")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.primary.opacity(0.6))
            }
            .frame(width: 90, height: 90)
            .background(.purple.opacity(0.08))
            .clipShape(.rect(cornerRadius: 16))

            VStack(alignment: .leading, spacing: 6) {
                Text("Keep Building")
                    .font(.headline.weight(.bold))
                Text("Networking is the #1 way to land a civilian job. Most positions are filled through connections.")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary.opacity(0.7))
            }
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 16))
    }

    private var thisWeekCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("This Week")
                    .font(.headline.weight(.bold))
                Spacer()
                if currentWeek == nil {
                    Button {
                        showAddSheet = true
                    } label: {
                        Label("Log Activity", systemImage: "plus.circle.fill")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.purple)
                    }
                }
            }

            if let week = currentWeek {
                HStack(spacing: 10) {
                    NetworkStatCard(icon: "person.badge.plus", value: "\(week.newContacts)", label: "Contacts", color: .purple)
                    NetworkStatCard(icon: "arrow.turn.up.right", value: "\(week.followUpsSent)", label: "Follow-ups", color: .blue)
                    NetworkStatCard(icon: "person.2.fill", value: "\(week.informationalInterviews)", label: "Interviews", color: .teal)
                }
            } else {
                HStack(spacing: 14) {
                    Image(systemName: "person.3.fill")
                        .font(.title3)
                        .foregroundStyle(.purple.opacity(0.5))
                    Text("No activity logged this week yet. Tap \"Log Activity\" to start tracking.")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.primary.opacity(0.6))
                    Spacer()
                }
                .padding(14)
                .background(.purple.opacity(0.04))
                .clipShape(.rect(cornerRadius: 12))
            }
        }
    }

    private var allTimeStats: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("All-Time Totals")
                .font(.headline.weight(.bold))

            HStack(spacing: 10) {
                NetworkStatCard(icon: "person.badge.plus", value: "\(totalContacts)", label: "Contacts", color: .purple)
                NetworkStatCard(icon: "arrow.turn.up.right", value: "\(totalFollowUps)", label: "Follow-ups", color: .blue)
                NetworkStatCard(icon: "person.2.fill", value: "\(totalInterviews)", label: "Info Interviews", color: .teal)
            }
        }
    }

    private var weeklyHistory: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Weekly History")
                .font(.headline.weight(.bold))

            if storage.networkingWeeks.isEmpty {
                HStack {
                    Image(systemName: "chart.bar.xaxis")
                        .foregroundStyle(.primary.opacity(0.3))
                    Text("Your weekly history will appear here")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.primary.opacity(0.5))
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(.rect(cornerRadius: 12))
            } else {
                ForEach(storage.networkingWeeks.prefix(8)) { week in
                    HStack {
                        Text(week.weekStartDate, format: .dateTime.month(.abbreviated).day())
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.primary.opacity(0.6))
                            .frame(width: 60, alignment: .leading)

                        GeometryReader { geo in
                            let maxVal = max(Double(storage.networkingWeeks.map(\.totalActivity).max() ?? 1), 1)
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.purple.opacity(0.7))
                                .frame(width: geo.size.width * (Double(week.totalActivity) / maxVal))
                        }
                        .frame(height: 16)

                        Text("\(week.totalActivity)")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.purple)
                            .frame(width: 30, alignment: .trailing)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }

    private var addWeekSheet: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                Text("Log This Week's Networking")
                    .font(.title3.weight(.bold))

                VStack(spacing: 10) {
                    PayInputRow(label: "New Contacts Made", sublabel: "LinkedIn, events, referrals", value: $newContacts, color: .purple)
                    Divider()
                    PayInputRow(label: "Follow-ups Sent", sublabel: "Emails, messages, calls", value: $followUps, color: .blue)
                    Divider()
                    PayInputRow(label: "Info Interviews", sublabel: "Conversations with insiders", value: $interviews, color: .teal)
                }
                .padding(14)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(.rect(cornerRadius: 14))

                Button {
                    var week = NetworkingWeek()
                    week.newContacts = Int(newContacts) ?? 0
                    week.followUpsSent = Int(followUps) ?? 0
                    week.informationalInterviews = Int(interviews) ?? 0
                    storage.addNetworkingWeek(week)
                    showAddSheet = false
                    newContacts = ""
                    followUps = ""
                    interviews = ""
                } label: {
                    Text("Save")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(AppTheme.forestGreen)
                        .clipShape(.rect(cornerRadius: 14))
                }

                Spacer()
            }
            .padding(20)
            .navigationTitle("Log Activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") { showAddSheet = false }
                        .font(.body.weight(.semibold))
                }
            }
        }
    }
}

struct NetworkStatCard: View {
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
        .background(color.opacity(0.06))
        .clipShape(.rect(cornerRadius: 12))
    }
}
