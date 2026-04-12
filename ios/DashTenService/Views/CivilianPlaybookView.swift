import SwiftUI

struct CivilianPlaybookView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                GuideIntroBanner(
                    text: "The unwritten rules nobody tells you about civilian life. Read these before your first week out.",
                    color: .blue
                )

                GuideSection(
                    title: "Workplace Norms",
                    icon: "building.2.fill",
                    color: .teal,
                    items: [
                        "Meetings run differently — expect open discussion where rank doesn't determine who speaks",
                        "Civilian emails tend to be longer and more diplomatic — use a warmer tone than you're used to",
                        "Dress codes vary wildly — ask before your first day, overdress slightly when in doubt",
                        "Feedback cycles are slower — don't wait for it, ask proactively from your manager",
                    ]
                )

                GuideSection(
                    title: "Communication",
                    icon: "bubble.left.and.bubble.right.fill",
                    color: .blue,
                    items: [
                        "Soften the delivery — \"Do this now\" becomes \"Would you be able to prioritize this?\"",
                        "Your military acronyms are a foreign language to civilians — spell everything out",
                        "Small talk isn't wasted time — it's how trust and relationships are built",
                        "Conflict resolution is slower and more process-driven — go through proper channels",
                    ]
                )

                GuideSection(
                    title: "Social Dynamics",
                    icon: "person.2.fill",
                    color: .pink,
                    items: [
                        "Most civilians have no frame of reference for military life — don't take it personally",
                        "\"Thank you for your service\" will happen constantly — have a comfortable response ready",
                        "You'll miss the camaraderie — actively seek communities to rebuild your social circle",
                        "Being honest about struggles builds deeper civilian friendships",
                    ]
                )

                GuideSection(
                    title: "Money & Benefits",
                    icon: "dollarsign.circle.fill",
                    color: .orange,
                    items: [
                        "Negotiate your salary — in the civilian world, negotiation is expected",
                        "Evaluate total compensation (health, retirement, PTO), not just base salary",
                        "Without tax-free allowances, your take-home may feel significantly lower",
                    ]
                )

                GuideSection(
                    title: "Daily Life",
                    icon: "clock.fill",
                    color: .purple,
                    items: [
                        "Nobody tells you when to wake up — build a routine that gives structure without rigidity",
                        "Applications and processes take longer than you expect — build buffer time",
                        "Rest is productive — learn to be comfortable with unstructured time",
                    ]
                )

                GuideDisclaimer(text: "Everyone's experience is different. Take what's useful, adapt what isn't, and give yourself grace.")
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Civilian Playbook")
        .navigationBarTitleDisplayMode(.inline)
    }
}
