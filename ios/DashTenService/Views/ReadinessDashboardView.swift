import SwiftUI

struct ReadinessDashboardView: View {
    let storage: StorageService
    @State private var showShareSheet: Bool = false
    @State private var shareImage: UIImage?
    @State private var selectedCategory: ReadinessCategory?

    private var readiness: ReadinessCalculator.ReadinessScore {
        ReadinessCalculator.calculate(checklist: storage.checklistItems, documents: storage.documents, benefits: storage.benefitCategories)
    }

    private var nextBestTasks: [BoostTask] {
        ReadinessBoost.topTasks(storage: storage, limit: 3)
    }

    private var milestones: [(String, String, Bool)] {
        [
            ("Roadmap Started", "flag.fill", !storage.checklistItems.filter(\.isCompleted).isEmpty),
            ("25% Ready", "chart.line.uptrend.xyaxis", readiness.overallPercent >= 25),
            ("50% Ready", "star.fill", readiness.overallPercent >= 50),
            ("75% Ready", "flame.fill", readiness.overallPercent >= 75),
            ("Fully Prepared", "checkmark.seal.fill", readiness.overallPercent >= 100),
            ("Documents Organized", "doc.text.fill", storage.documents.filter({ $0.status == .verified }).count >= 10),
        ]
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                overallScore
                if !nextBestTasks.isEmpty {
                    nextBestSection
                }
                categoryBreakdown
                milestoneSection
                shareSection
                disclaimerNote
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Readiness Score")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showShareSheet) {
            if let image = shareImage {
                ShareSheetView(items: [image])
            }
        }
        .sheet(item: $selectedCategory) { category in
            CategoryDetailSheet(storage: storage, category: category)
        }
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
                                .font(.caption.weight(.bold))
                                .foregroundStyle(.primary.opacity(0.7))
                        }
                    }

                Text(readinessMessage)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary.opacity(0.8))
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

    private var nextBestSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader("Recommended Next Steps", icon: "bolt.fill")

            VStack(spacing: 8) {
                ForEach(nextBestTasks) { task in
                    boostRow(for: task)
                }
            }
        }
    }

    @ViewBuilder
    private func boostRow(for task: BoostTask) -> some View {
        switch task.kind {
        case .benefitAction(let categoryId, _):
            NavigationLink(value: categoryId) { boostRowLabel(task) }
                .buttonStyle(.plain)
        case .document:
            NavigationLink(value: PlanningRoute.documents) { boostRowLabel(task) }
                .buttonStyle(.plain)
        case .checklist:
            NavigationLink(value: PlanningRoute.roadmap) { boostRowLabel(task) }
                .buttonStyle(.plain)
        }
    }

    private func boostRowLabel(_ task: BoostTask) -> some View {
        HStack(spacing: 12) {
            Image(systemName: task.icon)
                .font(.body.weight(.bold))
                .foregroundStyle(.white)
                .frame(width: 36, height: 36)
                .background(task.color)
                .clipShape(.rect(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 2) {
                Text(task.title)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                Text(task.actionHint)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.primary.opacity(0.6))
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(task.color)
        }
        .padding(12)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 12))
    }

    private var categoryBreakdown: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader("By Category", icon: "chart.bar.fill")

            VStack(spacing: 8) {
                ForEach(ReadinessCategory.allCases) { category in
                    let pct = readiness.percent(for: category)
                    Button {
                        selectedCategory = category
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: category.icon)
                                .font(.body.weight(.semibold))
                                .foregroundStyle(colorForCategory(category))
                                .frame(width: 28)

                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(category.rawValue)
                                        .font(.subheadline.weight(.bold))
                                        .foregroundStyle(.primary)
                                    Spacer()
                                    Text("\(pct)%")
                                        .font(.subheadline.weight(.bold))
                                        .foregroundStyle(colorForPercent(pct))
                                }
                                ProgressView(value: Double(pct) / 100.0)
                                    .tint(colorForCategory(category))
                            }

                            Image(systemName: "chevron.right")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(.primary.opacity(0.4))
                        }
                        .padding(14)
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(.rect(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var milestoneSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader("Milestones", icon: "trophy.fill")

            LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                ForEach(milestones, id: \.0) { title, icon, achieved in
                    VStack(spacing: 8) {
                        Image(systemName: icon)
                            .font(.title2)
                            .foregroundStyle(achieved ? AppTheme.gold : Color(.quaternaryLabel))
                            .symbolEffect(.bounce, value: achieved)
                        Text(title)
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(achieved ? Color.primary : Color.primary.opacity(0.4))
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

    private var shareSection: some View {
        Group {
            let achieved = milestones.filter(\.2)
            if !achieved.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader("Share Your Progress", icon: "square.and.arrow.up")

                    Button {
                        generateShareImage()
                    } label: {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share Milestone Card")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(.white.opacity(0.7))
                        }
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.white)
                        .padding(14)
                        .background(AppTheme.forestGreen)
                        .clipShape(.rect(cornerRadius: 12))
                    }
                }
            }
        }
    }

    private var disclaimerNote: some View {
        Text("Your readiness score is based on completed tasks within this app. It does not represent an official assessment or guarantee any specific outcome.")
            .font(.caption.weight(.semibold))
            .foregroundStyle(.primary.opacity(0.6))
            .multilineTextAlignment(.center)
            .padding(.top, 8)
    }

    private func colorForPercent(_ pct: Int) -> Color {
        if pct >= 75 { return AppTheme.forestGreen }
        if pct >= 50 { return .blue }
        if pct >= 25 { return .orange }
        return .red
    }

    private func colorForCategory(_ category: ReadinessCategory) -> Color {
        switch category {
        case .admin: .gray
        case .health: .red
        case .education: .blue
        case .employment: .teal
        case .family: .pink
        case .finance: AppTheme.gold
        case .housing: AppTheme.forestGreen
        }
    }

    @MainActor
    private func generateShareImage() {
        let latestMilestone = milestones.last(where: \.2)
        let title = latestMilestone?.0 ?? "Getting Started"

        let renderer = ImageRenderer(content:
            MilestoneShareCard(
                milestoneName: title,
                readinessPercent: readiness.overallPercent,
                tasksCompleted: storage.checklistItems.filter(\.isCompleted).count,
                totalTasks: storage.checklistItems.count
            )
        )
        renderer.scale = 3

        if let image = renderer.uiImage {
            shareImage = image
            showShareSheet = true
        }
    }
}

