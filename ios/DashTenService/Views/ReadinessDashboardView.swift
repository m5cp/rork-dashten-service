import SwiftUI

struct ReadinessDashboardView: View {
    let storage: StorageService
    @State private var showShareSheet: Bool = false
    @State private var shareImage: UIImage?

    private var readiness: ReadinessCalculator.ReadinessScore {
        ReadinessCalculator.calculate(checklist: storage.checklistItems, documents: storage.documents, benefits: storage.benefitCategories)
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

    private var categoryBreakdown: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader("By Category", icon: "chart.bar.fill")

            VStack(spacing: 8) {
                ForEach(ReadinessCategory.allCases) { category in
                    let pct = readiness.percent(for: category)
                    HStack(spacing: 12) {
                        Image(systemName: category.icon)
                            .font(.body.weight(.semibold))
                            .foregroundStyle(colorForCategory(category))
                            .frame(width: 28)

                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(category.rawValue)
                                    .font(.subheadline.weight(.bold))
                                Spacer()
                                Text("\(pct)%")
                                    .font(.subheadline.weight(.bold))
                                    .foregroundStyle(colorForPercent(pct))
                            }
                            ProgressView(value: Double(pct) / 100.0)
                                .tint(colorForCategory(category))
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
