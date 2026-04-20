import AppIntents
import SwiftUI

struct OpenPlanIntent: AppIntent {
    static let title: LocalizedStringResource = "Open my plan"
    static let description = IntentDescription("Open your transition plan in DashTen")
    static let openAppWhenRun: Bool = true

    func perform() async throws -> some IntentResult {
        return .result()
    }
}

struct CheckReadinessIntent: AppIntent {
    static let title: LocalizedStringResource = "Check my readiness"
    static let description = IntentDescription("See how ready you are for transition")
    static let openAppWhenRun: Bool = true

    func perform() async throws -> some IntentResult & ProvidesDialog {
        let data = UserDefaults.standard.data(forKey: "dashten_data")
        var percent = 0
        if let data,
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let checklist = json["checklist"] as? [[String: Any]] {
            let total = checklist.count
            let done = checklist.filter { ($0["isCompleted"] as? Bool) == true }.count
            percent = total > 0 ? Int((Double(done) / Double(total)) * 100) : 0
        }
        return .result(dialog: "You're \(percent) percent transition ready.")
    }
}

struct LogTodayTaskIntent: AppIntent {
    static let title: LocalizedStringResource = "Log today's task"
    static let description = IntentDescription("Open DashTen to check off today's focus task")
    static let openAppWhenRun: Bool = true

    func perform() async throws -> some IntentResult {
        return .result()
    }
}

struct DashTenAppShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: OpenPlanIntent(),
            phrases: [
                "Open my plan in \(.applicationName)",
                "Show my transition plan in \(.applicationName)"
            ],
            shortTitle: "Open plan",
            systemImageName: "map.fill"
        )
        AppShortcut(
            intent: CheckReadinessIntent(),
            phrases: [
                "Check my readiness in \(.applicationName)",
                "How ready am I in \(.applicationName)"
            ],
            shortTitle: "Check readiness",
            systemImageName: "gauge.with.dots.needle.50percent"
        )
        AppShortcut(
            intent: LogTodayTaskIntent(),
            phrases: [
                "Log today's task in \(.applicationName)",
                "Check off a task in \(.applicationName)"
            ],
            shortTitle: "Log task",
            systemImageName: "checkmark.circle.fill"
        )
    }
}
