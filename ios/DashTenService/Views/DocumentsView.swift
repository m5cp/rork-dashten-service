import SwiftUI

struct DocumentsView: View {
    let storage: StorageService
    @State private var selectedCategory: DocumentCategory?
    @State private var selectedDocument: DocumentItem?

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

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    documentWarningBanner
                    summaryBar
                    categoryFilter

                    ForEach(filteredGroups, id: \.0) { category, docs in
                        VStack(alignment: .leading, spacing: 8) {
                            Label(category.rawValue, systemImage: category.icon)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(AppTheme.forestGreen)
                                .padding(.horizontal, 4)

                            VStack(spacing: 6) {
                                ForEach(docs) { doc in
                                    DocumentRow(document: doc, onStatusChange: { newStatus in
                                        storage.updateDocumentStatus(doc.id, status: newStatus)
                                    })
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Documents")
        }
    }

    private var documentWarningBanner: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.body)
                .foregroundStyle(.orange)
            VStack(alignment: .leading, spacing: 4) {
                Text("Do Not Upload Documents Here")
                    .font(.subheadline.weight(.semibold))
                Text("This is a checklist to track which documents you have in your physical possession. Obtain and secure physical or digital copies yourself. Do not upload sensitive documents to this app.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(14)
        .background(.orange.opacity(0.08))
        .clipShape(.rect(cornerRadius: 12))
    }

    private var filteredGroups: [(DocumentCategory, [DocumentItem])] {
        guard let selected = selectedCategory else { return groupedDocuments }
        return groupedDocuments.filter { $0.0 == selected }
    }

    private var summaryBar: some View {
        HStack(spacing: 12) {
            StatCard(value: "\(storage.documents.count)", label: "Total", color: .primary)
            StatCard(value: "\(missingCount)", label: "Missing", color: .red)
            StatCard(value: "\(verifiedCount)", label: "Verified", color: AppTheme.forestGreen)
        }
    }

    private var categoryFilter: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                FilterChip(title: "All", isSelected: selectedCategory == nil) {
                    selectedCategory = nil
                }
                ForEach(DocumentCategory.allCases) { cat in
                    FilterChip(title: cat.rawValue, isSelected: selectedCategory == cat) {
                        selectedCategory = selectedCategory == cat ? nil : cat
                    }
                }
            }
        }
        .contentMargins(.horizontal, 0)
        .scrollIndicators(.hidden)
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
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 12))
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption.weight(.medium))
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .background(isSelected ? AppTheme.forestGreen : Color(.secondarySystemGroupedBackground))
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
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

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                Image(systemName: document.status.icon)
                    .font(.body)
                    .foregroundStyle(statusColor)
                    .frame(width: 28)

                VStack(alignment: .leading, spacing: 2) {
                    Text(document.name)
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)
                    if !document.notes.isEmpty {
                        Text(document.notes)
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
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
                                .font(.caption2)
                            Text(status.rawValue)
                                .font(.caption2.weight(.medium))
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(document.status == status ? statusColorFor(status).opacity(0.15) : Color(.tertiarySystemGroupedBackground))
                        .foregroundStyle(document.status == status ? statusColorFor(status) : .secondary)
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
        .background(Color(.secondarySystemGroupedBackground))
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


