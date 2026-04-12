import SwiftUI

struct MindsetShiftsView: View {
    private let shifts = TransitionDataService.mindsetShifts()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                GuideIntroBanner(
                    text: "Transition isn't just logistical — it's mental. These shifts help you navigate the biggest changes between military and civilian life.",
                    color: .indigo
                )

                ForEach(shifts) { shift in
                    MindsetShiftCard(shift: shift)
                }

                GuideDisclaimer(text: "Give yourself time. These shifts don't happen overnight, and that's okay.")
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

    private var color: Color {
        switch shift.category {
        case .identity: .purple
        case .culture: .teal
        case .communication: .blue
        case .dailyLife: .orange
        case .relationships: .pink
        }
    }

    private var icon: String {
        switch shift.category {
        case .identity: "person.fill"
        case .culture: "building.2.fill"
        case .communication: "bubble.left.and.bubble.right.fill"
        case .dailyLife: "clock.fill"
        case .relationships: "person.2.fill"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.spring(response: 0.35)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: icon)
                        .font(.body.weight(.bold))
                        .foregroundStyle(color)
                        .frame(width: 32, height: 32)
                        .background(color.opacity(0.12))
                        .clipShape(.rect(cornerRadius: 8))

                    VStack(alignment: .leading, spacing: 2) {
                        Text(shift.title)
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(.primary)
                        Text(shift.category.rawValue)
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(color)
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.tertiary)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .padding(16)

            if isExpanded {
                VStack(alignment: .leading, spacing: 14) {
                    Divider()
                        .padding(.horizontal, 16)

                    VStack(alignment: .leading, spacing: 12) {
                        ShiftDetail(label: "In the Military", icon: "chevron.left.2", color: .orange, text: shift.militaryMindset)
                        ShiftDetail(label: "As a Civilian", icon: "chevron.right.2", color: AppTheme.forestGreen, text: shift.civilianMindset)
                        ShiftDetail(label: "The Insight", icon: "lightbulb.fill", color: AppTheme.gold, text: shift.insight)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 14))
        .sensoryFeedback(.selection, trigger: isExpanded)
    }
}

private struct ShiftDetail: View {
    let label: String
    let icon: String
    let color: Color
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Label(label, systemImage: icon)
                .font(.caption.weight(.bold))
                .foregroundStyle(color)
            Text(text)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.primary.opacity(0.85))
        }
    }
}
