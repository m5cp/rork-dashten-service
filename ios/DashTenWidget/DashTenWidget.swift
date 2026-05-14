import WidgetKit
import SwiftUI

nonisolated struct DashTenEntry: TimelineEntry {
    let date: Date
    let daysUntilSeparation: Int?
    let phaseLabel: String
    let focusTitle: String
    let readinessPercent: Int
    let branch: String
    let currentStreak: Int
    let tasksRemaining: Int
}

nonisolated struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> DashTenEntry {
        DashTenEntry(
            date: .now,
            daysUntilSeparation: 180,
            phaseLabel: "6 mo",
            focusTitle: "Finalize post-service location",
            readinessPercent: 42,
            branch: "Army",
            currentStreak: 5,
            tasksRemaining: 8
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (DashTenEntry) -> Void) {
        completion(loadEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<DashTenEntry>) -> Void) {
        let entry = loadEntry()
        let next = Calendar.current.date(byAdding: .hour, value: 6, to: .now) ?? Date()
        completion(Timeline(entries: [entry], policy: .after(next)))
    }

    private func loadEntry() -> DashTenEntry {
        guard let data = UserDefaults.standard.data(forKey: "dashten_data"),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return DashTenEntry(
                date: .now,
                daysUntilSeparation: nil,
                phaseLabel: "Set up",
                focusTitle: "Open DashTen to set your timeline",
                readinessPercent: 0,
                branch: "",
                currentStreak: 0,
                tasksRemaining: 0
            )
        }

        var days: Int? = nil
        var phase = ""
        var branch = ""
        if let profile = json["profile"] as? [String: Any] {
            branch = profile["branch"] as? String ?? ""
            if let sep = profile["separationDate"] as? TimeInterval {
                let date = Date(timeIntervalSinceReferenceDate: sep)
                days = Calendar.current.dateComponents([.day], from: Date(), to: date).day
            } else if let sepStr = profile["separationDate"] as? String,
                      let d = ISO8601DateFormatter().date(from: sepStr) {
                days = Calendar.current.dateComponents([.day], from: Date(), to: d).day
            }
        }

        if let d = days {
            if d > 540 { phase = "18+ mo" }
            else if d > 365 { phase = "12 mo" }
            else if d > 180 { phase = "6 mo" }
            else if d > 90 { phase = "90 days" }
            else if d > 30 { phase = "30 days" }
            else if d > 0 { phase = "This week" }
            else { phase = "Post-service" }
        } else {
            phase = "Set up"
        }

        var focus = "All caught up"
        var total = 0
        var done = 0
        var remaining = 0
        if let checklist = json["checklist"] as? [[String: Any]] {
            total = checklist.count
            done = checklist.filter { ($0["isCompleted"] as? Bool) == true }.count
            remaining = total - done
            if let first = checklist.first(where: { ($0["isCompleted"] as? Bool) != true }),
               let title = first["title"] as? String {
                focus = title
            }
        }
        let percent = total > 0 ? Int((Double(done) / Double(total)) * 100) : 0
        let streak = (json["currentStreak"] as? Int) ?? 0

        return DashTenEntry(
            date: .now,
            daysUntilSeparation: days,
            phaseLabel: phase,
            focusTitle: focus,
            readinessPercent: percent,
            branch: branch,
            currentStreak: streak,
            tasksRemaining: remaining
        )
    }
}

private let forestGreen = Color(red: 0.176, green: 0.373, blue: 0.176)
private let darkGreen = Color(red: 0.12, green: 0.24, blue: 0.13)
private let gold = Color(red: 0.85, green: 0.65, blue: 0.20)

private nonisolated func daysText(_ entry: DashTenEntry) -> String {
    guard let d = entry.daysUntilSeparation else { return "—" }
    if d < 0 { return "\(abs(d))" }
    return "\(d)"
}