// MARK: - Boost Tasks

struct BoostTask: Identifiable {
    enum Kind {
        case checklist(String)
        case document(String)
        case benefitAction(categoryId: String, actionId: String)
    }
    let id: String
    let title: String
    let icon: String
    let color: Color
    let categoryLabel: String
    let kind: Kind

    var actionHint: String {
        switch kind {
        case .checklist:
            return "\(categoryLabel) • Open in Roadmap"
        case .document:
            return "\(categoryLabel) • Open Documents"
        case .benefitAction:
            return "\(categoryLabel) • Open guide"
        }
    }
}

enum ReadinessBoost {
    static func topTasks(storage: StorageService, limit: Int) -> [BoostTask] {
        var tasks: [BoostTask] = []

        for category in ReadinessCategory.allCases {
            let remainingChecklist = storage.checklistItems.filter { $0.readinessCategory == category && !$0.isCompleted }
            let totalChecklist = storage.checklistItems.filter { $0.readinessCategory == category }.count
            if let item = remainingChecklist.first, totalChecklist > 0 {
                tasks.append(BoostTask(
                    id: "c-\(item.id)",
                    title: item.title,
                    icon: "checkmark.square",
                    color: color(for: category),
                    categoryLabel: category.shortLabel,
                    kind: .checklist(item.id)
                ))
            }
        }

        // Add the highest-impact benefit actions across all categories
        for benefit in storage.benefitCategories {
            if let action = benefit.actionItems.first(where: { !$0.isCompleted }) {
                tasks.append(BoostTask(
                    id: "b-\(action.id)",
                    title: action.title,
                    icon: benefit.type.icon,
                    color: benefit.type.accentColor,
                    categoryLabel: benefit.type.rawValue,
                    kind: .benefitAction(categoryId: benefit.id, actionId: action.id)
                ))
            }
        }

        return Array(tasks.prefix(limit))
    }

