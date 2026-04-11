import SwiftUI

struct CivilianPlaybookView: View {
    private let sections: [(String, String, Color, [PlaybookTip])] = [
        ("Workplace Norms", "building.2.fill", .teal, [
            PlaybookTip(title: "Meetings Run Differently", body: "Expect longer meetings with open discussion. Rank doesn't determine who speaks. Be ready to share your perspective as an equal, not just when called upon."),
            PlaybookTip(title: "Email Culture", body: "Civilian emails tend to be longer and more diplomatic. \"Per my last email\" is passive-aggressive. Add context, say please, and use a warmer tone than you're used to."),
            PlaybookTip(title: "Dress Codes Vary Wildly", body: "Some offices are suits, others are hoodies and sneakers. Ask before your first day. When in doubt, overdress slightly — you can always dial it back."),
            PlaybookTip(title: "Performance Reviews", body: "Feedback cycles are slower — often quarterly or annually. Don't wait for feedback. Ask for it proactively and regularly from your manager."),
        ]),
        ("Communication", "bubble.left.and.bubble.right.fill", .blue, [
            PlaybookTip(title: "Soften the Delivery", body: "\"Do this now\" becomes \"Would you be able to prioritize this?\" It's not weakness — it's how civilian teams collaborate effectively."),
            PlaybookTip(title: "Acronyms Don't Translate", body: "Your military acronyms are a foreign language to civilians. Spell everything out until you learn the new shorthand of your industry."),
            PlaybookTip(title: "Small Talk Matters", body: "Water cooler conversation isn't wasted time — it's how trust and relationships are built in civilian workplaces. Lean into it."),
            PlaybookTip(title: "Conflict Resolution", body: "Civilian conflict resolution is usually slower and more process-driven. Go through proper channels. Direct confrontation rarely works the way it did in uniform."),
        ]),
        ("Social Dynamics", "person.2.fill", .pink, [
            PlaybookTip(title: "Nobody Understands Your Service", body: "Most civilians have no frame of reference for military life. Don't take it personally. Learn to translate your experiences into relatable stories."),
            PlaybookTip(title: "The \"Thank You for Your Service\" Moment", body: "It will happen constantly. Have a comfortable response ready. Most people mean well — they just don't know what else to say."),
            PlaybookTip(title: "Building a New Tribe", body: "You'll miss the camaraderie. That's normal. Actively seek communities — sports leagues, professional groups, volunteer orgs — to rebuild your social circle."),
            PlaybookTip(title: "Vulnerability Is Strength", body: "Civilian friendships often require more emotional openness than military bonds. Being honest about struggles builds deeper connections."),
        ]),
        ("Money & Benefits", "dollarsign.circle.fill", .orange, [
            PlaybookTip(title: "Negotiate Your Salary", body: "In the military, pay is fixed. In the civilian world, negotiation is expected. Research market rates and never accept the first offer without discussion."),
            PlaybookTip(title: "Benefits Packages Vary", body: "Health insurance, retirement matching, PTO — every company is different. Evaluate total compensation, not just the base salary number."),
            PlaybookTip(title: "Taxes Change Everything", body: "Without tax-free allowances like BAH, your take-home pay may feel significantly lower. Build your budget around net pay, not gross."),
        ]),
        ("Daily Life", "clock.fill", .purple, [
            PlaybookTip(title: "Create Your Own Structure", body: "Nobody is going to tell you when to wake up or work out. Build a daily routine that gives you the structure you need without the rigidity you don't."),
            PlaybookTip(title: "Time Moves Differently", body: "Applications, claims, and processes take longer than you expect. Build buffer time into everything and practice patience."),
            PlaybookTip(title: "It's OK to Not Be Busy", body: "In the military, downtime felt wrong. As a civilian, rest is productive. Learn to be comfortable with unstructured time."),
        ]),
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("The unwritten rules nobody tells you about civilian life. Read these before your first week out.")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary.opacity(0.8))
                }
                .padding(14)
                .background(AppTheme.forestGreen.opacity(0.06))
                .clipShape(.rect(cornerRadius: 12))

                ForEach(sections, id: \.0) { title, icon, color, tips in
                    PlaybookSection(title: title, icon: icon, color: color, tips: tips)
                }

                Text("Everyone's experience is different. Take what's useful, adapt what isn't, and give yourself grace during the adjustment.")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary.opacity(0.6))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Civilian Playbook")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PlaybookSection: View {
    let title: String
    let icon: String
    let color: Color
    let tips: [PlaybookTip]
    @State private var isExpanded: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.spring(response: 0.3)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: icon)
                        .font(.body.weight(.bold))
                        .foregroundStyle(color)
                        .frame(width: 32, height: 32)
                        .background(color.opacity(0.12))
                        .clipShape(Circle())
                    Text(title)
                        .font(.headline.weight(.bold))
                    Spacer()
                    Text("\(tips.count)")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.primary.opacity(0.5))
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
                VStack(spacing: 10) {
                    ForEach(tips) { tip in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(tip.title)
                                .font(.subheadline.weight(.bold))
                            Text(tip.body)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.primary.opacity(0.8))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .background(color.opacity(0.04))
                        .clipShape(.rect(cornerRadius: 10))
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
}

nonisolated struct PlaybookTip: Identifiable, Sendable {
    let id = UUID()
    let title: String
    let body: String
}
