import Foundation

nonisolated struct JournalEntry: Codable, Identifiable, Sendable {
    let id: String
    let date: Date
    let prompt: String
    var response: String

    init(prompt: String, response: String = "") {
        self.id = UUID().uuidString
        self.date = Date()
        self.prompt = prompt
        self.response = response
    }
}

nonisolated struct GoalItem: Codable, Identifiable, Sendable {
    let id: String
    var title: String
    var deadline: Date
    var progress: Double
    var isCompleted: Bool
    let createdAt: Date

    init(title: String, deadline: Date) {
        self.id = UUID().uuidString
        self.title = title
        self.deadline = deadline
        self.progress = 0
        self.isCompleted = false
        self.createdAt = Date()
    }
}

nonisolated struct WeeklyCheckInEntry: Codable, Identifiable, Sendable {
    let id: String
    let date: Date
    var stressLevel: Int
    var jobSearchProgress: Int
    var financialConfidence: Int
    var socialConnection: Int
    var overallMood: Int

    init(stressLevel: Int, jobSearchProgress: Int, financialConfidence: Int, socialConnection: Int, overallMood: Int) {
        self.id = UUID().uuidString
        self.date = Date()
        self.stressLevel = stressLevel
        self.jobSearchProgress = jobSearchProgress
        self.financialConfidence = financialConfidence
        self.socialConnection = socialConnection
        self.overallMood = overallMood
    }

    var averageScore: Double {
        Double(stressLevel + jobSearchProgress + financialConfidence + socialConnection + overallMood) / 5.0
    }
}

nonisolated struct NetworkingWeek: Codable, Identifiable, Sendable {
    let id: String
    let weekStartDate: Date
    var newContacts: Int
    var followUpsSent: Int
    var informationalInterviews: Int

    init() {
        self.id = UUID().uuidString
        self.weekStartDate = Calendar.current.startOfDay(for: Date())
        self.newContacts = 0
        self.followUpsSent = 0
        self.informationalInterviews = 0
    }

    var totalActivity: Int {
        newContacts + followUpsSent + informationalInterviews
    }
}
