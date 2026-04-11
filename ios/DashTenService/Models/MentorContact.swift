import Foundation

nonisolated struct MentorContact: Codable, Identifiable, Sendable {
    let id: String
    var name: String
    var role: String
    var industry: String
    var notes: String
    var dateAdded: Date
    var lastContactDate: Date?

    init(id: String = UUID().uuidString, name: String, role: String = "", industry: String = "", notes: String = "", dateAdded: Date = Date(), lastContactDate: Date? = nil) {
        self.id = id
        self.name = name
        self.role = role
        self.industry = industry
        self.notes = notes
        self.dateAdded = dateAdded
        self.lastContactDate = lastContactDate
    }
}
