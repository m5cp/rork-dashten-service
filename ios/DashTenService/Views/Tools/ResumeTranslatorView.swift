import SwiftUI

struct ResumeTranslatorView: View {
    @State private var selectedTab: ResumeTab = .translate
    @State private var jargonSearch: String = ""
    @State private var jargonDirection: TranslationDirection = .milToCiv

    var body: some View {
        VStack(spacing: 0) {
            Picker("Mode", selection: $selectedTab) {
                Text("Translate Resume").tag(ResumeTab.translate)
                Text("Jargon Lookup").tag(ResumeTab.jargon)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 4)

            switch selectedTab {
            case .translate:
                CareerTranslateTab()
            case .jargon:
                jargonTab
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Resume Translator")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Jargon Tab

    private var filteredJargon: [JargonEntry] {
        let entries = jargonDirection == .milToCiv ? CivilianJargonTranslatorView.milToCivEntries : CivilianJargonTranslatorView.civToMilEntries
        guard !jargonSearch.isEmpty else { return entries }
        return entries.filter {
            $0.term.localizedStandardContains(jargonSearch) ||
            $0.translation.localizedStandardContains(jargonSearch) ||
            $0.context.localizedStandardContains(jargonSearch)
        }
    }

    private var jargonTab: some View {
        VStack(spacing: 0) {
            Picker("Direction", selection: $jargonDirection) {
                Text("Military → Civilian").tag(TranslationDirection.milToCiv)
                Text("Civilian → Military").tag(TranslationDirection.civToMil)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 16)
            .padding(.top, 8)

            List {
                if filteredJargon.isEmpty {
                    ContentUnavailableView("No matches", systemImage: "magnifyingglass", description: Text("Try a different search term"))
                } else {
                    ForEach(filteredJargon) { entry in
                        JargonRow(entry: entry, direction: jargonDirection)
                    }
                }
            }
            .listStyle(.insetGrouped)
        }
    }
}

// MARK: - Translate Tab

private struct CareerTranslateTab: View {
    @State private var selectedBranchFilter: BranchFilter = .all
    @State private var searchText: String = ""

    private let allCareers: [MilitaryCareer] = MilitaryCareerData.all

    private var availableBranches: [MilitaryServiceBranch] {
        var seen: Set<MilitaryServiceBranch> = []
        var ordered: [MilitaryServiceBranch] = []
        for branch in MilitaryServiceBranch.allCases where allCareers.contains(where: { $0.branch == branch }) {
            if !seen.contains(branch) {
                seen.insert(branch)
                ordered.append(branch)
            }
        }
        return ordered
    }

    private var filteredCareers: [MilitaryCareer] {
        let byBranch: [MilitaryCareer]
        switch selectedBranchFilter {
        case .all:
            byBranch = allCareers
        case .branch(let b):
            byBranch = allCareers.filter { $0.branch == b }
        }

        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return byBranch }
        return byBranch.filter {
            $0.code.localizedStandardContains(trimmed) ||
            $0.title.localizedStandardContains(trimmed)
        }
    }

    private var groupedCareers: [(branch: MilitaryServiceBranch, careers: [MilitaryCareer])] {
        let grouped = Dictionary(grouping: filteredCareers, by: { $0.branch })
        return MilitaryServiceBranch.allCases.compactMap { branch in
            guard let careers = grouped[branch], !careers.isEmpty else { return nil }
            return (branch, careers)
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                introCard

                branchFilterBar

                searchField

                if filteredCareers.isEmpty {
                    noResultsView
                } else {
                    careerList
                }

                Text("These are starting points. Tailor every bullet to the specific job you're applying for.")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary.opacity(0.5))
                    .padding(.top, 4)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 32)
        }
        .navigationDestination(for: MilitaryCareer.self) { career in
            CareerDetailView(career: career)
        }
    }

    private var introCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "doc.text.fill")
                    .foregroundStyle(.teal)
                Text("Translate Your Experience")
                    .font(.subheadline.weight(.bold))
            }
            Text("Find your military job code to get civilian-friendly job titles, resume bullet points, and transferable skills.")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.primary.opacity(0.8))
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.teal.opacity(0.06))
        .clipShape(.rect(cornerRadius: 12))
    }

    private var branchFilterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                BranchPill(
                    title: "All",
                    isActive: selectedBranchFilter == .all
                ) {
                    selectedBranchFilter = .all
                }
                ForEach(availableBranches, id: \.self) { branch in
                    BranchPill(
                        title: branch.rawValue,
                        isActive: selectedBranchFilter == .branch(branch)
                    ) {
                        selectedBranchFilter = .branch(branch)
                    }
                }
            }
        }
        .contentMargins(.horizontal, 0)
    }

    private var searchField: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            TextField("Search by MOS code or title", text: $searchText)
                .textInputAutocapitalization(.characters)
                .autocorrectionDisabled()
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 10))
    }

    private var noResultsView: some View {
        VStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.title)
                .foregroundStyle(.secondary)
            Text("No results for \"\(searchText)\"")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
            Text("AI lookup is coming soon for unlisted MOSs.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button {
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "sparkles")
                    Text("Try AI Lookup")
                        .font(.subheadline.weight(.semibold))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(AppTheme.forestGreen)
                .foregroundStyle(.white)
                .clipShape(.rect(cornerRadius: 10))
            }
            .buttonStyle(.plain)
            .disabled(true)
            .opacity(0.6)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 12))
    }

    @ViewBuilder
    private var careerList: some View {
        if selectedBranchFilter == .all {
            VStack(alignment: .leading, spacing: 18) {
                ForEach(groupedCareers, id: \.branch) { group in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(group.branch.rawValue.uppercased())
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.secondary)
                            .padding(.leading, 4)

                        VStack(spacing: 8) {
                            ForEach(group.careers) { career in
                                CareerRow(career: career, showBranchTag: true)
                            }
                        }
                    }
                }
            }
        } else {
            VStack(spacing: 8) {
                ForEach(filteredCareers) { career in
                    CareerRow(career: career, showBranchTag: false)
                }
            }
        }
    }
}

