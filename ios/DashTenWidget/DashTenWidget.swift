import WidgetKit
import SwiftUI

nonisolated struct DashTenEntry: TimelineEntry {
    let date: Date
    let daysUntilSeparation: Int?
    let phaseLabel: String
    let focusTitle: String
    let readinessPercent: Int
    let branch: String
}

nonisolated struct DashTenSnapshot: Codable, Sendable {
    let daysUntilSeparation: Int?
    let phaseLabel: String
    let focusTitle: String
    let readinessPercent: Int
    let branch: String
}

nonisolated struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> DashTenEntry {
        DashTenEntry(date: .now, daysUntilSeparation: 180, phaseLabel: "6 mo", focusTitle: "Finalize post-service location", readinessPercent: 42, branch: "Army")
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
            return DashTenEntry(date: .now, daysUntilSeparation: nil, phaseLabel: "Set up", focusTitle: "Open DashTen to set your timeline", readinessPercent: 0, branch: "")
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
        if let checklist = json["checklist"] as? [[String: Any]] {
            total = checklist.count
            done = checklist.filter { ($0["isCompleted"] as? Bool) == true }.count
            if let first = checklist.first(where: { ($0["isCompleted"] as? Bool) != true }),
               let title = first["title"] as? String {
                focus = title
            }
        }
        let percent = total > 0 ? Int((Double(done) / Double(total)) * 100) : 0

        return DashTenEntry(
            date: .now,
            daysUntilSeparation: days,
            phaseLabel: phase,
            focusTitle: focus,
            readinessPercent: percent,
            branch: branch
        )
    }
}

struct DashTenWidgetView: View {
    var entry: DashTenEntry
    @Environment(\.widgetFamily) private var family

    private let forestGreen = Color(red: 0.176, green: 0.373, blue: 0.176)
    private let darkGreen = Color(red: 0.12, green: 0.24, blue: 0.13)
    private let gold = Color(red: 0.85, green: 0.65, blue: 0.20)

    var body: some View {
        switch family {
        case .systemSmall: smallView
        case .systemMedium: mediumView
        default: smallView
        }
    }

    private var daysText: String {
        guard let d = entry.daysUntilSeparation else { return "—" }
        if d < 0 { return "\(abs(d))" }
        return "\(d)"
    }

    private var daysLabel: String {
        guard let d = entry.daysUntilSeparation else { return "set up" }
        if d < 0 { return "days post" }
        if d == 1 { return "day to go" }
        return "days to go"
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
            Text(daysText)
                .font(.system(size: 42, weight: .heavy, design: .rounded))
                .foregroundStyle(.white)
                .minimumScaleFactor(0.5)
            Text(daysLabel)
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
                Text(daysText)
                    .font(.system(size: 48, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)
                    .minimumScaleFactor(0.5)
                Text(daysLabel)
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
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .containerBackground(for: .widget) {
            LinearGradient(colors: [forestGreen, darkGreen], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
}

struct DashTenWidget: Widget {
    let kind: String = "DashTenWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DashTenWidgetView(entry: entry)
        }
        .configurationDisplayName("Transition Countdown")
        .description("Days until separation, your phase, and today's focus.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
