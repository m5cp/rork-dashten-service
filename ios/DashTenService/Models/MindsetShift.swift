import Foundation

nonisolated struct MindsetShift: Codable, Identifiable, Sendable {
    let id: String
    let title: String
    let militaryMindset: String
    let civilianMindset: String
    let insight: String
    let category: MindsetCategory

    init(id: String = UUID().uuidString, title: String, militaryMindset: String, civilianMindset: String, insight: String, category: MindsetCategory) {
        self.id = id
        self.title = title
        self.militaryMindset = militaryMindset
        self.civilianMindset = civilianMindset
        self.insight = insight
        self.category = category
    }
}

nonisolated enum MindsetCategory: String, Codable, CaseIterable, Sendable {
    case identity = "Identity & Purpose"
    case culture = "Workplace Culture"
    case communication = "Communication"
    case dailyLife = "Daily Life"
    case relationships = "Relationships"
}
