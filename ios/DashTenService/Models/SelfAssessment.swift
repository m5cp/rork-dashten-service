import Foundation

nonisolated struct AssessmentQuestion: Codable, Identifiable, Sendable {
    let id: String
    let question: String
    let category: ReadinessCategory
    let options: [AssessmentOption]
}

nonisolated struct AssessmentOption: Codable, Identifiable, Sendable {
    let id: String
    let label: String
    let score: Int
}

nonisolated struct AssessmentResult: Codable, Sendable {
    var answers: [String: String]
    var dateTaken: Date
    var categoryScores: [String: Int]

    init() {
        answers = [:]
        dateTaken = Date()
        categoryScores = [:]
    }
}
