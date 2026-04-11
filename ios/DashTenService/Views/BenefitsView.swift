import SwiftUI

struct BenefitsView: View {
    let storage: StorageService
    @State private var searchText: String = ""

    private var filteredCategories: [BenefitCategory] {
        guard !searchText.isEmpty else { return storage.benefitCategories }
        return storage.benefitCategories.filter {
            $0.type.rawValue.localizedCaseInsensitiveContains(searchText) ||
            $0.overview.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    NonAffiliationBanner()
                        .padding(.horizontal, 16)

                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                        ForEach(filteredCategories) { category in
                            NavigationLink(value: category.id) {
                                BenefitCategoryCard(category: category)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.bottom, 24)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Benefits")
            .searchable(text: $searchText, prompt: "Search benefits")
            .navigationDestination(for: String.self) { categoryId in
                if let category = storage.benefitCategories.first(where: { $0.id == categoryId }) {
                    BenefitDetailView(storage: storage, category: category)
                }
            }
        }
    }
}

struct BenefitCategoryCard: View {
    let category: BenefitCategory

    private var completedActions: Int {
        category.actionItems.filter(\.isCompleted).count
    }

    private var color: Color {
        category.type.accentColor
    }

    private var progress: Double {
        guard !category.actionItems.isEmpty else { return 0 }
        return Double(completedActions) / Double(category.actionItems.count)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.12))
                    .frame(width: 44, height: 44)
                Image(systemName: category.type.icon)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(color)
            }

            Text(category.type.rawValue)
                .font(.subheadline.weight(.semibold))
                .multilineTextAlignment(.leading)
                .lineLimit(2)

            if !category.actionItems.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    ProgressView(value: progress)
                        .tint(color)
                    HStack(spacing: 4) {
                        Text("\(completedActions)/\(category.actionItems.count)")
                            .font(.caption2.weight(.medium))
                            .foregroundStyle(.secondary)
                        if category.isStarted {
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.caption2)
                                .foregroundStyle(color)
                        }
                    }
                }
            }

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 14))
    }
}

struct BenefitDetailView: View {
    let storage: StorageService
    let category: BenefitCategory

    private var currentCategory: BenefitCategory {
        storage.benefitCategories.first(where: { $0.id == category.id }) ?? category
    }

    private var color: Color {
        category.type.accentColor
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerSection
                overviewSection
                eligibilitySection
                documentsSection
                mistakesSection
                questionsSection
                actionChecklistSection
                officialLinkSection
                disclaimerSection
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    storage.toggleBenefitSaved(category.id)
                } label: {
                    Image(systemName: currentCategory.isSaved ? "bookmark.fill" : "bookmark")
                        .foregroundStyle(color)
                }
            }
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: category.type.icon)
                    .font(.title2)
                    .foregroundStyle(color)
                Text(category.type.rawValue)
                    .font(.title2.bold())
            }
            if !currentCategory.isStarted {
                Button {
                    storage.markBenefitStarted(category.id)
                } label: {
                    Label("Mark as Started", systemImage: "play.fill")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(color)
                        .clipShape(Capsule())
                }
                .sensoryFeedback(.impact(weight: .medium), trigger: currentCategory.isStarted)
            } else {
                StatusBadge(text: "In Progress", color: color)
            }
        }
    }

    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader("Overview", icon: "doc.text")
            CardView {
                VStack(alignment: .leading, spacing: 12) {
                    Text(category.overview)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Divider()

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Why It Matters")
                            .font(.subheadline.weight(.semibold))
                        Text(category.whyItMatters)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    private var eligibilitySection: some View {
        CollapsibleSection(title: "Common Eligibility Factors", icon: "person.crop.circle.badge.checkmark", color: color) {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(category.eligibilityFactors, id: \.self) { factor in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundStyle(color)
                            .padding(.top, 2)
                        Text(factor)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var documentsSection: some View {
        CollapsibleSection(title: "Required Documents", icon: "doc.fill", color: .orange) {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(category.requiredDocuments, id: \.self) { doc in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "doc.text")
                            .font(.caption)
                            .foregroundStyle(.orange)
                            .padding(.top, 2)
                        Text(doc)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var mistakesSection: some View {
        CollapsibleSection(title: "Common Mistakes", icon: "exclamationmark.triangle.fill", color: .red) {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(category.commonMistakes, id: \.self) { mistake in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.caption)
                            .foregroundStyle(.red)
                            .padding(.top, 2)
                        Text(mistake)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var questionsSection: some View {
        CollapsibleSection(title: "Questions to Ask", icon: "questionmark.circle.fill", color: .blue) {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(category.questionsToAsk, id: \.self) { question in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "questionmark.circle")
                            .font(.caption)
                            .foregroundStyle(.blue)
                            .padding(.top, 2)
                        Text(question)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var actionChecklistSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader("Action Checklist", icon: "checklist")
            VStack(spacing: 6) {
                ForEach(currentCategory.actionItems) { action in
                    HStack(spacing: 12) {
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                storage.toggleBenefitAction(categoryId: category.id, actionId: action.id)
                            }
                        } label: {
                            Image(systemName: action.isCompleted ? "checkmark.circle.fill" : "circle")
                                .font(.title3)
                                .foregroundStyle(action.isCompleted ? color : .secondary)
                        }
                        Text(action.title)
                            .font(.subheadline)
                            .strikethrough(action.isCompleted)
                            .foregroundStyle(action.isCompleted ? .secondary : .primary)
                        Spacer()
                    }
                    .padding(12)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(.rect(cornerRadius: 10))
                    .sensoryFeedback(.success, trigger: action.isCompleted)
                }
            }
        }
    }

    private var officialLinkSection: some View {
        OfficialLinkButton(title: "Visit Official Source", url: category.officialLink)
    }

    private var disclaimerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Always verify eligibility, deadlines, and benefit details through official government sources. Information in this app may change without notice.")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding(.top, 8)
    }
}

struct CollapsibleSection<Content: View>: View {
    let title: String
    let icon: String
    let color: Color
    @ViewBuilder let content: Content
    @State private var isExpanded: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.spring(response: 0.3)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Image(systemName: icon)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(color)
                    Text(title)
                        .font(.headline)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.tertiary)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .sensoryFeedback(.selection, trigger: isExpanded)

            if isExpanded {
                CardView {
                    content
                }
                .padding(.top, 10)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}
