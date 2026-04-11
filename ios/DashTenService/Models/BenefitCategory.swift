import Foundation

nonisolated struct BenefitCategory: Codable, Identifiable, Sendable {
    let id: String
    let type: BenefitCategoryType
    let overview: String
    let whyItMatters: String
    let eligibilityFactors: [String]
    let requiredDocuments: [String]
    let commonMistakes: [String]
    let questionsToAsk: [String]
    let officialLink: String
    var actionItems: [BenefitAction]
    var isStarted: Bool
    var isSaved: Bool
}

nonisolated struct BenefitAction: Codable, Identifiable, Sendable {
    let id: String
    var title: String
    var isCompleted: Bool

    init(id: String = UUID().uuidString, title: String, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
    }
}
