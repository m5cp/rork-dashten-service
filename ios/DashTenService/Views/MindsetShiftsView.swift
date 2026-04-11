import SwiftUI

struct MindsetShiftsView: View {
    @State private var selectedCategory: MindsetCategory?
    private let shifts = TransitionDataService.mindsetShifts()

    private var filteredShifts: [MindsetShift] {
        guard let category = selectedCategory else { return shifts }
        return shifts.filter { $0.category == category }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Transition isn't just logistical — it's mental. These shifts help you navigate the biggest changes between military and civilian life.")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary.opacity(0.8))
                }
                .padding(14)
                .background(AppTheme.forestGreen.opacity(0.06))
                .clipShape(.rect(cornerRadius: 12))

                ScrollView(.horizontal) {
                    HStack(spacing: 8) {
                        FilterChip(title: "All", isSelected: selectedCategory == nil) {
                            withAnimation(.spring(response: 0.3)) { selectedCategory = nil }
                        }
                        ForEach(MindsetCategory.allCases, id: \.rawValue) { category in
                            FilterChip(title: category.rawValue, isSelected: selectedCategory == category) {
                                withAnimation(.spring(response: 0.3)) { selectedCategory = category }
                            }
                        }
                    }
                }
                .contentMargins(.horizontal, 0)
                .scrollIndicators(.hidden)

                ForEach(filteredShifts) { shift in
                    MindsetShiftCard(shift: shift)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Mindset Shifts")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MindsetShiftCard: View {
    let shift: MindsetShift
    @State private var isExpanded: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.spring(response: 0.35)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: iconForCategory(shift.category))
                        .font(.body.weight(.bold))
                        .foregroundStyle(colorForCategory(shift.category))
                        .frame(width: 36, height: 36)
                        .background(colorForCategory(shift.category).opacity(0.12))
                        .clipShape(Circle())

                    VStack(alignment: .leading, spacing: 2) {
                        Text(shift.title)
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(.primary)
                        Text(shift.category.rawValue)
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(colorForCategory(shift.category))
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.primary.opacity(0.4))
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .padding(16)

            if isExpanded {
                VStack(alignment: .leading, spacing: 14) {
                    Divider()

                    VStack(alignment: .leading, spacing: 6) {
                        Label("In the Military", systemImage: "chevron.left.2")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.orange)
                        Text(shift.militaryMindset)
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.primary.opacity(0.8))
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Label("As a Civilian", systemImage: "chevron.right.2")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(AppTheme.forestGreen)
                        Text(shift.civilianMindset)
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.primary.opacity(0.8))
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Label("The Insight", systemImage: "lightbulb.fill")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(AppTheme.gold)
                        Text(shift.insight)
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.primary.opacity(0.8))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 14))
        .sensoryFeedback(.selection, trigger: isExpanded)
    }

    private func iconForCategory(_ category: MindsetCategory) -> String {
        switch category {
        case .identity: "person.fill"
        case .culture: "building.2.fill"
        case .communication: "bubble.left.and.bubble.right.fill"
        case .dailyLife: "clock.fill"
        case .relationships: "person.2.fill"
        }
    }

    private func colorForCategory(_ category: MindsetCategory) -> Color {
        switch category {
        case .identity: .purple
        case .culture: .teal
        case .communication: .blue
        case .dailyLife: .orange
        case .relationships: .pink
        }
    }
}