private nonisolated func daysLabel(_ entry: DashTenEntry) -> String {
    guard let d = entry.daysUntilSeparation else { return "set up" }
    if d < 0 { return "days post" }
    if d == 1 { return "day to go" }
    return "days to go"
}

struct DashTenWidgetView: View {
    var entry: DashTenEntry
    @Environment(\.widgetFamily) private var family

    var body: some View {
        switch family {
        case .systemSmall: smallView
        case .systemMedium: mediumView
        case .systemLarge: largeView
        case .accessoryCircular: circularView
        case .accessoryRectangular: rectangularView
        case .accessoryInline: inlineView
        default: smallView
        }
    }

    private var smallView: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 4) {
                Image(systemName: "arrow.up.forward.circle.fill")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(gold)
                Text("DashTen")
                    .font(.caption2.weight(.heavy))
                    .foregroundStyle(.white.opacity(0.85))
                Spacer()
                Text(entry.phaseLabel.uppercased())
                    .font(.system(size: 9, weight: .heavy))
                    .foregroundStyle(gold)
            }
            Spacer(minLength: 0)
            Text(daysText(entry))
                .font(.system(size: 42, weight: .heavy, design: .rounded))
                .foregroundStyle(.white)
                .minimumScaleFactor(0.5)
            Text(daysLabel(entry))
                .font(.caption2.weight(.bold))
                .foregroundStyle(.white.opacity(0.85))
            Spacer(minLength: 0)
            HStack(spacing: 4) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 10))
                    .foregroundStyle(gold)
                Text("\(entry.readinessPercent)% ready")
                    .font(.system(size: 10, weight: .heavy))
                    .foregroundStyle(.white.opacity(0.9))
            }
        }
        .widgetURL(URL(string: "dashten://today"))
        .containerBackground(for: .widget) {
            LinearGradient(colors: [forestGreen, darkGreen], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }

    private var mediumView: some View {
        HStack(alignment: .top, spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.up.forward.circle.fill")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(gold)
                    Text("DashTen")
                        .font(.caption2.weight(.heavy))
                        .foregroundStyle(.white.opacity(0.85))
                }
                Spacer(minLength: 0)
                Text(daysText(entry))
                    .font(.system(size: 48, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)
                    .minimumScaleFactor(0.5)
                Text(daysLabel(entry))
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white.opacity(0.85))
                Text(entry.phaseLabel.uppercased())
                    .font(.system(size: 10, weight: .heavy))
                    .foregroundStyle(gold)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 4) {
                    Image(systemName: "scope")
                        .font(.system(size: 10, weight: .heavy))
                        .foregroundStyle(gold)
                    Text("TODAY'S FOCUS")
                        .font(.system(size: 9, weight: .heavy))
                        .foregroundStyle(gold)
                }
                Text(entry.focusTitle)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white)
                    .lineLimit(4)
                Spacer(minLength: 0)
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 10))
                        .foregroundStyle(gold)
                    Text("\(entry.readinessPercent)% ready")
                        .font(.system(size: 10, weight: .heavy))
                        .foregroundStyle(.white.opacity(0.9))
                }
                if entry.currentStreak > 0 {
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 10))
                            .foregroundStyle(.orange)
                        Text("\(entry.currentStreak)-day streak")
                            .font(.system(size: 10, weight: .heavy))
                            .foregroundStyle(.white.opacity(0.9))
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .widgetURL(URL(string: "dashten://today"))
        .containerBackground(for: .widget) {
            LinearGradient(colors: [forestGreen, darkGreen], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }

    private var largeView: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 6) {
                Image(systemName: "arrow.up.forward.circle.fill")
                    .font(.callout.weight(.bold))
                    .foregroundStyle(gold)
                Text("DashTen")
                    .font(.caption.weight(.heavy))
                    .foregroundStyle(.white.opacity(0.9))
                Spacer()
                Text(entry.phaseLabel.uppercased())
                    .font(.system(size: 11, weight: .heavy))
                    .foregroundStyle(gold)
            }

            HStack(alignment: .firstTextBaseline, spacing: 10) {
                Text(daysText(entry))
                    .font(.system(size: 64, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)
                    .minimumScaleFactor(0.5)
                VStack(alignment: .leading, spacing: 2) {
                    Text(daysLabel(entry))
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.white.opacity(0.9))
                    if !entry.branch.isEmpty {
                        Text(entry.branch.uppercased())
                            .font(.caption2.weight(.heavy))
                            .foregroundStyle(gold)
                    }
                }
            }

            Divider().background(Color.white.opacity(0.2))

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 4) {
                    Image(systemName: "scope")
                        .font(.system(size: 11, weight: .heavy))
                        .foregroundStyle(gold)
                    Text("TODAY'S FOCUS")
                        .font(.system(size: 10, weight: .heavy))
                        .foregroundStyle(gold)
                }
                Text(entry.focusTitle)
                    .font(.callout.weight(.bold))
                    .foregroundStyle(.white)
                    .lineLimit(3)
            }

            Spacer(minLength: 0)

            HStack(spacing: 16) {
                statBlock(icon: "checkmark.circle.fill", color: gold, value: "\(entry.readinessPercent)%", label: "Ready")
                statBlock(icon: "flame.fill", color: .orange, value: "\(entry.currentStreak)", label: "Streak")
                statBlock(icon: "list.bullet.clipboard.fill", color: .white, value: "\(entry.tasksRemaining)", label: "To do")
            }
        }
        .widgetURL(URL(string: "dashten://today"))
        .containerBackground(for: .widget) {
            LinearGradient(colors: [forestGreen, darkGreen], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }

    private func statBlock(icon: String, color: Color, value: String, label: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 11, weight: .heavy))
                    .foregroundStyle(color)
                Text(value)
                    .font(.system(size: 16, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)
            }
            Text(label.uppercased())
                .font(.system(size: 9, weight: .heavy))
                .foregroundStyle(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: Lock Screen / accessory

    private var circularView: some View {
        ZStack {
            AccessoryWidgetBackground()
            VStack(spacing: 0) {
                Text(daysText(entry))
                    .font(.system(size: 18, weight: .heavy, design: .rounded))
                    .minimumScaleFactor(0.5)
                Text("days")
                    .font(.system(size: 8, weight: .heavy))
            }
        }
        .widgetURL(URL(string: "dashten://today"))
        .containerBackground(.fill.tertiary, for: .widget)
    }

    private var rectangularView: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 4) {
                Image(systemName: "arrow.up.forward.circle.fill")
                Text("DashTen")
                    .font(.caption2.weight(.heavy))
            }
            Text("\(daysText(entry)) \(daysLabel(entry))")
                .font(.headline.weight(.heavy))
                .minimumScaleFactor(0.5)
            if entry.currentStreak > 0 {
                Text("🔥 \(entry.currentStreak)-day streak")
                    .font(.caption2.weight(.semibold))
            } else {
                Text(entry.focusTitle)
                    .font(.caption2.weight(.semibold))
                    .lineLimit(1)
            }
        }
        .widgetURL(URL(string: "dashten://today"))
        .containerBackground(.fill.tertiary, for: .widget)
    }

    private var inlineView: some View {
        Text("DashTen · \(daysText(entry)) \(daysLabel(entry))")
            .widgetURL(URL(string: "dashten://today"))
            .containerBackground(.fill.tertiary, for: .widget)
    }
}

struct DashTenWidget: Widget {
    let kind: String = "DashTenWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DashTenWidgetView(entry: entry)
        }
        .configurationDisplayName("Transition Countdown")
        .description("Days until separation, today's focus, and your streak.")
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            .systemLarge,
            .accessoryCircular,
            .accessoryRectangular,
            .accessoryInline
        ])
    }
}
