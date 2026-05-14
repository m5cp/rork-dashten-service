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
    static let openAppWhenRun: Bool = false

    func perform() async throws -> some IntentResult & ProvidesDialog {
        let data = UserDefaults.standard.data(forKey: "dashten_data")
        var percent = 0
        var remaining = 0
        var daysToSeparation: Int? = nil
        if let data,
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            if let checklist = json["checklist"] as? [[String: Any]] {
                let total = checklist.count
                let done = checklist.filter { ($0["isCompleted"] as? Bool) == true }.count
                percent = total > 0 ? Int((Double(done) / Double(total)) * 100) : 0
                remaining = total - done
            }
            if let profile = json["profile"] as? [String: Any] {
                if let sep = profile["separationDate"] as? TimeInterval {
                    let date = Date(timeIntervalSinceReferenceDate: sep)
                    daysToSeparation = Calendar.current.dateComponents([.day], from: Date(), to: date).day
                }
            }
        }
        let dayPart = daysToSeparation.map { " with \($0) days to go" } ?? ""
        return .result(dialog: "You're \(percent) percent transition ready\(dayPart). \(remaining) tasks left on your checklist.")
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

struct LogDailyCheckInIntent: AppIntent {
    static let title: LocalizedStringResource = "Log today's check-in"
    static let description = IntentDescription("Mark you showed up today and protect your streak")
    static let openAppWhenRun: Bool = false

    func perform() async throws -> some IntentResult & ProvidesDialog {
        // Stamp a lightweight "checked in today" flag the app will reconcile on next launch.
        UserDefaults.standard.set(Date(), forKey: "dashten_pending_checkin")
        return .result(dialog: "Logged. Your DashTen streak is safe for today.")
    }
}

struct TrackContactIntent: AppIntent {
    static let title: LocalizedStringResource = "Track a new contact"
    static let description = IntentDescription("Open DashTen's networking hub to add a new contact")
    static let openAppWhenRun: Bool = true

    @Parameter(title: "Name", default: "")
    var name: String

    func perform() async throws -> some IntentResult {
        if !name.isEmpty {
            UserDefaults.standard.set(name, forKey: "dashten_pending_contact_name")
        }
        return .result()
    }
}

struct OpenTodaysMissionIntent: AppIntent {
    static let title: LocalizedStringResource = "Open today's mission"
    static let description = IntentDescription("Jump straight to today's focus mission")
    static let openAppWhenRun: Bool = true

    func perform() async throws -> some IntentResult {
        UserDefaults.standard.set(true, forKey: "dashten_pending_open_mission")
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
                "How ready am I in \(.applicationName)",
                "What's my \(.applicationName) score"
            ],
            shortTitle: "Check readiness",
            systemImageName: "gauge.with.dots.needle.50percent"
        )
        AppShortcut(
            intent: LogDailyCheckInIntent(),
            phrases: [
                "Log today's check-in in \(.applicationName)",
                "Protect my \(.applicationName) streak",
                "Check in on \(.applicationName)"
            ],
            shortTitle: "Daily check-in",
            systemImageName: "flame.fill"
        )
        AppShortcut(
            intent: OpenTodaysMissionIntent(),
            phrases: [
                "Open today's mission in \(.applicationName)",
                "Show today's focus in \(.applicationName)"
            ],
            shortTitle: "Today's mission",
            systemImageName: "scope"
        )
        AppShortcut(
            intent: TrackContactIntent(),
            phrases: [
                "Track a new contact in \(.applicationName)",
                "Add a contact to \(.applicationName)"
            ],
            shortTitle: "Track contact",
            systemImageName: "person.crop.circle.badge.plus"
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
