import Foundation

struct ChatMessage: Identifiable {
    let id: String
    let role: ChatRole
    let content: String
    let timestamp: Date

    init(id: String = UUID().uuidString, role: ChatRole, content: String, timestamp: Date = Date()) {
        self.id = id
        self.role = role
        self.content = content
        self.timestamp = timestamp
    }
}

nonisolated enum ChatRole: String, Sendable {
    case user
    case assistant
}

nonisolated enum QuickPrompt: String, CaseIterable, Identifiable, Sendable {
    case resume = "Help translate my military experience for a civilian resume"
    case benefits = "What VA benefits should I apply for first?"
    case interview = "How do I explain my military background in interviews?"
    case timeline = "What should I be doing right now in my transition?"
    case stress = "I'm feeling overwhelmed by the transition process"
    case housing = "Help me plan for housing after separation"

    var id: String { rawValue }

    var label: String {
        switch self {
        case .resume: "Resume Help"
        case .benefits: "VA Benefits"
        case .interview: "Interview Prep"
        case .timeline: "My Timeline"
        case .stress: "Feeling Overwhelmed"
        case .housing: "Housing Plan"
        }
    }

    var icon: String {
        switch self {
        case .resume: "doc.text.fill"
        case .benefits: "building.columns.fill"
        case .interview: "person.bubble.fill"
        case .timeline: "calendar.badge.clock"
        case .stress: "heart.fill"
        case .housing: "house.fill"
        }
    }
}
