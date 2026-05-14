import SwiftUI

struct SalaryNegotiationView: View {
    @State private var targetSalary: String = ""
    @State private var walkAwaySalary: String = ""
    @State private var bestAlternative: String = ""
    @State private var copiedScript: String? = nil
    @State private var checklist: Set<String> = []

    private let lockedInPrefs = ChecklistKey.allCases

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                heroCard
                worksheetCard
                leversCard
                scriptsSection
                objectionsCard
                veteranAnglesCard
                checklistCard
                DashTenInfoFooter()
            }
            .readableContentWidth()
            .padding(.horizontal, 16)
            .padding(.bottom, 40)
        }
        .background(Color(.systemGroupedBackground))
        .keyboardDoneToolbar()
        .navigationTitle("Negotiation Playbook")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Hero

    private var heroCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "mic.fill")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(AppTheme.gold)
                Text("Negotiate with confidence")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
            }
            Text("Scripts, levers, and answers to the toughest objections — plus a worksheet to lock in your number before the call.")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white.opacity(0.85))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.forestGreen)
        .clipShape(.rect(cornerRadius: 16))
    }

    // MARK: - Worksheet

    private var worksheetCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Know Your Number", icon: "scope", color: AppTheme.forestGreen)

            VStack(spacing: 10) {
                worksheetRow(label: "Target", sublabel: "Where you'd love to land", value: $targetSalary, color: AppTheme.forestGreen)
                Divider()
                worksheetRow(label: "Walk-Away", sublabel: "The number below which you decline", value: $walkAwaySalary, color: .orange)
                Divider()
                worksheetRow(label: "BATNA", sublabel: "Your best other option — annualized", value: $bestAlternative, color: .blue)
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))

            Text("Decide all three before any conversation. If they offer below your walk-away, you walk — no exceptions.")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func worksheetRow(label: String, sublabel: String, value: Binding<String>, color: Color) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(label).font(.subheadline.weight(.bold))
                Text(sublabel).font(.caption2.weight(.bold)).foregroundStyle(color)
            }
            Spacer()
            HStack(spacing: 4) {
                Text("$")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.primary.opacity(0.7))
                TextField("0", text: value)
                    .font(.subheadline.weight(.bold))
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 110)
            }
        }
    }

    // MARK: - Levers

    private var leversCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Levers Beyond Base", icon: "slider.horizontal.3", color: .indigo)

            VStack(spacing: 0) {
                ForEach(Array(levers.enumerated()), id: \.offset) { idx, lever in
                    leverRow(lever)
                    if idx < levers.count - 1 {
                        Divider().padding(.leading, 50)
                    }
                }
            }
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))
        }
    }

    private func leverRow(_ lever: Lever) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: lever.icon)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(lever.color)
                .frame(width: 32, height: 32)
                .background(lever.color.opacity(0.12))
                .clipShape(.rect(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 3) {
                Text(lever.title).font(.subheadline.weight(.bold))
                Text(lever.detail)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(12)
    }

    private let levers: [Lever] = [
        Lever(icon: "dollarsign.circle.fill", color: AppTheme.forestGreen, title: "Base Salary", detail: "The biggest compounding lever. Anchor here first, every time."),
        Lever(icon: "gift.fill", color: .pink, title: "Sign-On Bonus", detail: "Easier for companies to approve. Ask if base is capped."),
        Lever(icon: "chart.line.uptrend.xyaxis", color: .purple, title: "Equity / RSUs", detail: "Vesting schedule matters as much as the grant size."),
        Lever(icon: "calendar", color: .teal, title: "PTO & Holidays", detail: "Negotiate extra week of PTO if base won't move."),
        Lever(icon: "house.fill", color: .blue, title: "Remote / Hybrid", detail: "Days in office, location flexibility, relocation package."),
        Lever(icon: "clock.fill", color: .orange, title: "Start Date", detail: "Buy time for decompression, terminal leave, or a clean PCS."),
        Lever(icon: "graduationcap.fill", color: AppTheme.gold, title: "Learning & Certs", detail: "Tuition reimbursement, certification budget, conference travel."),
        Lever(icon: "arrow.up.circle.fill", color: .red, title: "Early Review", detail: "Lock in a 6-month performance review at a higher band.")
    ]

    // MARK: - Scripts

    private var scriptsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Scripts You Can Steal", icon: "text.bubble.fill", color: .purple)

            VStack(spacing: 12) {
                ForEach(scripts, id: \.title) { script in
                    scriptCard(script)
                }
            }
        }
    }

    private func scriptCard(_ script: Script) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: script.icon)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(script.color)
                Text(script.title)
                    .font(.subheadline.weight(.bold))
                Spacer()
                Text(script.tag)
                    .font(.caption2.weight(.heavy))
                    .foregroundStyle(script.color)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(script.color.opacity(0.12))
                    .clipShape(Capsule())
            }

            Text(script.body)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.primary.opacity(0.85))
                .fixedSize(horizontal: false, vertical: true)
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.tertiarySystemGroupedBackground))
                .clipShape(.rect(cornerRadius: 10))

            Button {
                UIPasteboard.general.string = script.body
                copiedScript = script.title
                Task {
                    try? await Task.sleep(for: .seconds(1.5))
                    if copiedScript == script.title { copiedScript = nil }
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: copiedScript == script.title ? "checkmark.circle.fill" : "doc.on.doc")
                    Text(copiedScript == script.title ? "Copied" : "Copy script")
                        .font(.caption.weight(.bold))
                }
                .foregroundStyle(copiedScript == script.title ? .green : AppTheme.forestGreen)
            }
            .buttonStyle(.plain)
            .sensoryFeedback(.success, trigger: copiedScript == script.title)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 12))
    }

    private let scripts: [Script] = [
        Script(
            icon: "envelope.fill", color: .blue, tag: "EMAIL", title: "Counter-offer email",
            body: "Hi [Name],\n\nThank you for the offer — I'm excited about the role and the team. Based on the scope of the position and my experience leading [team / project size] in similar high-stakes environments, I was hoping we could land closer to $[target base]. If base is constrained, I'm also open to discussing a sign-on bonus or an early performance review.\n\nHappy to talk through this on a quick call. Looking forward to moving forward.\n\nBest,\n[Your Name]"
        ),
        Script(
            icon: "phone.fill", color: AppTheme.forestGreen, tag: "VERBAL", title: "Anchor on the call",
            body: "Thanks so much for sharing the offer. Based on the scope of the role and what I'm bringing in terms of [leadership / clearance / technical depth], I was targeting $[target base]. Is there room to get there?\n\n[ Pause. Let them respond. Do not fill silence. ]"
        ),
        Script(
            icon: "questionmark.bubble.fill", color: .purple, tag: "EXPLORE", title: "When they ask your number first",
            body: "I'd love to understand the full picture before I anchor on a single number. Can you share the band for the role, and we can find the spot that works for both of us?"
        ),
        Script(
            icon: "checkmark.seal.fill", color: AppTheme.gold, tag: "CLOSE", title: "Accepting the final number",
            body: "That works for me. To confirm: base of $[X], $[sign-on], $[equity], [PTO weeks], start date of [date]. Please send the written offer and I'll sign today."
        )
    ]

    // MARK: - Objections

    private var objectionsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Handling Pushback", icon: "shield.lefthalf.filled", color: .orange)

            VStack(spacing: 10) {
                ForEach(objections, id: \.theirLine) { obj in
                    objectionRow(obj)
                }
            }
        }
    }

    private func objectionRow(_ obj: Objection) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "quote.opening")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.secondary)
                Text(obj.theirLine)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "arrow.turn.down.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(AppTheme.forestGreen)
                Text(obj.response)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary.opacity(0.85))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 10))
    }

    private let objections: [Objection] = [
        Objection(theirLine: "We don't really negotiate.",
                  response: "I understand. To make sure I'm not leaving anything on the table — is there flexibility on sign-on, start date, or an early review? Those matter just as much."),
        Objection(theirLine: "This is our best and final offer.",
                  response: "Thanks for being direct. Can you help me understand how you arrived at this number relative to the band for the role? I want to make sure we're aligned before I commit."),
        Objection(theirLine: "What's your current salary?",
                  response: "I'd rather focus on what this role is worth to your team. Based on the scope, I was targeting $[target]. Does that work?"),
        Objection(theirLine: "You don't have direct industry experience.",
                  response: "Fair point. What I do bring is [leading X people / managing $Y budget / operating under [pressure context]]. I'd ramp fast — what would the first 90 days need to look like for this to be a clear win?"),
        Objection(theirLine: "We need an answer today.",
                  response: "I appreciate the urgency and I'm leaning yes. I'd like 24 hours to review the written offer with my family. Can we plan to reconnect tomorrow at [time]?")
    ]

    // MARK: - Veteran angles

    private var veteranAnglesCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Your Unfair Advantage", icon: "star.fill", color: AppTheme.gold)

            VStack(alignment: .leading, spacing: 10) {
                angleRow("Active clearance", "If you hold a clearance, name it. A current TS/SCI alone can add $10–25K to base in cleared roles.", "lock.shield.fill")
                angleRow("Leadership at scale", "Translate: 'Led 28 personnel' → 'Managed a team of 28 with full P&L of $4M in equipment readiness.'", "person.3.fill")
                angleRow("Operating under pressure", "Deployment, 24/7 ops, no-fail missions. Few civilian candidates have this on their resume.", "bolt.fill")
                angleRow("Hire Heroes / VetJobs", "Veteran-focused recruiters and Skillbridge sponsors often surface roles with built-in negotiation room.", "flag.fill")
            }
            .padding(14)
            .background(AppTheme.gold.opacity(0.08))
            .clipShape(.rect(cornerRadius: 12))
        }
    }

    private func angleRow(_ title: String, _ detail: String, _ icon: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .font(.caption.weight(.bold))
                .foregroundStyle(AppTheme.gold)
                .padding(.top, 3)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.caption.weight(.heavy))
                Text(detail)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.primary.opacity(0.8))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    // MARK: - Checklist

    private var checklistCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Pre-Call Checklist", icon: "checklist", color: .blue)

            VStack(spacing: 0) {
                ForEach(Array(ChecklistKey.allCases.enumerated()), id: \.element) { idx, key in
                    Button {
                        if checklist.contains(key.id) { checklist.remove(key.id) } else { checklist.insert(key.id) }
                    } label: {
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: checklist.contains(key.id) ? "checkmark.circle.fill" : "circle")
                                .font(.title3)
                                .foregroundStyle(checklist.contains(key.id) ? AppTheme.forestGreen : .primary.opacity(0.3))
                            Text(key.text)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.primary.opacity(0.9))
                                .strikethrough(checklist.contains(key.id))
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(12)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .sensoryFeedback(.success, trigger: checklist.contains(key.id))

                    if idx < ChecklistKey.allCases.count - 1 {
                        Divider().padding(.leading, 48)
                    }
                }
            }
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 12))
        }
    }

    // MARK: - Helpers

    private func sectionHeader(_ title: String, icon: String, color: Color) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(color)
            Text(title)
                .font(.headline.weight(.bold))
        }
    }
}

// MARK: - Models

private struct Lever {
    let icon: String
    let color: Color
    let title: String
    let detail: String
}

private struct Script {
    let icon: String
    let color: Color
    let tag: String
    let title: String
    let body: String
}

private struct Objection {
    let theirLine: String
    let response: String
}

private enum ChecklistKey: String, CaseIterable, Identifiable {
    case knowNumber, researchedBand, levers, scriptRehearsed, batna, silence, written

    var id: String { rawValue }

    var text: String {
        switch self {
        case .knowNumber: return "I have my target, walk-away, and BATNA written down."
        case .researchedBand: return "I checked Levels.fyi, Glassdoor, and LinkedIn for the role's band in this metro."
        case .levers: return "I have a list of 3 non-base levers I'd accept if base won't move."
        case .scriptRehearsed: return "I've said my anchor sentence out loud at least 3 times."
        case .batna: return "I'm comfortable walking away if the offer is below my walk-away number."
        case .silence: return "I've practiced staying silent after I deliver my counter."
        case .written: return "I will not say yes until I see the offer in writing."
        }
    }
}
