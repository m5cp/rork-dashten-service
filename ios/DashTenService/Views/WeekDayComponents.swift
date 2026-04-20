import SwiftUI
import EventKit

nonisolated struct WeekDayWrapper: Identifiable, Hashable, Sendable {
    let date: Date
    var id: Date { date }
}

struct WeekDayTile: View {
    let date: Date
    let isToday: Bool
    let hasActivity: Bool
    let activityCount: Int
    let action: () -> Void

    private var weekdayLetter: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEEE"
        return formatter.string(from: date)
    }

    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }

    private var isFuture: Bool {
        Calendar.current.startOfDay(for: date) > Calendar.current.startOfDay(for: Date())
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Text(weekdayLetter)
                    .font(.system(size: 10, weight: .heavy))
                    .foregroundStyle(isToday ? AppTheme.forestGreen : .secondary)

                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(backgroundFill)
                        .frame(height: 44)
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(isToday ? AppTheme.forestGreen : .clear, lineWidth: 2)
                        .frame(height: 44)
                    VStack(spacing: 2) {
                        Text(dayNumber)
                            .font(.system(size: 15, weight: .bold, design: .rounded))
                            .foregroundStyle(foregroundColor)
                        if hasActivity {
                            Circle()
                                .fill(isToday ? Color.white : AppTheme.forestGreen)
                                .frame(width: 4, height: 4)
                        } else {
                            Spacer().frame(height: 4)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityText)
    }

    private var backgroundFill: Color {
        if isToday { return AppTheme.forestGreen }
        if hasActivity { return AppTheme.forestGreen.opacity(0.12) }
        if isFuture { return Color(.tertiarySystemGroupedBackground) }
        return Color(.tertiarySystemGroupedBackground)
    }

    private var foregroundColor: Color {
        if isToday { return .white }
        return .primary
    }

    private var accessibilityText: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        var s = formatter.string(from: date)
        if isToday { s += ", today" }
        if activityCount > 0 { s += ", \(activityCount) activities" }
        return s
    }
}

struct DayDetailSheet: View {
    let date: Date
    @Bindable var storage: StorageService
    @Environment(\.dismiss) private var dismiss
    @State private var events: [EKEvent] = []
    @State private var calendarAccess: CalendarService.AccessState = .notDetermined

    private var calendar: Calendar { Calendar.current }

    private var dayTitle: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: date)
    }

    private var journalEntries: [JournalEntry] {
        storage.journalEntries.filter { calendar.isDate($0.date, inSameDayAs: date) }
    }

    private var checkIns: [WeeklyCheckInEntry] {
        storage.weeklyCheckIns.filter { calendar.isDate($0.date, inSameDayAs: date) }
    }

    private var tasksDoneToday: [ChecklistItem] {
        guard calendar.isDateInToday(date) else { return [] }
        return storage.checklistItems.filter { $0.isCompleted }.prefix(10).map { $0 }
    }

    private var isFuture: Bool {
        calendar.startOfDay(for: date) > calendar.startOfDay(for: Date())
    }

    var body: some View {
        NavigationStack {
            List {
                if calendarAccess == .authorized {
                    Section("Calendar") {
                        if events.isEmpty {
                            Text("No events on this day")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(events, id: \.eventIdentifier) { event in
                                eventRow(event)
                            }
                        }
                    }
                } else if calendarAccess == .notDetermined {
                    Section {
                        Button {
                            Task {
                                _ = await CalendarService.shared.requestAccess()
                                calendarAccess = CalendarService.shared.accessState
                                events = CalendarService.shared.events(on: date)
                            }
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "calendar.badge.plus")
                                    .font(.title3)
                                    .foregroundStyle(AppTheme.forestGreen)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Connect your calendar")
                                        .font(.subheadline.weight(.bold))
                                        .foregroundStyle(.primary)
                                    Text("See your events alongside transition tasks")
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                            }
                        }
                    }
                }

                if !journalEntries.isEmpty {
                    Section("Journal") {
                        ForEach(journalEntries) { entry in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(entry.prompt)
                                    .font(.caption.weight(.bold))
                                    .foregroundStyle(AppTheme.forestGreen)
                                Text(entry.response.isEmpty ? "(empty)" : entry.response)
                                    .font(.subheadline)
                                    .foregroundStyle(.primary)
                                    .lineLimit(4)
                            }
                        }
                    }
                }

                if !checkIns.isEmpty {
                    Section("Check-in") {
                        ForEach(checkIns) { entry in
                            HStack {
                                Image(systemName: "chart.xyaxis.line")
                                    .foregroundStyle(AppTheme.forestGreen)
                                Text("Wellness check-in logged")
                                    .font(.subheadline.weight(.semibold))
                                Spacer()
                                Text(String(format: "%.1f/5", entry.averageScore))
                                    .font(.caption.weight(.bold))
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }

                if calendar.isDateInToday(date) && !tasksDoneToday.isEmpty {
                    Section("Tasks completed") {
                        ForEach(tasksDoneToday) { task in
                            HStack(spacing: 10) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(AppTheme.forestGreen)
                                Text(task.title)
                                    .font(.subheadline.weight(.semibold))
                                    .strikethrough()
                                Spacer()
                            }
                        }
                    }
                }

                if journalEntries.isEmpty && checkIns.isEmpty && events.isEmpty && tasksDoneToday.isEmpty {
                    Section {
                        VStack(spacing: 10) {
                            Image(systemName: isFuture ? "calendar.badge.clock" : "sparkles")
                                .font(.largeTitle)
                                .foregroundStyle(.secondary)
                            Text(isFuture ? "Nothing scheduled yet" : "No activity logged")
                                .font(.subheadline.weight(.bold))
                            Text(isFuture
                                ? "Add a journal entry or set up a wellness check-in to plan ahead."
                                : "Log a journal entry or complete a task to see it here.")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                    }
                }
            }
            .navigationTitle(dayTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(.body.weight(.bold))
                }
            }
            .onAppear {
                calendarAccess = CalendarService.shared.accessState
                events = CalendarService.shared.events(on: date)
            }
        }
    }

    private func eventRow(_ event: EKEvent) -> some View {
        HStack(alignment: .top, spacing: 10) {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color(event.calendar.cgColor))
                .frame(width: 4)
            VStack(alignment: .leading, spacing: 2) {
                Text(event.title ?? "(No title)")
                    .font(.subheadline.weight(.semibold))
                HStack(spacing: 6) {
                    if event.isAllDay {
                        Text("All day")
                    } else {
                        Text(event.startDate.formatted(date: .omitted, time: .shortened))
                        Text("–")
                        Text(event.endDate.formatted(date: .omitted, time: .shortened))
                    }
                    if let loc = event.location, !loc.isEmpty {
                        Text("· \(loc)").lineLimit(1)
                    }
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
