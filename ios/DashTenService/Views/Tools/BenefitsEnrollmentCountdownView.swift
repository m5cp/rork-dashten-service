import SwiftUI

struct BenefitsEnrollmentCountdownView: View {
    @Bindable var storage: StorageService
    @State private var showAddDeadline: Bool = false

    private var sortedDeadlines: [BenefitDeadline] {
        storage.benefitDeadlines.sorted { a, b in
            if a.isCompleted != b.isCompleted { return !a.isCompleted }
            return a.deadline < b.deadline
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if storage.benefitDeadlines.isEmpty {
                    emptyState
                    suggestedDeadlines
                } else {
                    urgentSection
                    allDeadlinesSection
                    suggestedDeadlines
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 100)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Enrollment Deadlines")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { showAddDeadline = true } label: {
                    Image(systemName: "plus.circle.fill")
                        .accessibilityLabel("Add deadline")
                        .foregroundStyle(AppTheme.forestGreen)
                }
            }
        }
        .sheet(isPresented: $showAddDeadline) {
            AddDeadlineSheet(storage: storage)
        }
        .onAppear { storage.trackToolUsed("benefits_countdown") }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "clock.badge.exclamationmark.fill")
                .font(.system(size: 48))
                .foregroundStyle(.orange.opacity(0.4))
            Text("Track Your Deadlines")
                .font(.title3.weight(.bold))
            Text("Missing enrollment windows is one of the biggest mistakes during transition. Add your key deadlines here.")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(32)
    }

    private var urgentSection: some View {
        let urgent = sortedDeadlines.filter { !$0.isCompleted && daysUntil($0.deadline) <= 30 && daysUntil($0.deadline) >= 0 }
        return Group {
            if !urgent.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(.orange)
                        Text("Due Soon")
                            .font(.headline.weight(.bold))
                    }
                    ForEach(urgent) { deadline in
                        DeadlineRow(deadline: deadline, isUrgent: true) {
                            toggleDeadline(deadline.id)
                        }
                    }
                }
            }
        }
    }

    private var allDeadlinesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("All Deadlines")
                .font(.headline.weight(.bold))
            ForEach(sortedDeadlines) { deadline in
                DeadlineRow(deadline: deadline, isUrgent: false) {
                    toggleDeadline(deadline.id)
                }
            }
        }
    }

    private var suggestedDeadlines: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Common Deadlines to Track")
                .font(.caption.weight(.heavy))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)

            VStack(spacing: 2) {
                SuggestedDeadlineRow(title: "SGLI Coverage Expiration", detail: "120 days after separation", icon: "shield.fill") {
                    addSuggested("SGLI Coverage Expiration", daysFromNow: 120)
                }
                SuggestedDeadlineRow(title: "VGLI Enrollment Window", detail: "240 days after separation", icon: "shield.lefthalf.filled") {
                    addSuggested("VGLI Enrollment Window", daysFromNow: 240)
                }
                SuggestedDeadlineRow(title: "Health Care Enrollment", detail: "Varies — apply early", icon: "cross.case.fill") {
                    addSuggested("Health Care Enrollment", daysFromNow: 90)
                }
                SuggestedDeadlineRow(title: "TSP Withdrawal/Rollover Decision", detail: "No hard deadline but plan early", icon: "arrow.triangle.swap") {
                    addSuggested("TSP Rollover Decision", daysFromNow: 60)
                }
                SuggestedDeadlineRow(title: "401k Enrollment (New Employer)", detail: "Often within 30-90 days of hire", icon: "building.2.fill") {
                    addSuggested("401k Enrollment (New Employer)", daysFromNow: 90)
                }
            }
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))
        }
    }

    private func daysUntil(_ date: Date) -> Int {
        Calendar.current.dateComponents([.day], from: Date(), to: date).day ?? 0
    }

    private func toggleDeadline(_ id: String) {
        guard let idx = storage.benefitDeadlines.firstIndex(where: { $0.id == id }) else { return }
        storage.benefitDeadlines[idx].isCompleted.toggle()
    }

    private func addSuggested(_ title: String, daysFromNow: Int) {
        guard !storage.benefitDeadlines.contains(where: { $0.title == title }) else { return }
        let deadline = BenefitDeadline(
            title: title,
            deadline: Calendar.current.date(byAdding: .day, value: daysFromNow, to: storage.profile.separationDate ?? Date()) ?? Date()
        )
        storage.benefitDeadlines.append(deadline)
    }
}

private struct DeadlineRow: View {
    let deadline: BenefitDeadline
    let isUrgent: Bool
    let onToggle: () -> Void

    private var daysLeft: Int {
        Calendar.current.dateComponents([.day], from: Date(), to: deadline.deadline).day ?? 0
    }

    var body: some View {
        HStack(spacing: 12) {
            Button {
                withAnimation(.spring(response: 0.3)) { onToggle() }
            } label: {
                Image(systemName: deadline.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(deadline.isCompleted ? AppTheme.forestGreen : (daysLeft <= 14 ? .orange : .primary.opacity(0.3)))
                    .symbolEffect(.bounce, value: deadline.isCompleted)
            }
            .sensoryFeedback(.success, trigger: deadline.isCompleted)

            VStack(alignment: .leading, spacing: 3) {
                Text(deadline.title)
                    .font(.subheadline.weight(.bold))
                    .strikethrough(deadline.isCompleted)
                Text(deadline.deadline.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if !deadline.isCompleted {
                VStack(spacing: 1) {
                    Text("\(max(daysLeft, 0))")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(daysLeft <= 14 ? .orange : daysLeft <= 30 ? AppTheme.gold : AppTheme.forestGreen)
                    Text("days")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(.tertiary)
                }
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.secondarySystemGroupedBackground))
                .overlay(
                    isUrgent && !deadline.isCompleted ?
                    RoundedRectangle(cornerRadius: 12).strokeBorder(.orange.opacity(0.3), lineWidth: 1)
                    : nil
                )
        )
    }
}

private struct SuggestedDeadlineRow: View {
    let title: String
    let detail: String
    let icon: String
    let onAdd: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.blue)
                .frame(width: 28)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption.weight(.bold))
                Text(detail)
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button { onAdd() } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.body)
                    .foregroundStyle(AppTheme.forestGreen)
            }
            .accessibilityLabel("Add suggested deadline")
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
    }
}

struct AddDeadlineSheet: View {
    let storage: StorageService
    @Environment(\.dismiss) private var dismiss
    @State private var title: String = ""
    @State private var deadline: Date = Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? Date()
    @State private var notes: String = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Deadline Title", text: $title)
                DatePicker("Due Date", selection: $deadline, displayedComponents: .date)
                TextField("Notes (optional)", text: $notes)
            }
            .navigationTitle("Add Deadline")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let d = BenefitDeadline(title: title.trimmingCharacters(in: .whitespaces), deadline: deadline, notes: notes)
                        storage.benefitDeadlines.append(d)
                        dismiss()
                    }
                    .font(.body.weight(.bold))
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
        .presentationDetents([.medium])
    }
}
