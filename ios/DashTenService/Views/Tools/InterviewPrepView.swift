import SwiftUI

struct InterviewPrepView: View {
    let storage: StorageService
    @State private var filterCategory: String = "All"
    @State private var expandedQuestionId: String? = nil

    private let questions: [InterviewQuestion] = [
        InterviewQuestion(id: "q1", question: "Tell me about yourself.", category: "General", tip: "Use the Present-Past-Future formula: What you do now → What you've done → What you want to do next. Keep it under 2 minutes. Focus on relevant experience, not your entire military career."),
        InterviewQuestion(id: "q2", question: "Why are you leaving your current position?", category: "General", tip: "Frame it positively: 'I completed my service commitment and I'm excited to apply my skills in [industry].' Never speak negatively about the military or chain of command."),
        InterviewQuestion(id: "q3", question: "Tell me about a time you led a team through a difficult situation.", category: "Leadership", tip: "STAR Method: Situation (brief context), Task (your responsibility), Action (what YOU did), Result (measurable outcome). Translate military scenarios — 'platoon' becomes 'team of 30 employees.'"),
        InterviewQuestion(id: "q4", question: "Describe a time you had to adapt to a major change.", category: "Adaptability", tip: "Military life IS constant change — use a deployment, PCS, or reorganization example. Show you embraced change, helped others through it, and delivered results despite uncertainty."),
        InterviewQuestion(id: "q5", question: "How do you handle conflict with a coworker?", category: "Teamwork", tip: "Show emotional intelligence: 'I address issues directly but respectfully.' Use an example where you resolved a disagreement professionally. Avoid examples involving rank or authority."),
        InterviewQuestion(id: "q6", question: "What's your greatest weakness?", category: "General", tip: "Pick a real but manageable weakness. Example: 'I sometimes expect civilian teams to operate at the same urgency as military units. I'm learning to set realistic timelines while maintaining high standards.'"),
        InterviewQuestion(id: "q7", question: "Tell me about a time you failed.", category: "Growth", tip: "Pick a real failure where you learned something valuable. Focus 80% on what you learned and how you improved. This shows self-awareness and growth mindset."),
        InterviewQuestion(id: "q8", question: "Where do you see yourself in 5 years?", category: "General", tip: "Show ambition aligned with the company: 'I want to grow into a senior role where I can lead projects and mentor team members.' Don't mention using this as a stepping stone."),
        InterviewQuestion(id: "q9", question: "Describe a project you managed from start to finish.", category: "Leadership", tip: "Use a military project but translate it: training exercise → 'multi-week project with 50 stakeholders.' Include planning, execution, budget/resource management, and measurable results."),
        InterviewQuestion(id: "q10", question: "How do you prioritize when everything is urgent?", category: "Problem Solving", tip: "Describe your system: 'I assess impact and deadline, communicate with stakeholders about realistic timelines, and delegate where possible.' Military personnel excel here — showcase it."),
        InterviewQuestion(id: "q11", question: "Why should we hire you?", category: "General", tip: "Connect your military strengths to their needs: leadership, accountability, working under pressure, attention to detail, team building. Be specific to the role — don't give a generic answer."),
        InterviewQuestion(id: "q12", question: "Tell me about a time you had to learn something quickly.", category: "Adaptability", tip: "Military is full of these — new equipment, new roles, new deployments. Show your learning process: how you gathered information, asked questions, practiced, and achieved competency fast."),
        InterviewQuestion(id: "q13", question: "How do you handle working with someone you disagree with?", category: "Teamwork", tip: "Show maturity: 'I focus on the mission/goal, not personal differences. I seek to understand their perspective first.' Use a real example — maybe a joint operation or cross-functional team."),
        InterviewQuestion(id: "q14", question: "Describe a time you improved a process or system.", category: "Problem Solving", tip: "Military members constantly improve processes. Describe what was broken, your analysis, the solution you implemented, and the measurable improvement. Quantify savings in time, money, or efficiency."),
        InterviewQuestion(id: "q15", question: "What questions do you have for us?", category: "General", tip: "Always have 3-5 prepared questions: team culture, growth opportunities, success metrics for the role, biggest challenges. Never ask about salary first. Show genuine interest in the company's mission."),
    ]

