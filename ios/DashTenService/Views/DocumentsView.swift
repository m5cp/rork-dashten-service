import SwiftUI

struct DocumentsView: View {
    let storage: StorageService
    @State private var expandedCategories: Set<DocumentCategory> = []

    private var groupedDocuments: [(DocumentCategory, [DocumentItem])] {
        let grouped = Dictionary(grouping: storage.documents, by: \.category)
        return DocumentCategory.allCases.compactMap { cat in
            guard let docs = grouped[cat], !docs.isEmpty else { return nil }
            return (cat, docs)
        }
    }

    private var missingCount: Int {
        storage.documents.filter { $0.status == .missing }.count
    }

    private var verifiedCount: Int {
        storage.documents.filter { $0.status == .verified }.count
    }

    private var totalCount: Int {
        storage.documents.count
    }

    private var overallProgress: Double {
        guard totalCount > 0 else { return 0 }
        return Double(storage.documents.filter { $0.status == .received || $0.status == .verified }.count) / Double(totalCount)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                documentWarningBanner
                progressHeader
                summaryBar

                ForEach(groupedDocuments, id: \.0) { category, docs in
                    CategoryHeroCard(
                        category: category,
                        documents: docs,
                        isExpanded: expandedCategories.contains(category),
                        onToggle: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                                if expandedCategories.contains(category) {
                                    expandedCategories.remove(category)
                                } else {
                                    expandedCategories.insert(category)
                                }
                            }
                        },
                        onStatusChange: { doc, newStatus in
                            storage.updateDocumentStatus(doc.id, status: newStatus)
                        }
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Documents")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var documentWarningBanner: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.body)
                .foregroundStyle(.orange)
            VStack(alignment: .leading, spacing: 4) {
                Text("Do Not Upload Documents Here")
                    .font(.subheadline.weight(.bold))
                Text("This is a checklist to track which documents you have in your physical possession. Obtain and secure physical or digital copies yourself. Do not upload sensitive documents to this app.")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary.opacity(0.8))
            }
        }
        .padding(14)
        .background(.orange.opacity(0.08))
        .clipShape(.rect(cornerRadius: 12))
    }

    private var progressHeader: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Document Readiness")
                    .font(.headline.weight(.bold))
                Spacer()
                Text("\(Int(overallProgress * 100))%")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(AppTheme.forestGreen)
            }

            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(AppTheme.forestGreen.opacity(0.12))
                        .frame(height: 10)

                    RoundedRectangle(cornerRadius: 6)
                        .fill(AppTheme.forestGreen)
                        .frame(width: proxy.size.width * overallProgress, height: 10)
                        .animation(.spring(response: 0.5), value: overallProgress)
                }
            }
            .frame(height: 10)

            HStack {
                Text("\(storage.documents.filter { $0.status == .received || $0.status == .verified }.count) of \(totalCount) secured")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.primary.opacity(0.7))
                Spacer()
            }
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 14))
    }

    private var summaryBar: some View {
        HStack(spacing: 12) {
            StatCard(value: "\(totalCount)", label: "Total", color: .primary)
            StatCard(value: "\(missingCount)", label: "Needed", color: .red)
            StatCard(value: "\(verifiedCount)", label: "Verified", color: AppTheme.forestGreen)
        }
    }
}

private struct CategoryHeroCard: View {
    let category: DocumentCategory
    let documents: [DocumentItem]
    let isExpanded: Bool
    let onToggle: () -> Void
    let onStatusChange: (DocumentItem, DocumentStatus) -> Void

    private var securedCount: Int {
        documents.filter { $0.status == .received || $0.status == .verified }.count
    }

    private var neededCount: Int {
        documents.filter { $0.status == .missing }.count
    }

    private var progress: Double {
        guard !documents.isEmpty else { return 0 }
        return Double(securedCount) / Double(documents.count)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: onToggle) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 12) {
                        Image(systemName: category.icon)
                            .font(.title3.weight(.bold))
                            .foregroundStyle(AppTheme.forestGreen)
                            .frame(width: 40, height: 40)
                            .background(AppTheme.forestGreen.opacity(0.12))
                            .clipShape(.rect(cornerRadius: 10))

                        VStack(alignment: .leading, spacing: 2) {
                            Text(category.rawValue)
                                .font(.headline.weight(.bold))
                                .foregroundStyle(.primary)
                            Text("\(securedCount) of \(documents.count) secured")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        if neededCount > 0 {
                            Text("\(neededCount) needed")
                                .font(.caption2.weight(.bold))
                                .foregroundStyle(.orange)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(.orange.opacity(0.12))
                                .clipShape(Capsule())
                        }

                        Image(systemName: "chevron.down")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.secondary)
                            .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    }

                    ProgressView(value: progress)
                        .tint(AppTheme.forestGreen)
                }
                .padding(16)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .sensoryFeedback(.selection, trigger: isExpanded)

            if isExpanded {
                VStack(spacing: 6) {
                    ForEach(documents) { doc in
                        DocumentRow(document: doc, onStatusChange: { newStatus in
                            onStatusChange(doc, newStatus)
                        })
                    }
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 12)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 14))
    }
}

struct StatCard: View {
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2.bold())
                .foregroundStyle(color)
            Text(label)
                .font(.caption2.weight(.bold))
                .foregroundStyle(.primary.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 12))
    }
}

struct DocumentRow: View {
    let document: DocumentItem
    let onStatusChange: (DocumentStatus) -> Void

    private var statusColor: Color {
        switch document.status {
        case .missing: .red
        case .requested: .orange
        case .received: .blue
        case .verified: AppTheme.forestGreen
        }
    }

    private func statusLabel(_ status: DocumentStatus) -> String {
        switch status {
        case .missing: "Needed"
        case .requested: "Requested"
        case .received: "Received"
        case .verified: "Verified"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                Image(systemName: document.status.icon)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(statusColor)
                    .frame(width: 28)

                VStack(alignment: .leading, spacing: 2) {
                    Text(document.name)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)
                    if !document.notes.isEmpty {
                        Text(document.notes)
                            .font(.caption2.weight(.semibold))
                            .foregroundStyle(.primary.opacity(0.6))
                    }
                }

                Spacer()
            }

            HStack(spacing: 6) {
                ForEach(DocumentStatus.allCases) { status in
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            onStatusChange(status)
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: status.icon)
                                .font(.caption2.weight(.semibold))
                            Text(statusLabel(status))
                                .font(.caption2.weight(.bold))
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(document.status == status ? statusColorFor(status).opacity(0.15) : Color(.tertiarySystemGroupedBackground))
                        .foregroundStyle(document.status == status ? statusColorFor(status) : .primary.opacity(0.6))
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(document.status == status ? statusColorFor(status).opacity(0.5) : .clear, lineWidth: 1)
                        )
                    }
                    .sensoryFeedback(.selection, trigger: document.status)
                }
            }
        }
        .padding(12)
        .background(Color(.tertiarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 10))
    }

    private func statusColorFor(_ status: DocumentStatus) -> Color {
        switch status {
        case .missing: .red
        case .requested: .orange
        case .received: .blue
        case .verified: AppTheme.forestGreen
        }
    }
}
