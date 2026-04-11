import Foundation

nonisolated struct InsightCard: Codable, Identifiable, Sendable {
    let id: String
    let title: String
    let body: String
    let category: InsightCardType

    init(id: String = UUID().uuidString, title: String, body: String, category: InsightCardType) {
        self.id = id
        self.title = title
        self.body = body
        self.category = category
    }
}

nonisolated enum InsightCardType: String, Codable, Sendable {
    case wishIKnew = "What I Wish I Knew"
    case commonMistake = "Common Mistakes"
    case forgottenDoc = "Documents People Forget"
    case benefitSpotlight = "Benefit Spotlight"
}
