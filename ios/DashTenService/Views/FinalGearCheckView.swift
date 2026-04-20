import SwiftUI

struct FinalGearCheckView: View {
    let storage: StorageService

    private var readiness: ReadinessCalculator.ReadinessScore {
        ReadinessCalculator.calculate(checklist: storage.checklistItems, documents: storage.documents, benefits: storage.benefitCategories)
    }

    private var criticalItems: [(String, String, Bool, Color)] {
        let hasDD214 = storage.documents.first(where: { $0.name.contains("DD214") })?.status == .received || storage.documents.first(where: { $0.name.contains("DD214") })?.status == .verified
        let hasHealthPlan = storage.benefitCategories.first(where: { $0.type == .healthCare })?.isStarted ?? false
        let hasResume = storage.documents.first(where: { $0.name.contains("Resume") })?.status == .received || storage.documents.first(where: { $0.name.contains("Resume") })?.status == .verified
        let hasHousingPlan = storage.checklistItems.contains(where: { $0.readinessCategory == .housing && $0.isCompleted })
        let hasFinancePlan = storage.checklistItems.contains(where: { $0.readinessCategory == .finance && $0.isCompleted })
        let hasMedicalRecords = storage.documents.filter({ $0.category == .medicalRecords }).contains(where: { $0.status == .received || $0.status == .verified })
        let hasEmploymentPlan = storage.checklistItems.contains(where: { $0.readinessCategory == .employment && $0.isCompleted })
        let hasInsuranceReview = storage.benefitCategories.first(where: { $0.type == .insurance })?.isStarted ?? false

        return [
            ("DD214 secured and verified", "doc.text.fill", hasDD214, .red),
            ("Health care plan in place", "cross.case.fill", hasHealthPlan, .red),
            ("Civilian resume ready", "doc.richtext", hasResume, .orange),
            ("Medical records obtained", "folder.fill", hasMedicalRecords, .orange),
            ("Housing plan confirmed", "house.fill", hasHousingPlan, .blue),
            ("Financial plan created", "dollarsign.circle.fill", hasFinancePlan, .blue),
            ("Employment actions started", "briefcase.fill", hasEmploymentPlan, .teal),
            ("Insurance transition reviewed", "shield.fill", hasInsuranceReview, .purple),
        ]
    }

    private var completedCritical: Int {
        criticalItems.filter(\.2).count
    }

    private var missingDocs: Int {
        storage.documents.filter { $0.status == .missing }.count
    }

    private var overallReady: Bool {
        completedCritical >= 6 && readiness.overallPercent >= 50
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                statusBanner
                criticalChecklist
                categorySnapshot
                documentsWarning
                encouragement
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Final Gear Check")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var statusBanner: some View {
        VStack(spacing: 16) {
            Image(systemName: overallReady ? "checkmark.shield.fill" : "exclamationmark.shield.fill")
                .font(.system(size: 48))
                .foregroundStyle(overallReady ? AppTheme.forestGreen : .orange)
                .symbolEffect(.bounce, value: overallReady)

            Text(overallReady ? "Looking Strong" : "Items Need Attention")
                .font(.title2.bold())

            Text(overallReady
                 ? "You've covered the critical bases. Keep refining your plan and stay consistent."
                 : "Some key areas still need work. Focus on the items marked below to strengthen your position.")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary.opacity(0.8))
                .multilineTextAlignment(.center)

            HStack(spacing: 24) {
                VStack(spacing: 2) {
                    Text("\(completedCritical)/\(criticalItems.count)")
                        .font(.title3.bold())
                        .foregroundStyle(AppTheme.forestGreen)
                    Text("Critical Items")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.primary.opacity(0.6))
                }
                VStack(spacing: 2) {
                    Text("\(readiness.overallPercent)%")
                        .font(.title3.bold())
                        .foregroundStyle(.blue)
                    Text("Readiness")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.primary.opacity(0.6))
                }
                VStack(spacing: 2) {
                    Text("\(missingDocs)")
                        .font(.title3.bold())
                        .foregroundStyle(missingDocs > 0 ? .orange : AppTheme.forestGreen)
                    Text("Needed Docs")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.primary.opacity(0.6))
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 16))
    }

    private var criticalChecklist: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader("Critical Items", icon: "exclamationmark.circle.fill")

            VStack(spacing: 6) {
                ForEach(criticalItems, id: \.0) { title, icon, complete, color in
                    HStack(spacing: 12) {
                        Image(systemName: complete ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .font(.title3)
                            .foregroundStyle(complete ? AppTheme.forestGreen : color)
                        Text(title)
                            .font(.subheadline.weight(.semibold))
                            .strikethrough(complete)
                            .foregroundStyle(complete ? Color.primary.opacity(0.5) : Color.primary)
                        Spacer()
                        if !complete {
                            StatusBadge(text: "Needed", color: color)
                        }
                    }
                    .padding(12)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(.rect(cornerRadius: 10))
                }
            }
        }
    }

    private var categorySnapshot: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader("Category Readiness", icon: "chart.bar.fill")

            VStack(spacing: 6) {
                ForEach(ReadinessCategory.allCases) { category in
                    let pct = readiness.percent(for: category)
                    HStack(spacing: 12) {
                        Image(systemName: category.icon)
                            .font(.caption.weight(.bold))
                            .foregroundStyle(pct >= 50 ? AppTheme.forestGreen : .orange)
                            .frame(width: 24)
                        Text(category.rawValue)
                            .font(.caption.weight(.bold))
                        Spacer()
                        ProgressView(value: Double(pct) / 100.0)
                            .tint(pct >= 50 ? AppTheme.forestGreen : .orange)
                            .frame(width: 80)
                        Text("\(pct)%")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(pct >= 50 ? AppTheme.forestGreen : .orange)
                            .frame(width: 36, alignment: .trailing)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(.rect(cornerRadius: 8))
                }
            }
        }
    }

    private var documentsWarning: some View {
        Group {
            if missingDocs > 0 {
                VStack(alignment: .leading, spacing: 8) {
                    Label("\(missingDocs) documents still needed", systemImage: "exclamationmark.triangle.fill")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.orange)
                    Text("Check the Documents tab to track and update the status of your records.")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.primary.opacity(0.8))
                }
                .padding(14)
                .background(.orange.opacity(0.06))
                .clipShape(.rect(cornerRadius: 12))
            }
        }
    }

    private var encouragement: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("This is your personal readiness snapshot — not an official assessment. Use it to identify gaps and stay accountable. You've got this.")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.primary.opacity(0.6))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}
