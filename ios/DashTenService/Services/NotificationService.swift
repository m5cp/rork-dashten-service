import UserNotifications
import Foundation

@MainActor
final class NotificationService {
    static let shared = NotificationService()

    private init() {}

    // MARK: - Permission

    func currentStatus() async -> UNAuthorizationStatus {
        await UNUserNotificationCenter.current().notificationSettings().authorizationStatus
    }

    func requestPermission() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .badge, .sound])
            AnalyticsService.shared.log(.featureUsed, properties: [
                "name": "notifications_permission",
                "granted": granted ? "true" : "false"
            ])
            return granted
        } catch {
            return false
        }
    }

    // MARK: - Daily smart reminder

    /// Daily reminder at a smart hour (default 9am local). Skips if user already active today.
    func scheduleDailyReminder(hour: Int = 9) {
        let id = "daily_reminder"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])

        let content = UNMutableNotificationContent()
        content.title = "Five minutes today"
        content.body = "One small move keeps your transition on track."
        content.sound = .default
        content.threadIdentifier = "dashten_daily"

        var components = DateComponents()
        components.hour = hour
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        UNUserNotificationCenter.current().add(
            UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        )
    }

    // MARK: - Streak protection

    /// Evening nudge at 7pm if user has not shown up today.
    func scheduleStreakProtection() {
        let id = "streak_protection"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])

        let content = UNMutableNotificationContent()
        content.title = "Your streak is on the line"
        content.body = "Open DashTen for 60 seconds to keep it alive."
        content.sound = .default
        content.threadIdentifier = "dashten_streak"

        var components = DateComponents()
        components.hour = 19
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        UNUserNotificationCenter.current().add(
            UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        )
    }

    // MARK: - Weekly summary

    func scheduleWeeklySummary() {
        let id = "weekly_summary"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])

        let content = UNMutableNotificationContent()
        content.title = "Your DashTen week in review"
        content.body = "See what you knocked out and what's next."
        content.sound = .default
        content.threadIdentifier = "dashten_weekly"

        var components = DateComponents()
        components.weekday = 1 // Sunday
        components.hour = 17
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        UNUserNotificationCenter.current().add(
            UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        )
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

    // MARK: - Milestone reached (local trigger)

    func sendMilestoneReached(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.threadIdentifier = "dashten_milestone"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        UNUserNotificationCenter.current().add(
            UNNotificationRequest(identifier: "milestone_\(UUID().uuidString)", content: content, trigger: trigger)
        )
    }

    // MARK: - Separation countdown

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

    /// Convenience to enable the full recurring suite at once.
    func enableAllRecurring() {
        scheduleDailyReminder()
        scheduleStreakProtection()
        scheduleWeeklySummary()
    }

    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
