import SwiftUI

struct DecisionMatrixView: View {
    @Bindable var storage: StorageService
    @State private var showNewMatrix: Bool = false
    @State private var newTitle: String = ""
    @State private var selectedMatrix: DecisionMatrix?

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if storage.decisionMatrices.isEmpty {
                    emptyState
                } else {
                    ForEach(storage.decisionMatrices) { matrix in
                        Button {
                            selectedMatrix = matrix
                        } label: {
                            MatrixCard(matrix: matrix)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 100)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Decision Matrix")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showNewMatrix = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundStyle(AppTheme.forestGreen)
                }
            }
        }
        .alert("New Decision", isPresented: $showNewMatrix) {
            TextField("What are you deciding?", text: $newTitle)
            Button("Create") {
                guard !newTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                var matrix = DecisionMatrix(title: newTitle)
                matrix.options = [
                    DecisionOption(name: "Option A", criteriaCount: 3),
                    DecisionOption(name: "Option B", criteriaCount: 3),
                ]
                storage.decisionMatrices.append(matrix)
                storage.unlockBadge("decision_made")
                storage.trackToolUsed("decision_matrix")
                newTitle = ""
                selectedMatrix = matrix
            }
            Button("Cancel", role: .cancel) { newTitle = "" }
        }
        .sheet(item: $selectedMatrix) { matrix in
            DecisionMatrixDetailView(storage: storage, matrixId: matrix.id)
        }
        .onAppear {
            storage.trackToolUsed("decision_matrix")
        }
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "square.grid.3x3.fill")
                .font(.system(size: 48))
                .foregroundStyle(AppTheme.forestGreen.opacity(0.3))
            Text("No Decisions Yet")
                .font(.title3.weight(.bold))
            Text("Use the Decision Matrix for any big choice — which city, which job, school vs. work. Enter your options and criteria, weight what matters most, and see a clear winner.")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button {
                showNewMatrix = true
            } label: {
                Label("New Decision", systemImage: "plus")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(AppTheme.forestGreen)
                    .clipShape(.rect(cornerRadius: 14))
            }
        }
        .padding(32)
    }
}

private struct MatrixCard: View {
    let matrix: DecisionMatrix

    private var winner: String {
        guard !matrix.options.isEmpty else { return "—" }
        let scored = matrix.options.map { option in
            let total = zip(option.scores, matrix.weights).map { $0 * $1 }.reduce(0, +)
            return (option.name, total)
        }
        return scored.max(by: { $0.1 < $1.1 })?.0 ?? "—"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(matrix.title)
                    .font(.headline.weight(.bold))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.tertiary)
            }
            HStack(spacing: 12) {
                Label("\(matrix.options.count) options", systemImage: "square.stack.fill")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                Label("\(matrix.criteria.count) criteria", systemImage: "list.bullet")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            HStack {
                Text("Leading:")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                Text(winner)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(AppTheme.forestGreen)
            }
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 14))
    }
}

struct DecisionMatrixDetailView: View {
    let storage: StorageService
    let matrixId: String
    @Environment(\.dismiss) private var dismiss
    @State private var newCriteria: String = ""
    @State private var newOption: String = ""
    @State private var showAddCriteria: Bool = false
    @State private var showAddOption: Bool = false

    private var matrixIndex: Int? {
        storage.decisionMatrices.firstIndex(where: { $0.id == matrixId })
    }

    var body: some View {
        NavigationStack {
            Group {
                if let idx = matrixIndex {
                    ScrollView {
                        VStack(spacing: 20) {
                            resultsSection(storage.decisionMatrices[idx])
                            criteriaSection(idx)
                            optionsSection(idx)
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 100)
                    }
                } else {
                    ContentUnavailableView("Matrix not found", systemImage: "exclamationmark.triangle")
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(matrixIndex.map { storage.decisionMatrices[$0].title } ?? "Decision")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(.body.weight(.bold))
                }
            }
            .alert("Add Criteria", isPresented: $showAddCriteria) {
                TextField("Criteria name", text: $newCriteria)
                Button("Add") {
                    guard let idx = matrixIndex, !newCriteria.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                    storage.decisionMatrices[idx].criteria.append(newCriteria)
                    storage.decisionMatrices[idx].weights.append(1.0)
                    for i in storage.decisionMatrices[idx].options.indices {
                        storage.decisionMatrices[idx].options[i].scores.append(5.0)
                    }
                    newCriteria = ""
                }
                Button("Cancel", role: .cancel) { newCriteria = "" }
            }
            .alert("Add Option", isPresented: $showAddOption) {
                TextField("Option name", text: $newOption)
                Button("Add") {
                    guard let idx = matrixIndex, !newOption.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                    let count = storage.decisionMatrices[idx].criteria.count
                    storage.decisionMatrices[idx].options.append(DecisionOption(name: newOption, criteriaCount: count))
                    newOption = ""
                }
                Button("Cancel", role: .cancel) { newOption = "" }
            }
        }
    }

