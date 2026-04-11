import SwiftUI

struct SelfAssessmentView: View {
    let storage: StorageService
    @State private var currentIndex: Int = 0
    @State private var answers: [String: String] = [:]
    @State private var showResults: Bool = false
    @Environment(\.dismiss) private var dismiss

    private let questions = TransitionDataService.assessmentQuestions()

    private var currentQuestion: AssessmentQuestion? {
        guard currentIndex < questions.count else { return nil }
        return questions[currentIndex]
    }

    private var progress: Double {
        guard !questions.isEmpty else { return 0 }
        return Double(answers.count) / Double(questions.count)
    }

    var body: some View {
        if showResults {
            AssessmentResultsView(storage: storage, answers: answers, questions: questions)
        } else {
            VStack(spacing: 0) {
                ProgressView(value: progress)
                    .tint(AppTheme.forestGreen)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)

                HStack {
                    Text("Question \(currentIndex + 1) of \(questions.count)")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.primary.opacity(0.6))
                    Spacer()
                    if currentIndex > 0 {
                        Button("Back") {
                            withAnimation(.spring(response: 0.3)) {
                                currentIndex -= 1
                            }
                        }
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(AppTheme.forestGreen)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)

                Spacer()

                if let question = currentQuestion {
                    VStack(spacing: 28) {
                        VStack(spacing: 8) {
                            Image(systemName: question.category.icon)
                                .font(.title2)
                                .foregroundStyle(AppTheme.forestGreen)
                            Text(question.question)
                                .font(.title3.bold())
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, 24)

                        VStack(spacing: 10) {
                            ForEach(question.options) { option in
                                let isSelected = answers[question.id] == option.id
                                Button {
                                    withAnimation(.spring(response: 0.3)) {
                                        answers[question.id] = option.id
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                        withAnimation(.spring(response: 0.3)) {
                                            if currentIndex < questions.count - 1 {
                                                currentIndex += 1
                                            } else {
                                                showResults = true
                                            }
                                        }
                                    }
                                } label: {
                                    HStack(spacing: 12) {
                                        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                                            .font(.title3)
                                            .foregroundStyle(isSelected ? AppTheme.forestGreen : .primary.opacity(0.4))
                                        Text(option.label)
                                            .font(.subheadline.weight(.semibold))
                                            .foregroundStyle(.primary)
                                        Spacer()
                                    }
                                    .padding(16)
                                    .background(isSelected ? AppTheme.forestGreen.opacity(0.08) : Color(.secondarySystemGroupedBackground))
                                    .clipShape(.rect(cornerRadius: 12))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(isSelected ? AppTheme.forestGreen.opacity(0.3) : .clear, lineWidth: 1.5)
                                    )
                                }
                                .sensoryFeedback(.selection, trigger: isSelected)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
                    .id(currentIndex)
                }

                Spacer()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Readiness Check-In")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct AssessmentResultsView: View {
    let storage: StorageService
    let answers: [String: String]
    let questions: [AssessmentQuestion]
    @Environment(\.dismiss) private var dismiss

    private var categoryScores: [(ReadinessCategory, Int, Int)] {
        var scores: [ReadinessCategory: (earned: Int, possible: Int)] = [:]
        for question in questions {
            let maxScore = question.options.map(\.score).max() ?? 3
            let earnedScore: Int
            if let answerId = answers[question.id],
               let option = question.options.first(where: { $0.id == answerId }) {
                earnedScore = option.score
            } else {
                earnedScore = 0
            }
            let existing = scores[question.category] ?? (0, 0)
            scores[question.category] = (existing.earned + earnedScore, existing.possible + maxScore)
        }
        return ReadinessCategory.allCases.compactMap { cat in
            guard let score = scores[cat] else { return nil }
            return (cat, score.earned, score.possible)
        }
    }

    private var overallPercent: Int {
        let totalEarned = categoryScores.reduce(0) { $0 + $1.1 }
        let totalPossible = categoryScores.reduce(0) { $0 + $1.2 }
        guard totalPossible > 0 else { return 0 }
        return Int(Double(totalEarned) / Double(totalPossible) * 100)
    }

    private var readinessLevel: (String, String, Color) {
        if overallPercent >= 75 { return ("Strong Foundation", "You're well-prepared. Focus on the gaps below.", AppTheme.forestGreen) }
        if overallPercent >= 50 { return ("Building Momentum", "Good progress. Prioritize the weaker areas to level up.", .blue) }
        if overallPercent >= 25 { return ("Getting Started", "You're on the path. Use the roadmap to tackle the biggest gaps first.", .orange) }
        return ("Early Stage", "No worries — that's why you're here. Start with the area that feels most urgent.", .red)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    ProgressRing(progress: Double(overallPercent) / 100.0, size: 100, lineWidth: 10)
                        .overlay {
                            VStack(spacing: 0) {
                                Text("\(overallPercent)%")
                                    .font(.title2.bold())
                                    .foregroundStyle(readinessLevel.2)
                            }
                        }

                    Text(readinessLevel.0)
                        .font(.title3.bold())
                    Text(readinessLevel.1)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(.rect(cornerRadius: 16))

                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader("By Category", icon: "chart.bar.fill")

                    VStack(spacing: 8) {
                        ForEach(categoryScores, id: \.0) { category, earned, possible in
                            let pct = possible > 0 ? Int(Double(earned) / Double(possible) * 100) : 0
                            HStack(spacing: 12) {
                                Image(systemName: category.icon)
                                    .font(.body.weight(.semibold))
                                    .foregroundStyle(colorFor(pct))
                                    .frame(width: 28)
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text(category.rawValue)
                                            .font(.subheadline.weight(.bold))
                                        Spacer()
                                        Text("\(pct)%")
                                            .font(.subheadline.weight(.bold))
                                            .foregroundStyle(colorFor(pct))
                                    }
                                    ProgressView(value: Double(pct) / 100.0)
                                        .tint(colorFor(pct))
                                }
                            }
                            .padding(14)
                            .background(Color(.secondarySystemGroupedBackground))
                            .clipShape(.rect(cornerRadius: 12))
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 10) {
                    SectionHeader("What This Means", icon: "lightbulb.fill")
                    CardView {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("This check-in reflects your self-reported confidence — not an official assessment. Use it to identify blind spots and prioritize your planning.")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.primary.opacity(0.8))
                            Text("Retake this check-in anytime to track your progress over time.")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.primary.opacity(0.6))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                Button {
                    var result = AssessmentResult()
                    result.answers = answers
                    result.dateTaken = Date()
                    var catScores: [String: Int] = [:]
                    for (cat, earned, possible) in categoryScores {
                        catScores[cat.rawValue] = possible > 0 ? Int(Double(earned) / Double(possible) * 100) : 0
                    }
                    result.categoryScores = catScores
                    storage.saveAssessment(result)
                    dismiss()
                } label: {
                    Text("Save & Return")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(AppTheme.forestGreen)
                        .clipShape(.rect(cornerRadius: 14))
                }
                .sensoryFeedback(.success, trigger: true)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Your Results")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func colorFor(_ pct: Int) -> Color {
        if pct >= 75 { return AppTheme.forestGreen }
        if pct >= 50 { return .blue }
        if pct >= 25 { return .orange }
        return .red
    }
}
