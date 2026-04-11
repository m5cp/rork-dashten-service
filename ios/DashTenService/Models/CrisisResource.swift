import Foundation

nonisolated struct CrisisResource: Identifiable, Sendable {
    let id: String
    let title: String
    let subtitle: String
    let phoneNumber: String?
    let textLine: String?
    let url: String?
    let icon: String
    let isEmergency: Bool

    init(id: String = UUID().uuidString, title: String, subtitle: String, phoneNumber: String? = nil, textLine: String? = nil, url: String? = nil, icon: String, isEmergency: Bool = false) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.phoneNumber = phoneNumber
        self.textLine = textLine
        self.url = url
        self.icon = icon
        self.isEmergency = isEmergency
    }
}
