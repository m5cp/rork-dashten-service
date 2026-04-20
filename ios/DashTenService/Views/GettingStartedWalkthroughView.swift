import SwiftUI

struct GettingStartedWalkthroughView: View {
    @Environment(\.dismiss) private var dismiss

    private struct Step: Identifiable {
        let id = UUID()
        let number: Int
        let icon: String
        let color: Color
        let title: String
        let body: String
    }

    private let steps: [Step] = [
        Step(number: 1, icon: "person.crop.circle.fill", color: AppTheme.forestGreen,
             title: "Complete your profile",
             body: "Open the Profile tab and add your branch, status, separation date, and goals. This powers every recommendation in the app."),
        Step(number: 2, icon: "map.fill", color: AppTheme.forestGreen,
             title: "Review Your Roadmap",
             body: "The roadmap at the top of the Plan tab shows every phase of your transition — from 18+ months out to your first year as a civilian. Tap any phase to see exactly what to do and how."),
        Step(number: 3, icon: "scope", color: AppTheme.forestGreen,
             title: "Knock out Recommended Tasks",
             body: "On the Today tab, your Recommended Tasks are the highest-priority items for right now — including anything overdue from earlier phases. Start there."),
        Step(number: 4, icon: "doc.text.fill", color: .orange,
             title: "Secure your documents",
             body: "Work the Documents section on the Plan tab. Gather what's needed now so you're not scrambling later."),
        Step(number: 5, icon: "wrench.and.screwdriver.fill", color: .teal,
             title: "Use the Tools",
             body: "The Tools tab has calculators, a resume translator, interview prep, a jargon translator, and more. Pull them out as you need them."),
        Step(number: 6, icon: "book.fill", color: .blue,
             title: "Learn as you go",
             body: "The Learn tab has guides on mindset, benefits, civilian life, and the first year after service. Read what's relevant to where you are right now.")
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header

                    VStack(spacing: 12) {
                        ForEach(steps) { step in
                            stepCard(step)
                        }
                    }

                    tipCard

                    Button {
                        dismiss()
                    } label: {
                        Text("Got it")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(AppTheme.forestGreen)
                            .clipShape(.rect(cornerRadius: 14))
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 4)
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Getting Started")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(.body.weight(.bold))
                }
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                Image(systemName: "sparkles")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(AppTheme.gold)
                Text("How to plan your transition")
                    .font(.title3.weight(.bold))
            }
            Text("A simple path for using this app. Take it one step at a time — you don't have to do it all today.")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func stepCard(_ step: Step) -> some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                Circle()
                    .fill(step.color.opacity(0.12))
                    .frame(width: 44, height: 44)
                Text("\(step.number)")
                    .font(.headline.weight(.heavy))
                    .foregroundStyle(step.color)
            }

            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 8) {
                    Image(systemName: step.icon)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(step.color)
                    Text(step.title)
                        .font(.subheadline.weight(.bold))
                }
                Text(step.body)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.primary.opacity(0.8))
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 14))
    }

    private var tipCard: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "lightbulb.fill")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(AppTheme.gold)
            VStack(alignment: .leading, spacing: 4) {
                Text("Tip")
                    .font(.caption.weight(.heavy))
                    .foregroundStyle(AppTheme.gold)
                Text("You can export your roadmap to PDF any time from the menu in the top-right of the Plan tab.")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary.opacity(0.8))
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.gold.opacity(0.08))
        .clipShape(.rect(cornerRadius: 12))
    }
}
