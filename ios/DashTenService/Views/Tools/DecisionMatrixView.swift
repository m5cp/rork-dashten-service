import SwiftUI

struct DecisionMatrixView: View {
    @Bindable var storage: StorageService
    @State private var showNewMatrix: Bool = false
    @State private var newTitle: String = ""
    @State private var selectedMatrix: DecisionMatrix?

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerCard

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

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "square.grid.3x3.fill")
                    .foregroundStyle(.blue)
                Text("Weighted Decision Tool")
                    .font(.subheadline.weight(.bold))
            }
            Text("Use the Decision Matrix for any big choice — which city, which job, school vs. work. Add your options, define what matters most, score each one, and see a clear winner based on your priorities.")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.primary.opacity(0.8))
        }
        .padding(14)
        .background(.blue.opacity(0.06))
        .clipShape(.rect(cornerRadius: 12))
    }

    private var emptyState: some View {
        VStack(spacing: 24) {
            VStack(spacing: 12) {
                Image(systemName: "square.grid.3x3.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(AppTheme.forestGreen.opacity(0.4))
                Text("No Decisions Yet")
                    .font(.title3.weight(.bold))
                Text("Create your first decision matrix to compare options side by side with weighted criteria.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            VStack(alignment: .leading, spacing: 10) {
                Label("Add your options (e.g. Job A vs. Job B)", systemImage: "1.circle.fill")
                    .font(.subheadline.weight(.semibold))
                Label("Define criteria that matter (salary, location, growth)", systemImage: "2.circle.fill")
                    .font(.subheadline.weight(.semibold))
                Label("Score each option and see the results", systemImage: "3.circle.fill")
                    .font(.subheadline.weight(.semibold))
            }
            .foregroundStyle(.secondary)

            Button {
                showNewMatrix = true
            } label: {
                Label("Create Decision", systemImage: "plus")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 14)
                    .background(AppTheme.forestGreen)
                    .clipShape(.rect(cornerRadius: 14))
            }
        }
        .padding(28)
    }
}

private struct MatrixCard: View {
    let matrix: DecisionMatrix

    private var rankedOptions: [(String, Double)] {
        guard !matrix.options.isEmpty else { return [] }
        return matrix.options.map { option in
            let total = zip(option.scores, matrix.weights).map { $0 * $1 }.reduce(0, +)
            return (option.name, total)
        }.sorted { $0.1 > $1.1 }
    }

