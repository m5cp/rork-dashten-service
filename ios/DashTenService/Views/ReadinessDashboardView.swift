import SwiftUI

struct ReadinessDashboardView: View {
    let storage: StorageService

    private var readiness: ReadinessCalculator.ReadinessScore {
        ReadinessCalculator.calculate(checklist: storage.checklistItems, documents: storage.documents, benefits: storage.benefitCategories)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                overallScore
                categoryBreakdown
                milestoneSection
                disclaimerNote
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Readiness Score")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var overallScore: some View {
        CardView {
            VStack(spacing: 16) {
                ProgressRing(progress: readiness.overall, size: 120, lineWidth: 12)
                    .overlay {
                        VStack(spacing: 2) {
                            Text("\(readiness.overallPercent)%")
                                .font(.title.bold())
                                .foregroundStyle(AppTheme.forestGreen)
                            Text("Ready")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }

                Text(readinessMessage)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
        }
    }

    private var readinessMessage: String {
        let pct = readiness.overallPercent
        if pct >= 75 { return "You're making excellent progress. Keep it up!" }
        if pct >= 50 { return "You're halfway there. Stay consistent and keep checking items off." }
        if pct >= 25 { return "Good start. Focus on the areas that need the most attention." }
        return "Every step counts. Start with your most urgent items."
    }

    private var categoryBreakdown: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader("By Category", icon: "chart.bar.fill")

            VStack(spacing: 8) {
                ForEach(ReadinessCategory.allCases) { category in
                    let pct = readiness.percent(for: category)
                    HStack(spacing: 12) {
                        Image(systemName: category.icon)
                            .font(.body)
                            .foregroundStyle(AppTheme.forestGreen)
                            .frame(width: 28)

                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(category.rawValue)
                                    .font(.subheadline.weight(.medium))
                                Spacer()
                                Text("\(pct)%")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(colorForPercent(pct))
                            }
                            ProgressView(value: Double(pct) / 100.0)
                                .tint(colorForPercent(pct))
                        }
                    }
                    .padding(14)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(.rect(cornerRadius: 12))
                }
            }
        }
    }

    private var milestoneSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader("Milestones", icon: "trophy.fill")

            let milestones: [(String, String, Bool)] = [
                ("Roadmap Started", "flag.fill", !storage.checklistItems.filter(\.isCompleted).isEmpty),
                ("25% Ready", "chart.line.uptrend.xyaxis", readiness.overallPercent >= 25),
                ("50% Ready", "star.fill", readiness.overallPercent >= 50),
                ("75% Ready", "flame.fill", readiness.overallPercent >= 75),
                ("Fully Prepared", "checkmark.seal.fill", readiness.overallPercent >= 100),
                ("Documents Organized", "doc.text.fill", storage.documents.filter({ $0.status == .verified }).count >= 10),
            ]

            LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                ForEach(milestones, id: \.0) { title, icon, achieved in
                    VStack(spacing: 8) {
                        Image(systemName: icon)
                            .font(.title2)
                            .foregroundStyle(achieved ? AppTheme.gold : Color(.quaternaryLabel))
                            .symbolEffect(.bounce, value: achieved)
                        Text(title)
                            .font(.caption2.weight(.medium))
                            .foregroundStyle(achieved ? .primary : .tertiary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(achieved ? AppTheme.gold.opacity(0.08) : Color(.secondarySystemGroupedBackground))
                    .clipShape(.rect(cornerRadius: 12))
                }
            }
        }
    }

    private var disclaimerNote: some View {
        Text("Your readiness score is based on completed tasks within this app. It does not represent an official assessment or guarantee any specific outcome.")
            .font(.caption2)
            .foregroundStyle(.tertiary)
            .multilineTextAlignment(.center)
            .padding(.top, 8)
    }

    private func colorForPercent(_ pct: Int) -> Color {
        if pct >= 75 { return AppTheme.forestGreen }
        if pct >= 50 { return .blue }
        if pct >= 25 { return .orange }
        return .red
    }
}
