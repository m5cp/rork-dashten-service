import SwiftUI

struct BenefitsView: View {
    let storage: StorageService
    @State private var searchText: String = ""

    private var filteredCategories: [BenefitCategory] {
        guard !searchText.isEmpty else { return storage.benefitCategories }
        return storage.benefitCategories.filter {
            $0.type.rawValue.localizedCaseInsensitiveContains(searchText) ||
            $0.overview.localizedCaseInsensitiveContains(searchText) ||
            $0.type.teaser.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(filteredCategories) { category in
                        NavigationLink(value: category.id) {
                            BenefitHeroCard(category: category)
                        }
                        .buttonStyle(.plain)
                    }

                    if searchText.isEmpty {
                        scraCard
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Benefits")
            .navigationDestination(for: String.self) { categoryId in
                if let category = storage.benefitCategories.first(where: { $0.id == categoryId }) {
                    BenefitDetailView(storage: storage, category: category)
                }
            }
            .navigationDestination(for: PlanningRoute.self) { route in
                switch route {
                case .stateBenefits: StateBenefitsFinderView()
                case .scraProtections: SCRAProtectionsView()
                default: EmptyView()
                }
            }
        }
    }

    private var scraCard: some View {
        NavigationLink(value: PlanningRoute.scraProtections) {
            HStack(spacing: 14) {
                Image(systemName: "shield.lefthalf.filled")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(width: 56, height: 56)
                    .background(
                        LinearGradient(
                            colors: [.teal, .teal.opacity(0.75)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(.rect(cornerRadius: 14))

                VStack(alignment: .leading, spacing: 4) {
                    Text("SCRA — Servicemembers Civil Relief Act")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.primary)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                    Text("Legal protections for active duty: lease termination, 6% interest cap, court protections, and more.")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.secondary)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 4)

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.tertiary)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Hero Card (matches Guides style)

struct BenefitHeroCard: View {
    let category: BenefitCategory

    private var completedActions: Int {
        category.actionItems.filter(\.isCompleted).count
    }

    private var totalActions: Int { category.actionItems.count }

    private var color: Color { category.type.accentColor }

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: category.type.icon)
                .font(.title2.weight(.bold))
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(
                    LinearGradient(
                        colors: [color, color.opacity(0.75)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(.rect(cornerRadius: 14))

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(category.type.rawValue)
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.primary)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                    if category.isSaved {
                        Image(systemName: "bookmark.fill")
                            .font(.caption2)
                            .foregroundStyle(color)
                    }
                }
                Text(category.type.teaser)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
                    .lineLimit(4)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)

                if completedActions > 0 && totalActions > 0 {
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption2)
                            .foregroundStyle(color)
                        Text("\(completedActions) of \(totalActions) steps done")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(color)
                    }
                    .padding(.top, 2)
                }
            }

            Spacer(minLength: 4)

            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(.tertiary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 16))
    }
}

// MARK: - Detail (guide-style)

struct BenefitDetailView: View {
    let storage: StorageService
    let category: BenefitCategory

    private var currentCategory: BenefitCategory {
        storage.benefitCategories.first(where: { $0.id == category.id }) ?? category
    }

    private var color: Color { category.type.accentColor }

