import SwiftUI

struct WeeklyCheckInView: View {
    let storage: StorageService
    @State private var stress: Double = 3
    @State private var jobSearch: Double = 3
    @State private var financial: Double = 3
    @State private var social: Double = 3
    @State private var mood: Double = 3
    @State private var showNewCheckIn: Bool = false
    @State private var justSaved: Bool = false

    private let labels = ["Very Low", "Low", "Moderate", "Good", "Excellent"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerCard

                if !storage.weeklyCheckIns.isEmpty {
                    trendSection
                }

                if showNewCheckIn {
                    checkInForm
                } else if !justSaved {
                    Button {
                        withAnimation(.spring(response: 0.3)) { showNewCheckIn = true }
                    } label: {
                        Label("New Check-In", systemImage: "plus.circle.fill")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(.blue)
                            .clipShape(.rect(cornerRadius: 14))
                    }
                }

                if justSaved {
                    savedConfirmation
                }

                if !storage.weeklyCheckIns.isEmpty {
                    historySection
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Weekly Check-In")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "chart.xyaxis.line")
                    .foregroundStyle(.blue)
                Text("Track Your Well-Being")
                    .font(.subheadline.weight(.bold))
            }
            Text("A quick weekly pulse check helps you see patterns and catch issues early. Rate each area on a scale of 1-5.")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.primary.opacity(0.8))