    private var maxScore: Double {
        rankedOptions.first?.1 ?? 1
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(matrix.title)
                        .font(.headline.weight(.bold))
                    HStack(spacing: 10) {
                        Label("\(matrix.options.count) options", systemImage: "square.stack.fill")
                        Label("\(matrix.criteria.count) criteria", systemImage: "slider.horizontal.3")
                    }
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.tertiary)
            }

            if !rankedOptions.isEmpty {
                VStack(spacing: 6) {
                    ForEach(Array(rankedOptions.enumerated()), id: \.offset) { index, item in
                        HStack(spacing: 10) {
                            Text(item.0)
                                .font(.caption.weight(.semibold))
                                .frame(width: 70, alignment: .leading)
                                .lineLimit(1)

                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color(.tertiarySystemGroupedBackground))
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(index == 0 ? AppTheme.forestGreen : AppTheme.forestGreen.opacity(0.35))
                                        .frame(width: max(geo.size.width * (maxScore > 0 ? item.1 / maxScore : 0), 4))
                                }
                            }
                            .frame(height: 10)

                            Text(String(format: "%.1f", item.1))
                                .font(.caption.weight(.bold))
                                .foregroundStyle(index == 0 ? AppTheme.forestGreen : .secondary)
                                .frame(width: 32, alignment: .trailing)
                        }
                    }
                }
            }

            if let winner = rankedOptions.first {
                HStack(spacing: 6) {
                    Image(systemName: "trophy.fill")
                        .font(.caption2)
                        .foregroundStyle(AppTheme.gold)
                    Text("Leading: \(winner.0)")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(AppTheme.forestGreen)
                }
            }
        }
        .padding(16)
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
    @State private var showDeleteConfirm: Bool = false

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
                            deleteButton
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
            .alert("Delete Decision?", isPresented: $showDeleteConfirm) {
                Button("Delete", role: .destructive) {
                    if let idx = matrixIndex {
                        storage.decisionMatrices.remove(at: idx)
                    }
                    dismiss()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This action cannot be undone.")
            }
        }
    }

    private func resultsSection(_ matrix: DecisionMatrix) -> some View {
        let scored = matrix.options.map { option in
            let total = zip(option.scores, matrix.weights).map { $0 * $1 }.reduce(0, +)
            return (option.name, total)
        }.sorted { $0.1 > $1.1 }

        let maxScore = scored.first?.1 ?? 1

        return VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "chart.bar.fill")
                    .foregroundStyle(AppTheme.gold)
                Text("Results")
                    .font(.headline.weight(.bold))
            }

            if scored.isEmpty {
                Text("Add options to see results")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 12)
            } else {
                VStack(spacing: 10) {
                    ForEach(Array(scored.enumerated()), id: \.offset) { index, item in
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(index == 0 ? AppTheme.forestGreen : Color(.tertiarySystemGroupedBackground))
                                    .frame(width: 28, height: 28)
                                if index == 0 {
                                    Image(systemName: "trophy.fill")
                                        .font(.caption2.weight(.bold))
                                        .foregroundStyle(.white)
                                } else {
                                    Text("\(index + 1)")
                                        .font(.caption.weight(.heavy))
                                        .foregroundStyle(.secondary)
                                }
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(item.0)
                                        .font(.subheadline.weight(.bold))
                                    Spacer()
                                    Text(String(format: "%.1f pts", item.1))
                                        .font(.caption.weight(.bold))
                                        .foregroundStyle(index == 0 ? AppTheme.forestGreen : .secondary)
                                }

                                GeometryReader { geo in
                                    ZStack(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(Color(.tertiarySystemGroupedBackground))
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(
                                                index == 0
                                                ? AnyShapeStyle(LinearGradient(colors: [AppTheme.forestGreen, AppTheme.forestGreen.opacity(0.7)], startPoint: .leading, endPoint: .trailing))
                                                : AnyShapeStyle(AppTheme.forestGreen.opacity(0.3))
                                            )
                                            .frame(width: max(geo.size.width * (maxScore > 0 ? item.1 / maxScore : 0), 4))
                                    }
                                }
                                .frame(height: 8)
                            }
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 14))
    }

    private func criteriaSection(_ idx: Int) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "slider.horizontal.3")
                        .foregroundStyle(.blue)
                    Text("Criteria & Weights")
                        .font(.headline.weight(.bold))
                }
                Spacer()
                Button {
                    showAddCriteria = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                        .foregroundStyle(AppTheme.forestGreen)
                }
            }

            if storage.decisionMatrices[idx].criteria.isEmpty {
                Text("Add criteria to evaluate your options")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 8)
            } else {
                VStack(spacing: 8) {
                    ForEach(Array(storage.decisionMatrices[idx].criteria.enumerated()), id: \.offset) { cIdx, criteria in
                        HStack(spacing: 12) {
                            Text(criteria)
                                .font(.subheadline.weight(.semibold))
                                .lineLimit(1)

                            Spacer()

                            HStack(spacing: 2) {
                                ForEach(1...5, id: \.self) { level in
                                    Button {
                                        storage.decisionMatrices[idx].weights[cIdx] = Double(level)
                                    } label: {
                                        Image(systemName: level <= Int(storage.decisionMatrices[idx].weights[cIdx]) ? "circle.fill" : "circle")
                                            .font(.system(size: 10))
                                            .foregroundStyle(level <= Int(storage.decisionMatrices[idx].weights[cIdx]) ? AppTheme.forestGreen : Color(.tertiaryLabel))
                                    }
                                    .buttonStyle(.plain)
                                }
                            }

                            Text("×\(Int(storage.decisionMatrices[idx].weights[cIdx]))")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(AppTheme.forestGreen)
                                .frame(width: 28, alignment: .trailing)

                            Button {
                                let criteriaIdx = cIdx
                                storage.decisionMatrices[idx].criteria.remove(at: criteriaIdx)
                                storage.decisionMatrices[idx].weights.remove(at: criteriaIdx)
                                for i in storage.decisionMatrices[idx].options.indices {
                                    if criteriaIdx < storage.decisionMatrices[idx].options[i].scores.count {
                                        storage.decisionMatrices[idx].options[i].scores.remove(at: criteriaIdx)
                                    }
                                }
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.caption)
                                    .foregroundStyle(.secondary.opacity(0.5))
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(Color(.tertiarySystemGroupedBackground))
                        .clipShape(.rect(cornerRadius: 10))
                    }
                }
            }
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 14))
    }

    private func optionsSection(_ idx: Int) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "square.stack.fill")
                        .foregroundStyle(.purple)
                    Text("Score Each Option")
                        .font(.headline.weight(.bold))
                }
                Spacer()
                Button {
                    showAddOption = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                        .foregroundStyle(AppTheme.forestGreen)
                }
            }

            Text("Slide to rate each option (1 = worst, 10 = best)")
                .font(.caption)
                .foregroundStyle(.secondary)

            ForEach(Array(storage.decisionMatrices[idx].options.enumerated()), id: \.element.id) { oIdx, option in
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(option.name)
                            .font(.subheadline.weight(.bold))
                        Spacer()

                        let total = zip(option.scores, storage.decisionMatrices[idx].weights).map { $0 * $1 }.reduce(0, +)
                        Text(String(format: "%.1f pts", total))
                            .font(.caption.weight(.bold))
                            .foregroundStyle(AppTheme.forestGreen)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(AppTheme.forestGreen.opacity(0.1))
                            .clipShape(.rect(cornerRadius: 6))

                        Button {
                            storage.decisionMatrices[idx].options.remove(at: oIdx)
                        } label: {
                            Image(systemName: "trash.circle.fill")
                                .font(.body)
                                .foregroundStyle(.red.opacity(0.6))
                        }
                        .buttonStyle(.plain)
                    }

                    ForEach(Array(storage.decisionMatrices[idx].criteria.enumerated()), id: \.offset) { cIdx, criteria in
                        if cIdx < storage.decisionMatrices[idx].options[oIdx].scores.count {
                            VStack(spacing: 4) {
                                HStack {
                                    Text(criteria)
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(.secondary)
                                    Spacer()
                                    Text("\(Int(storage.decisionMatrices[idx].options[oIdx].scores[cIdx]))/10")
                                        .font(.caption.weight(.bold))
                                        .monospacedDigit()
                                }
                                Slider(
                                    value: Binding(
                                        get: { storage.decisionMatrices[idx].options[oIdx].scores[cIdx] },
                                        set: { storage.decisionMatrices[idx].options[oIdx].scores[cIdx] = $0 }
                                    ),
                                    in: 1...10,
                                    step: 1
                                )
                                .tint(AppTheme.forestGreen)
                            }
                        }
                    }
                }
                .padding(14)
                .background(Color(.tertiarySystemGroupedBackground))
                .clipShape(.rect(cornerRadius: 12))
            }
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 14))
    }

    private var deleteButton: some View {
        Button {
            showDeleteConfirm = true
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "trash")
                Text("Delete Decision")
            }
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.red)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.red.opacity(0.08))
            .clipShape(.rect(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}
