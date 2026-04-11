import UserNotifications
import Foundation

@MainActor
class NotificationService {
    static let shared = NotificationService()

    func requestPermission() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
            return granted
        } catch {
            return false
        }
    }

    func scheduleWeeklyReminder() {
        let content = UNMutableNotificationContent()
        content.title = "Weekly Transition Check-In"
        content.body = "Review your roadmap and stay on track with your transition plan."
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.weekday = 2
        dateComponents.hour = 9

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "weekly_checkin", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    func scheduleSeparationCountdown(separationDate: Date) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["sep_90", "sep_30", "sep_7"])

        let milestones: [(String, Int, String)] = [
            ("sep_90", 90, "90 days until separation. Time to finalize your plan."),
            ("sep_30", 30, "30 days until separation. Focus on last-minute essentials."),
            ("sep_7", 7, "1 week until separation. You've got this."),
        ]

        for (id, daysBefore, body) in milestones {
            guard let triggerDate = Calendar.current.date(byAdding: .day, value: -daysBefore, to: separationDate),
                  triggerDate > Date() else { continue }

            let content = UNMutableNotificationContent()
            content.title = "Separation Countdown"
            content.body = body
            content.sound = .default

            let components = Calendar.current.dateComponents([.year, .month, .day, .hour], from: triggerDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request)
        }
    }

    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