            if let last = storage.weeklyCheckIns.first {
                HStack(spacing: 12) {
                    Text("Last check-in: \(last.date, format: .dateTime.month(.abbreviated).day())")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.blue)
                    Text("Avg: \(String(format: "%.1f", last.averageScore))/5")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(scoreColor(last.averageScore))
                }
            }
        }
        .padding(14)
        .background(.blue.opacity(0.06))
        .clipShape(.rect(cornerRadius: 14))
    }

    private var checkInForm: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("How are you doing this week?")
                .font(.headline.weight(.bold))

            sliderRow(title: "Stress Management", icon: "brain.fill", value: $stress, color: .purple)
            sliderRow(title: "Job Search Progress", icon: "briefcase.fill", value: $jobSearch, color: .teal)
            sliderRow(title: "Financial Confidence", icon: "dollarsign.circle.fill", value: $financial, color: AppTheme.gold)
            sliderRow(title: "Social Connection", icon: "person.2.fill", value: $social, color: .pink)
            sliderRow(title: "Overall Mood", icon: "face.smiling.fill", value: $mood, color: .blue)

            HStack(spacing: 12) {
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        showNewCheckIn = false
                    }
                } label: {
                    Text("Cancel")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.primary.opacity(0.6))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(.rect(cornerRadius: 12))
                }

                Button {
                    let entry = WeeklyCheckInEntry(
                        stressLevel: Int(stress),
                        jobSearchProgress: Int(jobSearch),
                        financialConfidence: Int(financial),
                        socialConnection: Int(social),
                        overallMood: Int(mood)
                    )
                    storage.addCheckIn(entry)
                    withAnimation(.spring(response: 0.3)) {
                        showNewCheckIn = false
                        justSaved = true
                    }
                    stress = 3
                    jobSearch = 3
                    financial = 3
                    social = 3
                    mood = 3
                } label: {
                    Text("Save Check-In")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(.blue)
                        .clipShape(.rect(cornerRadius: 12))
                }
            }
        }
        .transition(.move(edge: .top).combined(with: .opacity))
    }

    private func sliderRow(title: String, icon: String, value: Binding<Double>, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundStyle(color)
                Text(title)
                    .font(.subheadline.weight(.bold))
                Spacer()
                Text(labels[max(0, min(4, Int(value.wrappedValue) - 1))])
                    .font(.caption.weight(.bold))
                    .foregroundStyle(color)
            }

            HStack(spacing: 8) {
                Text("1")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.primary.opacity(0.4))
                Slider(value: value, in: 1...5, step: 1)
                    .tint(color)
                Text("5")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.primary.opacity(0.4))
            }
        }
        .padding(12)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 12))
    }

    private var savedConfirmation: some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 36))
                .foregroundStyle(AppTheme.forestGreen)
                .symbolEffect(.bounce, value: justSaved)

            Text("Check-In Saved!")
                .font(.headline.weight(.bold))

            Text("Come back next week to track your progress over time.")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.primary.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(AppTheme.forestGreen.opacity(0.06))
        .clipShape(.rect(cornerRadius: 16))
    }

    private var trendSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Trends")
                .font(.headline.weight(.bold))

            let recent = Array(storage.weeklyCheckIns.prefix(8).reversed())

            if recent.count >= 2 {
                VStack(spacing: 8) {
                    trendRow(title: "Stress", data: recent.map(\.stressLevel), color: .purple, icon: "brain.fill")
                    trendRow(title: "Job Search", data: recent.map(\.jobSearchProgress), color: .teal, icon: "briefcase.fill")
                    trendRow(title: "Financial", data: recent.map(\.financialConfidence), color: AppTheme.gold, icon: "dollarsign.circle.fill")
                    trendRow(title: "Social", data: recent.map(\.socialConnection), color: .pink, icon: "person.2.fill")
                    trendRow(title: "Mood", data: recent.map(\.overallMood), color: .blue, icon: "face.smiling.fill")
                }
            } else {
                HStack {
                    Image(systemName: "chart.xyaxis.line")
                        .foregroundStyle(.primary.opacity(0.3))
                    Text("Complete 2+ check-ins to see trends")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.primary.opacity(0.5))
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(.rect(cornerRadius: 12))
            }
        }
    }

    private func trendRow(title: String, data: [Int], color: Color, icon: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.caption2)
                .foregroundStyle(color)
                .frame(width: 16)

            Text(title)
                .font(.caption2.weight(.bold))
                .foregroundStyle(.primary.opacity(0.6))
                .frame(width: 60, alignment: .leading)

            HStack(spacing: 3) {
                ForEach(data.indices, id: \.self) { i in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(color.opacity(Double(data[i]) / 5.0))
                        .frame(height: CGFloat(data[i]) * 5)
                }
            }
            .frame(height: 25)
            .frame(maxWidth: .infinity)

            if let last = data.last, let prev = data.dropLast().last {
                let diff = last - prev
                Image(systemName: diff > 0 ? "arrow.up" : diff < 0 ? "arrow.down" : "minus")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(diff > 0 ? AppTheme.forestGreen : diff < 0 ? .red : .primary.opacity(0.4))
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 10))
    }

    private var historySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("History")
                .font(.headline.weight(.bold))

            ForEach(storage.weeklyCheckIns.prefix(10)) { entry in
                HStack(spacing: 12) {
                    Text(entry.date, format: .dateTime.month(.abbreviated).day())
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.primary.opacity(0.6))
                        .frame(width: 50, alignment: .leading)

                    HStack(spacing: 6) {
                        scoreDot(entry.stressLevel, color: .purple)
                        scoreDot(entry.jobSearchProgress, color: .teal)
                        scoreDot(entry.financialConfidence, color: AppTheme.gold)
                        scoreDot(entry.socialConnection, color: .pink)
                        scoreDot(entry.overallMood, color: .blue)
                    }

                    Spacer()

                    Text(String(format: "%.1f", entry.averageScore))
                        .font(.caption.weight(.bold))
                        .foregroundStyle(scoreColor(entry.averageScore))
                }
                .padding(10)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(.rect(cornerRadius: 8))
            }
        }
    }

    private func scoreDot(_ value: Int, color: Color) -> some View {
        Circle()
            .fill(color.opacity(Double(value) / 5.0))
            .frame(width: 18, height: 18)
            .overlay {
                Text("\(value)")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundStyle(.white)
            }
    }

    private func scoreColor(_ score: Double) -> Color {
        if score >= 4 { return AppTheme.forestGreen }
        if score >= 3 { return .blue }
        if score >= 2 { return .orange }
        return .red
    }
}
