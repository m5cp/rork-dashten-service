import Foundation

nonisolated struct DocumentItem: Codable, Identifiable, Sendable, Hashable {
    let id: String
    var name: String
    var category: DocumentCategory
    var status: DocumentStatus
    var notes: String
    var dateUpdated: Date

    init(id: String = UUID().uuidString, name: String, category: DocumentCategory, status: DocumentStatus = .missing, notes: String = "", dateUpdated: Date = Date()) {
        self.id = id
        self.name = name
        self.category = category
        self.status = status
        self.notes = notes
        self.dateUpdated = dateUpdated
    }
}
