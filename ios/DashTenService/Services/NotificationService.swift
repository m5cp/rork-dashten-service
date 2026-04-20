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
        let ids = ["sep_540", "sep_365", "sep_180", "sep_90", "sep_30", "sep_7", "sep_1"]
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)

        let milestones: [(String, Int, String, String)] = [
            ("sep_540", 540, "18 months out", "Foundation phase. Lock in the big decisions — where you'll live, what you'll do."),
            ("sep_365", 365, "1 year out", "Resume, health records, family alignment. Do the hard things now while you have time."),
            ("sep_180", 180, "6 months out", "Critical phase. Apply to schools, file claims, finalize housing."),
            ("sep_90", 90, "90 days out", "Time-sensitive. Confirm dates, final exams, move planning."),
            ("sep_30", 30, "30 days out", "Last-minute essentials. Checkout, DD214, civilian health coverage."),
            ("sep_7", 7, "1 week until separation", "You've got this. Final checklist review."),
            ("sep_1", 1, "Tomorrow is the day", "You've prepared for this. Welcome to what's next.")
        ]

        for (id, daysBefore, title, body) in milestones {
            guard let triggerDate = Calendar.current.date(byAdding: .day, value: -daysBefore, to: separationDate),
                  triggerDate > Date() else { continue }

            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = .default

            var components = Calendar.current.dateComponents([.year, .month, .day], from: triggerDate)
            components.hour = 9
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request)
        }
    }

    func scheduleMilestoneReminders(accountCreated: Date) {
        let ids = ["milestone_7", "milestone_30", "milestone_90"]
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)

        let milestones: [(String, Int, String, String)] = [
            ("milestone_7", 7, "One week in", "You've shown up for a full week. That's already more than most."),
            ("milestone_30", 30, "One month strong", "30 days of steady work on your future. Keep going."),
            ("milestone_90", 90, "90 days — you're in it", "Three months of consistent progress. Share the win.")
        ]

        for (id, days, title, body) in milestones {
            guard let triggerDate = Calendar.current.date(byAdding: .day, value: days, to: accountCreated),
                  triggerDate > Date() else { continue }
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = .default
            var components = Calendar.current.dateComponents([.year, .month, .day], from: triggerDate)
            components.hour = 10
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            UNUserNotificationCenter.current().add(UNNotificationRequest(identifier: id, content: content, trigger: trigger))
        }
    }

    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