    private func resultsSection(_ matrix: DecisionMatrix) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Results")
                .font(.headline.weight(.bold))

            let scored = matrix.options.map { option in
                let total = zip(option.scores, matrix.weights).map { $0 * $1 }.reduce(0, +)
                return (option.name, total)
            }.sorted { $0.1 > $1.1 }

            let maxScore = scored.first?.1 ?? 1

            VStack(spacing: 8) {
                ForEach(Array(scored.enumerated()), id: \.offset) { index, item in
                    HStack(spacing: 12) {
                        Text("\(index + 1)")
                            .font(.caption.weight(.heavy))
                            .foregroundStyle(index == 0 ? .white : .secondary)
                            .frame(width: 24, height: 24)
                            .background(index == 0 ? AppTheme.forestGreen : Color.clear)
                            .clipShape(Circle())
                        Text(item.0)
                            .font(.subheadline.weight(.bold))
                        Spacer()
                        GeometryReader { geo in
                            RoundedRectangle(cornerRadius: 4)
                                .fill(index == 0 ? AppTheme.forestGreen : AppTheme.forestGreen.opacity(0.3))
                                .frame(width: max(geo.size.width * (maxScore > 0 ? item.1 / maxScore : 0), 4))
                        }
                        .frame(width: 80, height: 12)
                        Text(String(format: "%.1f", item.1))
                            .font(.caption.weight(.bold))
                            .foregroundStyle(index == 0 ? AppTheme.forestGreen : .secondary)
                            .frame(width: 36, alignment: .trailing)
                    }
                }
            }
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 14))
    }

    private func criteriaSection(_ idx: Int) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Criteria & Weights")
                    .font(.headline.weight(.bold))
                Spacer()
                Button {
                    showAddCriteria = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                        .foregroundStyle(AppTheme.forestGreen)
                }
            }

            ForEach(Array(storage.decisionMatrices[idx].criteria.enumerated()), id: \.offset) { cIdx, criteria in
                HStack {
                    Text(criteria)
                        .font(.subheadline.weight(.semibold))
                    Spacer()
                    HStack(spacing: 4) {
                        Text("Weight:")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                        Stepper(
                            "\(String(format: "%.0f", storage.decisionMatrices[idx].weights[cIdx]))",
                            value: Binding(
                                get: { storage.decisionMatrices[idx].weights[cIdx] },
                                set: { storage.decisionMatrices[idx].weights[cIdx] = $0 }
                            ),
                            in: 1...5,
                            step: 1
                        )
                        .font(.caption.weight(.bold))
                    }
                }
                .padding(10)
                .background(Color(.tertiarySystemGroupedBackground))
                .clipShape(.rect(cornerRadius: 8))
            }
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 14))
    }

    private func optionsSection(_ idx: Int) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Score Each Option")
                    .font(.headline.weight(.bold))
                Spacer()
                Button {
                    showAddOption = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                        .foregroundStyle(AppTheme.forestGreen)
                }
            }

            ForEach(Array(storage.decisionMatrices[idx].options.enumerated()), id: \.element.id) { oIdx, option in
                VStack(alignment: .leading, spacing: 8) {
                    Text(option.name)
                        .font(.subheadline.weight(.bold))

                    ForEach(Array(storage.decisionMatrices[idx].criteria.enumerated()), id: \.offset) { cIdx, criteria in
                        if cIdx < storage.decisionMatrices[idx].options[oIdx].scores.count {
                            HStack {
                                Text(criteria)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.secondary)
                                    .frame(width: 80, alignment: .leading)
                                Slider(
                                    value: Binding(
                                        get: { storage.decisionMatrices[idx].options[oIdx].scores[cIdx] },
                                        set: { storage.decisionMatrices[idx].options[oIdx].scores[cIdx] = $0 }
                                    ),
                                    in: 1...10,
                                    step: 1
                                )
                                .tint(AppTheme.forestGreen)
                                Text("\(Int(storage.decisionMatrices[idx].options[oIdx].scores[cIdx]))")
                                    .font(.caption.weight(.bold))
                                    .frame(width: 24)
                            }
                        }
                    }
                }
                .padding(12)
                .background(Color(.tertiarySystemGroupedBackground))
                .clipShape(.rect(cornerRadius: 10))
            }
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 14))
    }
}