    private static func color(for category: ReadinessCategory) -> Color {
        switch category {
        case .admin: .gray
        case .health: .red
        case .education: .blue
        case .employment: .teal
        case .family: .pink
        case .finance: AppTheme.gold
        case .housing: AppTheme.forestGreen
        }
    }
}

// MARK: - Category Detail Sheet

struct CategoryDetailSheet: View {
    let storage: StorageService
    let category: ReadinessCategory
    @Environment(\.dismiss) private var dismiss

    private var color: Color {
        switch category {
        case .admin: .gray
        case .health: .red
        case .education: .blue
        case .employment: .teal
        case .family: .pink
        case .finance: AppTheme.gold
        case .housing: AppTheme.forestGreen
        }
    }

    private var checklistItems: [ChecklistItem] {
        storage.checklistItems.filter { $0.readinessCategory == category }
    }

    private var docs: [DocumentItem] {
        let cats = relevantDocCategories()
        return storage.documents.filter { cats.contains($0.category) }
    }

    private var benefits: [BenefitCategory] {
        storage.benefitCategories.filter { relevantBenefitTypes().contains($0.type) }
    }

    private var pct: Int {
        ReadinessCalculator.calculate(checklist: storage.checklistItems, documents: storage.documents, benefits: storage.benefitCategories).percent(for: category)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    headerCard

                    if !checklistItems.isEmpty {
                        section(title: "Roadmap Tasks", icon: "checklist") {
                            VStack(spacing: 8) {
                                ForEach(checklistItems) { item in
                                    checklistRow(item)
                                }
                            }
                        }
                    }

                    if !docs.isEmpty {
                        section(title: "Documents", icon: "doc.text.fill") {
                            VStack(spacing: 8) {
                                ForEach(docs) { doc in
                                    documentRow(doc)
                                }
                            }
                        }
                    }

                    if !benefits.isEmpty {
                        section(title: "Benefit Actions", icon: "star.circle.fill") {
                            VStack(spacing: 12) {
                                ForEach(benefits) { benefit in
                                    benefitGroup(benefit)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(category.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private var headerCard: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle().fill(color.opacity(0.15)).frame(width: 56, height: 56)
                Image(systemName: category.icon)
                    .font(.title2.weight(.bold))
                    .foregroundStyle(color)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("\(pct)% complete")
                    .font(.title3.bold())
                    .foregroundStyle(color)
                Text("Tap any item to take action.")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary.opacity(0.7))
            }
            Spacer()
        }
        .padding(14)
        .background(color.opacity(0.06))
        .clipShape(.rect(cornerRadius: 14))
    }

    @ViewBuilder
    private func section<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .foregroundStyle(color)
                Text(title)
                    .font(.headline.weight(.bold))
            }
            content()
        }
    }

    private func checklistRow(_ item: ChecklistItem) -> some View {
        Button {
            withAnimation(.spring(response: 0.3)) {
                storage.toggleChecklistItem(item.id)
            }
        } label: {
            HStack(spacing: 12) {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(item.isCompleted ? color : Color.primary.opacity(0.5))
                VStack(alignment: .leading, spacing: 2) {
                    Text(item.title)
                        .font(.subheadline.weight(.semibold))
                        .strikethrough(item.isCompleted)
                        .foregroundStyle(item.isCompleted ? Color.primary.opacity(0.5) : Color.primary)
                        .multilineTextAlignment(.leading)
                    Text(item.phase.rawValue)
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.primary.opacity(0.5))
                }
                Spacer()
            }
            .padding(12)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 10))
        }
        .buttonStyle(.plain)
    }

    private func documentRow(_ doc: DocumentItem) -> some View {
        HStack(spacing: 12) {
            Image(systemName: doc.status.icon)
                .font(.title3)
                .foregroundStyle(doc.status == .verified || doc.status == .received ? color : .orange)
            VStack(alignment: .leading, spacing: 2) {
                Text(doc.name)
                    .font(.subheadline.weight(.semibold))
                Text(doc.status.rawValue)
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.primary.opacity(0.5))
            }
            Spacer()
            if doc.status != .verified {
                Button("Mark Verified") {
                    withAnimation(.spring(response: 0.3)) {
                        storage.updateDocumentStatus(doc.id, status: .verified)
                    }
                }
                .font(.caption.weight(.bold))
                .foregroundStyle(color)
            }
        }
        .padding(12)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 10))
    }

    private func benefitGroup(_ benefit: BenefitCategory) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: benefit.type.icon)
                    .foregroundStyle(benefit.type.accentColor)
                Text(benefit.type.rawValue)
                    .font(.subheadline.weight(.bold))
            }
            ForEach(benefit.actionItems) { action in
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        storage.toggleBenefitAction(categoryId: benefit.id, actionId: action.id)
                    }
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: action.isCompleted ? "checkmark.circle.fill" : "circle")
                            .font(.body)
                            .foregroundStyle(action.isCompleted ? benefit.type.accentColor : Color.primary.opacity(0.5))
                        Text(action.title)
                            .font(.caption.weight(.semibold))
                            .strikethrough(action.isCompleted)
                            .foregroundStyle(action.isCompleted ? Color.primary.opacity(0.5) : Color.primary)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    .padding(10)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(.rect(cornerRadius: 8))
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func relevantDocCategories() -> [DocumentCategory] {
        switch category {
        case .admin: [.serviceRecords, .evaluationsAwards, .certificationsTranscripts]
        case .health: [.medicalRecords, .benefitRecords]
        case .employment: [.employmentDocs]
        case .family: [.dependentDocs]
        case .finance: [.financeTaxDocs]
        case .education, .housing: []
        }
    }

    private func relevantBenefitTypes() -> [BenefitCategoryType] {
        switch category {
        case .admin: [.recordsAdmin]
        case .health: [.healthCare, .disabilityClaims]
        case .education: [.educationTraining, .careerReset]
        case .employment: [.employmentResume]
        case .housing: [.housingHomeLoan]
        case .finance: [.financesBudget, .insurance]
        case .family: [.familyDependents]
        }
    }
}

struct MilestoneShareCard: View {
    let milestoneName: String
    let readinessPercent: Int
    let tasksCompleted: Int
    let totalTasks: Int

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                Image(systemName: "arrow.up.forward.circle.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(.white)
                Text("DashTen")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
            }

            VStack(spacing: 6) {
                Text(milestoneName)
                    .font(.title.bold())
                    .foregroundStyle(.white)
                Text("\(readinessPercent)% Transition Ready")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white.opacity(0.9))
            }

            HStack(spacing: 24) {
                VStack(spacing: 2) {
                    Text("\(tasksCompleted)")
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                    Text("Tasks Done")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.white.opacity(0.85))
                }
                VStack(spacing: 2) {
                    Text("\(totalTasks)")
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                    Text("Total Tasks")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.white.opacity(0.85))
                }
            }

            Text("Planning my transition with DashTen")
                .font(.caption.weight(.bold))
                .foregroundStyle(.white.opacity(0.7))
        }
        .padding(32)
        .frame(width: 350)
        .background(
            LinearGradient(
                colors: [AppTheme.forestGreen, AppTheme.darkGreen],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(.rect(cornerRadius: 20))
    }
}

struct ShareSheetView: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