    private var categories: [String] {
        var cats: [String] = ["All"]
        let unique = Set(questions.map(\.category))
        cats.append(contentsOf: unique.sorted())
        return cats
    }

    private var filteredQuestions: [InterviewQuestion] {
        if filterCategory == "All" { return questions }
        return questions.filter { $0.category == filterCategory }
    }

    private var practicedCount: Int {
        questions.filter { storage.practicedQuestions.contains($0.id) }.count
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                progressHeader

                filterChips

                questionList
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Interview Prep")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var progressHeader: some View {
        HStack(spacing: 14) {
            ProgressRing(progress: Double(practicedCount) / Double(questions.count), size: 52, lineWidth: 5, color: .blue)
                .overlay {
                    Text("\(practicedCount)")
                        .font(.caption.bold())
                        .foregroundStyle(.blue)
                }

            VStack(alignment: .leading, spacing: 4) {
                Text("\(practicedCount) of \(questions.count) Practiced")
                    .font(.headline.weight(.bold))
                Text("Tap any question to reveal coaching tips")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary.opacity(0.7))
            }
            Spacer()
        }
        .padding(14)
        .background(.blue.opacity(0.06))
        .clipShape(.rect(cornerRadius: 14))
    }

    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(categories, id: \.self) { cat in
                    FilterChip(title: cat, isSelected: filterCategory == cat) {
                        withAnimation(.spring(response: 0.3)) { filterCategory = cat }
                    }
                }
            }
        }
        .contentMargins(.horizontal, 0)
    }

    private var questionList: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("All Questions")
                    .font(.headline.weight(.bold))
                Spacer()
                Text("Tap to reveal tip")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            ForEach(filteredQuestions, id: \.id) { q in
                questionRow(q)
            }
        }
    }

    @ViewBuilder
    private func questionRow(_ q: InterviewQuestion) -> some View {
        let isExpanded = expandedQuestionId == q.id
        let isPracticed = storage.practicedQuestions.contains(q.id)

        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    expandedQuestionId = isExpanded ? nil : q.id
                }
            } label: {
                HStack(spacing: 12) {
                    Button {
                        storage.togglePracticedQuestion(q.id)
                    } label: {
                        Image(systemName: isPracticed ? "checkmark.circle.fill" : "circle")
                            .font(.title3)
                            .foregroundStyle(isPracticed ? AppTheme.forestGreen : .primary.opacity(0.35))
                            .frame(width: 32, height: 32)
                    }
                    .buttonStyle(.plain)
                    .sensoryFeedback(.success, trigger: isPracticed)
                    .accessibilityLabel(isPracticed ? "Mark as not practiced" : "Mark as practiced")

                    VStack(alignment: .leading, spacing: 3) {
                        Text(q.question)
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(.primary)
                            .strikethrough(isPracticed)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                        Text(q.category)
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(.blue)
                    }
                    Spacer(minLength: 4)
                    Image(systemName: "chevron.down")
                        .font(.caption.weight(.heavy))
                        .foregroundStyle(.secondary)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 14)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if isExpanded {
                VStack(alignment: .leading, spacing: 10) {
                    Divider().opacity(0.4)
                    HStack(spacing: 6) {
                        Image(systemName: "lightbulb.fill")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(AppTheme.gold)
                        Text("Coaching Tip")
                            .font(.caption.weight(.heavy))
                            .foregroundStyle(AppTheme.gold)
                            .tracking(0.6)
                    }
                    Text(q.tip)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.primary.opacity(0.85))
                        .fixedSize(horizontal: false, vertical: true)

                    Button {
                        storage.togglePracticedQuestion(q.id)
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: isPracticed ? "checkmark.circle.fill" : "checkmark.circle")
                            Text(isPracticed ? "Practiced — tap to undo" : "Mark as practiced")
                        }
                        .font(.caption.weight(.bold))
                        .foregroundStyle(isPracticed ? AppTheme.forestGreen : .white)
                        .frame(maxWidth: .infinity, minHeight: 38)
                        .background(isPracticed ? AppTheme.forestGreen.opacity(0.12) : AppTheme.forestGreen)
                        .clipShape(.rect(cornerRadius: 10))
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 14)
                .padding(.bottom, 14)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 12))
    }
}

private nonisolated struct InterviewQuestion: Sendable {
    let id: String
    let question: String
    let category: String
    let tip: String
}
