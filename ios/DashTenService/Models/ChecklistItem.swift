import Foundation

nonisolated struct ChecklistItem: Codable, Identifiable, Sendable, Hashable {
    let id: String
    var title: String
    var subtitle: String
    var isCompleted: Bool
    var phase: TimelinePhase
    var readinessCategory: ReadinessCategory
    var isCustom: Bool

    init(id: String = UUID().uuidString, title: String, subtitle: String = "", isCompleted: Bool = false, phase: TimelinePhase, readinessCategory: ReadinessCategory, isCustom: Bool = false) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.isCompleted = isCompleted
        self.phase = phase
        self.readinessCategory = readinessCategory
        self.isCustom = isCustom
    }
}