    private var officialURL: URL {
        URL(string: category.type.officialURL) ?? URL(string: "https://www.va.gov")!
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerSection
                whatsAvailableSection
                whoQualifiesSection
                howToGetItSection
                wherToApplySection
                requiredDocumentsSection
                mistakesSection
                questionsSection
                actionChecklistSection
                stateBenefitsCallout
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
                .accessibilityLabel(currentCategory.isSaved ? "Unsave benefit" : "Save benefit")
            }
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 14) {
                Image(systemName: category.type.icon)
                    .font(.title.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(width: 64, height: 64)
                    .background(
                        LinearGradient(
                            colors: [color, color.opacity(0.75)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(.rect(cornerRadius: 16))

                VStack(alignment: .leading, spacing: 4) {
                    Text(category.type.rawValue)
                        .font(.title2.weight(.bold))
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(category.type.teaser)
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 0)
            }
        }
    }

    private var whatsAvailableSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader("What's Available", icon: "sparkles")
            CardView {
                VStack(alignment: .leading, spacing: 12) {
                    Text(category.overview)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.primary.opacity(0.85))
                        .fixedSize(horizontal: false, vertical: true)

                    Divider()

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Why It Matters")
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(color)
                        Text(category.whyItMatters)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.primary.opacity(0.8))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    private var whoQualifiesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader("Who Qualifies", icon: "person.crop.circle.badge.checkmark")
            CardView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(category.eligibilityFactors, id: \.self) { factor in
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.caption)
                                .foregroundStyle(color)
                                .padding(.top, 3)
                            Text(factor)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.primary.opacity(0.85))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    private var howToGetItSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader("How to Get It", icon: "list.number")
            CardView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(Array(category.actionItems.enumerated()), id: \.element.id) { index, action in
                        HStack(alignment: .top, spacing: 12) {
                            Text("\(index + 1)")
                                .font(.caption.weight(.heavy))
                                .foregroundStyle(.white)
                                .frame(width: 24, height: 24)
                                .background(color)
                                .clipShape(Circle())
                            Text(action.title)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.primary.opacity(0.9))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    private var wherToApplySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader("Where to Apply", icon: "link")
            Link(destination: officialURL) {
                HStack(spacing: 12) {
                    Image(systemName: "arrow.up.right.square.fill")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(width: 40, height: 40)
                        .background(color)
                        .clipShape(.rect(cornerRadius: 10))
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Open on \(category.type.sourceLabel)")
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(.primary)
                        Text(officialURL.host ?? category.type.sourceLabel)
                            .font(.caption.weight(.medium))
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.tertiary)
                }
                .padding(14)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(.rect(cornerRadius: 14))
            }
        }
    }

    private var requiredDocumentsSection: some View {
        CollapsibleSection(title: "Documents You'll Need", icon: "doc.fill", color: .orange) {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(category.requiredDocuments, id: \.self) { doc in
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "doc.text")
                            .font(.caption)
                            .foregroundStyle(.orange)
                            .padding(.top, 3)
                        Text(doc)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.primary.opacity(0.85))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var mistakesSection: some View {
        CollapsibleSection(title: "Common Mistakes", icon: "exclamationmark.triangle.fill", color: .red) {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(category.commonMistakes, id: \.self) { mistake in
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.caption)
                            .foregroundStyle(.red)
                            .padding(.top, 3)
                        Text(mistake)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.primary.opacity(0.85))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var questionsSection: some View {
        CollapsibleSection(title: "Questions to Ask", icon: "questionmark.circle.fill", color: .blue) {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(category.questionsToAsk, id: \.self) { question in
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "questionmark.circle")
                            .font(.caption)
                            .foregroundStyle(.blue)
                            .padding(.top, 3)
                        Text(question)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.primary.opacity(0.85))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var actionChecklistSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader("Track Your Progress", icon: "checklist")
            Text("Check off each step as you complete it. Tap a step for detailed how-to instructions.")
                .font(.caption.weight(.medium))
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            ActionChecklistContent(storage: storage, categoryId: category.id, color: color)
        }
    }

    private var stateBenefitsCallout: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader("Your State May Add More", icon: "flag.fill")
            CardView {
                VStack(alignment: .leading, spacing: 14) {
                    Text("Most states stack their own benefits on top of this federal one — things like property tax exemptions, tuition waivers, hiring preferences, free hunting/fishing licenses, and DMV fee discounts. Don't leave money on the table.")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.primary.opacity(0.85))
                        .fixedSize(horizontal: false, vertical: true)

                    NavigationLink(value: PlanningRoute.stateBenefits) {
                        HStack(spacing: 12) {
                            Image(systemName: "map.fill")
                                .font(.title3.weight(.bold))
                                .foregroundStyle(.white)
                                .frame(width: 40, height: 40)
                                .background(color)
                                .clipShape(.rect(cornerRadius: 10))
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Open State-by-State Benefits")
                                    .font(.subheadline.weight(.bold))
                                    .foregroundStyle(.primary)
                                Text("Find what your state offers")
                                    .font(.caption.weight(.medium))
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(.tertiary)
                        }
                        .padding(12)
                        .background(color.opacity(0.08))
                        .clipShape(.rect(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)

                    Divider()

                    Text("Who to Contact Locally")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(color)

                    VStack(alignment: .leading, spacing: 10) {
                        ContactRecRow(
                            title: "State Department of Veterans Affairs",
                            description: "Your state's VA office runs state-funded benefit programs and can confirm what you qualify for.",
                            color: color
                        )
                        ContactRecRow(
                            title: "County Veterans Service Officer (CVSO)",
                            description: "Free, accredited help filing claims and finding county-level benefits. Search 'CVSO + your county'.",
                            color: color
                        )
                        ContactRecRow(
                            title: "Accredited VSO (American Legion, VFW, DAV)",
                            description: "Veteran service organizations file claims on your behalf at no cost and know local programs well.",
                            color: color
                        )
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    private var disclaimerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("This app is not affiliated with any government agency. Always verify eligibility, deadlines, and benefit details through official sources. Information in this app may change without notice.")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.primary.opacity(0.6))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.top, 8)
    }
}

struct ActionChecklistContent: View {
    let storage: StorageService
    let categoryId: String
    let color: Color

    private var actions: [BenefitAction] {
        storage.benefitCategories.first(where: { $0.id == categoryId })?.actionItems ?? []
    }

    var body: some View {
        VStack(spacing: 8) {
            ForEach(Array(actions.enumerated()), id: \.element.id) { _, action in
                ActionRow(action: action, color: color) {
                    withAnimation(.spring(response: 0.3)) {
                        storage.toggleBenefitAction(categoryId: categoryId, actionId: action.id)
                    }
                }
            }
        }
    }
}

struct ActionRow: View {
    let action: BenefitAction
    let color: Color
    let onToggle: () -> Void
    @State private var isExpanded: Bool = false

    private var howTo: BenefitActionHowTo? {
        BenefitActionHowToData.howTo(for: action.id)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                if howTo != nil {
                    withAnimation(.spring(response: 0.3)) { isExpanded.toggle() }
                }
            } label: {
                HStack(alignment: .center, spacing: 12) {
                    Text(action.title)
                        .font(.subheadline.weight(.semibold))
                        .strikethrough(action.isCompleted)
                        .foregroundStyle(action.isCompleted ? Color.primary.opacity(0.5) : Color.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                        .lineLimit(isExpanded ? nil : 2)
                        .fixedSize(horizontal: false, vertical: true)

                    Toggle("Mark complete", isOn: Binding(
                        get: { action.isCompleted },
                        set: { _ in onToggle() }
                    ))
                    .labelsHidden()
                    .tint(color)
                    .sensoryFeedback(.success, trigger: action.isCompleted)

                    if howTo != nil {
                        Image(systemName: "chevron.down")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(color)
                            .frame(width: 28, height: 28)
                            .background(color.opacity(0.12))
                            .clipShape(Circle())
                            .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    }
                }
                .padding(12)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if isExpanded, let howTo {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 6) {
                        Image(systemName: "list.number")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(color)
                        Text("How to do this")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.primary.opacity(0.7))
                    }
                    ForEach(Array(howTo.steps.enumerated()), id: \.offset) { index, step in
                        HStack(alignment: .top, spacing: 10) {
                            Text("\(index + 1)")
                                .font(.caption2.weight(.bold))
                                .foregroundStyle(.white)
                                .frame(width: 20, height: 20)
                                .background(color)
                                .clipShape(Circle())
                            Text(step)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.primary.opacity(0.85))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    if let link = howTo.link {
                        Link(destination: URL(string: link.url) ?? URL(string: "https://www.va.gov")!) {
                            HStack(spacing: 6) {
                                Image(systemName: "arrow.up.right.square.fill")
                                Text(link.title)
                            }
                            .font(.caption.weight(.bold))
                            .foregroundStyle(color)
                        }
                        .padding(.top, 2)
                    }
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(color.opacity(0.06))
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 12))
    }
}

struct ContactRecRow: View {
    let title: String
    let description: String
    let color: Color

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "person.fill.checkmark")
                .font(.caption)
                .foregroundStyle(color)
                .padding(.top, 3)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.primary)
                Text(description)
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
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
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(color)
                    Text(title)
                        .font(.headline.weight(.bold))
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.primary.opacity(0.7))
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