// MARK: - Branch Filter

private nonisolated enum BranchFilter: Hashable, Sendable {
    case all
    case branch(MilitaryServiceBranch)
}

private struct BranchPill: View {
    let title: String
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption.weight(.semibold))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    Group {
                        if isActive {
                            AppTheme.forestGreen
                        } else {
                            Color.clear
                        }
                    }
                )
                .foregroundStyle(isActive ? .white : .primary)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isActive ? Color.clear : Color.primary.opacity(0.2), lineWidth: 1)
                )
                .clipShape(.rect(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Career Row

private struct CareerRow: View {
    let career: MilitaryCareer
    let showBranchTag: Bool

    var body: some View {
        NavigationLink(value: career) {
            HStack(spacing: 12) {
                Text(career.code)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(minWidth: 50)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                    .background(AppTheme.forestGreen)
                    .clipShape(.rect(cornerRadius: 6))

                VStack(alignment: .leading, spacing: 2) {
                    Text(career.title)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)

                    if showBranchTag {
                        Text(career.branch.rawValue)
                            .font(.caption2.weight(.semibold))
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.primary.opacity(0.4))
            }
            .padding(12)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Career Detail

private struct CareerDetailView: View {
    let career: MilitaryCareer
    @State private var copiedBulletIndex: Int? = nil
    @State private var copiedAll: Bool = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header

                section(title: "Civilian Job Titles", systemImage: "briefcase.fill", tint: AppTheme.forestGreen) {
                    FlowLayout(spacing: 8) {
                        ForEach(career.civilianTitles, id: \.self) { title in
                            Button {
                                UIPasteboard.general.string = title
                            } label: {
                                Text(title)
                                    .font(.caption.weight(.semibold))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(AppTheme.forestGreen.opacity(0.12))
                                    .foregroundStyle(AppTheme.forestGreen)
                                    .clipShape(.rect(cornerRadius: 16))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                section(title: "Resume Bullet Points", systemImage: "list.bullet.rectangle.fill", tint: .blue) {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(Array(career.bulletPoints.enumerated()), id: \.offset) { index, bullet in
                            Button {
                                UIPasteboard.general.string = bullet
                                copiedBulletIndex = index
                                Task {
                                    try? await Task.sleep(for: .seconds(1.5))
                                    if copiedBulletIndex == index { copiedBulletIndex = nil }
                                }
                            } label: {
                                HStack(alignment: .top, spacing: 10) {
                                    Image(systemName: copiedBulletIndex == index ? "checkmark.circle.fill" : "doc.on.doc")
                                        .font(.caption)
                                        .foregroundStyle(copiedBulletIndex == index ? .green : .blue)
                                        .padding(.top, 3)
                                    Text(bullet)
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(.primary.opacity(0.85))
                                        .multilineTextAlignment(.leading)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(10)
                                .background(Color(.tertiarySystemGroupedBackground))
                                .clipShape(.rect(cornerRadius: 10))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                section(title: "Transferable Skills", systemImage: "star.fill", tint: AppTheme.gold) {
                    FlowLayout(spacing: 8) {
                        ForEach(career.skills, id: \.self) { skill in
                            Text(skill)
                                .font(.caption.weight(.semibold))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(AppTheme.gold.opacity(0.15))
                                .foregroundStyle(.primary)
                                .clipShape(.rect(cornerRadius: 16))
                        }
                    }
                }

                Button {
                    let joined = career.bulletPoints.map { "• \($0)" }.joined(separator: "\n")
                    UIPasteboard.general.string = joined
                    copiedAll = true
                    Task {
                        try? await Task.sleep(for: .seconds(1.5))
                        copiedAll = false
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: copiedAll ? "checkmark.circle.fill" : "doc.on.doc.fill")
                        Text(copiedAll ? "Copied!" : "Copy All Bullets")
                            .font(.subheadline.weight(.bold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(AppTheme.forestGreen)
                    .foregroundStyle(.white)
                    .clipShape(.rect(cornerRadius: 12))
                }
                .buttonStyle(.plain)
                .padding(.top, 4)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(career.code)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(career.code)
                .font(.caption.weight(.bold))
                .foregroundStyle(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(AppTheme.forestGreen)
                .clipShape(.rect(cornerRadius: 6))

            Text(career.title)
                .font(.title2.weight(.bold))
                .foregroundStyle(.primary)

            Text(career.branch.rawValue)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private func section<Content: View>(title: String, systemImage: String, tint: Color, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: systemImage)
                    .foregroundStyle(tint)
                Text(title)
                    .font(.headline.weight(.bold))
            }
            content()
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 12))
    }
}

// MARK: - Flow Layout

private struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? .infinity
        let result = layout(subviews: subviews, in: width)
        return CGSize(width: width.isFinite ? width : result.width, height: result.height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = layout(subviews: subviews, in: bounds.width)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y), proposal: .unspecified)
        }
    }

    private func layout(subviews: Subviews, in maxWidth: CGFloat) -> (positions: [CGPoint], width: CGFloat, height: CGFloat) {
        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var maxRowWidth: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth && x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
            maxRowWidth = max(maxRowWidth, x)
        }
        return (positions, maxRowWidth, y + rowHeight)
    }
}

private nonisolated enum ResumeTab: String, Sendable {
    case translate
    case jargon
}
