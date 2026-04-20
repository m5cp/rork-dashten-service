import Foundation
import EventKit

@MainActor
@Observable
class CalendarService {
    static let shared = CalendarService()

    enum AccessState: Sendable {
        case notDetermined
        case authorized
        case denied
        case restricted
    }

    private let store = EKEventStore()
    var accessState: AccessState = .notDetermined

    init() {
        refreshAccessState()
    }

    func refreshAccessState() {
        switch EKEventStore.authorizationStatus(for: .event) {
        case .notDetermined: accessState = .notDetermined
        case .authorized, .fullAccess: accessState = .authorized
        case .writeOnly: accessState = .authorized
        case .denied: accessState = .denied
        case .restricted: accessState = .restricted
        @unknown default: accessState = .notDetermined
        }
    }

    func requestAccess() async -> Bool {
        do {
            if #available(iOS 17.0, *) {
                let granted = try await store.requestFullAccessToEvents()
                refreshAccessState()
                return granted
            } else {
                let granted = try await store.requestAccess(to: .event)
                refreshAccessState()
                return granted
            }
        } catch {
            refreshAccessState()
            return false
        }
    }

    func events(on date: Date) -> [EKEvent] {
        guard accessState == .authorized else { return [] }
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: date)
        guard let end = calendar.date(byAdding: .day, value: 1, to: start) else { return [] }
        let predicate = store.predicateForEvents(withStart: start, end: end, calendars: nil)
        return store.events(matching: predicate).sorted { $0.startDate < $1.startDate }
    }

    func eventsThisWeek() -> [Date: [EKEvent]] {
        guard accessState == .authorized else { return [:] }
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        guard let weekStart = startOfWeek(for: today),
              let weekEnd = calendar.date(byAdding: .day, value: 7, to: weekStart) else { return [:] }
        let predicate = store.predicateForEvents(withStart: weekStart, end: weekEnd, calendars: nil)
        let events = store.events(matching: predicate)
        var grouped: [Date: [EKEvent]] = [:]
        for event in events {
            let day = calendar.startOfDay(for: event.startDate)
            grouped[day, default: []].append(event)
        }
        return grouped
    }

    func startOfWeek(for date: Date) -> Date? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return calendar.date(from: components)
    }

    func weekDays() -> [Date] {
        let calendar = Calendar.current
        guard let start = startOfWeek(for: Date()) else { return [] }
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: start) }
    }
}
