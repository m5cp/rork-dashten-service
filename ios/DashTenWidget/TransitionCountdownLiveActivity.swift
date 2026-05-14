import ActivityKit
import WidgetKit
import SwiftUI

// Must mirror the main app's TransitionCountdownAttributes exactly.
nonisolated struct TransitionCountdownAttributes: ActivityAttributes, Sendable {
    public nonisolated struct ContentState: Codable, Hashable, Sendable {
        var daysRemaining: Int
        var phaseLabel: String
        var focusTitle: String
    }

    var branch: String
    var separationDate: Date
}

private let forestGreenLA = Color(red: 0.176, green: 0.373, blue: 0.176)
private let darkGreenLA = Color(red: 0.12, green: 0.24, blue: 0.13)
private let goldLA = Color(red: 0.85, green: 0.65, blue: 0.20)

struct TransitionCountdownLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TransitionCountdownAttributes.self) { context in
            // Lock Screen / Notification banner UI
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.up.forward.circle.fill")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(goldLA)
                        Text("DashTen")
                            .font(.caption2.weight(.heavy))
                            .foregroundStyle(.white.opacity(0.85))
                    }
                    Text("\(context.state.daysRemaining)")
                        .font(.system(size: 36, weight: .heavy, design: .rounded))
                        .foregroundStyle(.white)
                    Text("days to go")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.white.opacity(0.85))
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading, spacing: 4) {
                    Text(context.state.phaseLabel.uppercased())
                        .font(.system(size: 10, weight: .heavy))
                        .foregroundStyle(goldLA)
                    Text("TODAY'S FOCUS")
                        .font(.system(size: 9, weight: .heavy))
                        .foregroundStyle(goldLA)
                    Text(context.state.focusTitle)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.white)
                        .lineLimit(3)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(16)
            .activityBackgroundTint(darkGreenLA)
            .activitySystemActionForegroundColor(.white)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(context.state.daysRemaining)")
                            .font(.system(size: 28, weight: .heavy, design: .rounded))
                            .foregroundStyle(.white)
                        Text("days")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    .padding(.leading, 4)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(context.state.phaseLabel.uppercased())
                            .font(.system(size: 10, weight: .heavy))
                            .foregroundStyle(goldLA)
                        Text(context.attributes.branch.uppercased())
                            .font(.caption2.weight(.heavy))
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    .padding(.trailing, 4)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    HStack(spacing: 6) {
                        Image(systemName: "scope")
                            .font(.caption.weight(.heavy))
                            .foregroundStyle(goldLA)
                        Text(context.state.focusTitle)
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.white)
                            .lineLimit(2)
                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal, 4)
                }
            } compactLeading: {
                HStack(spacing: 2) {
                    Image(systemName: "arrow.up.forward.circle.fill")
                        .foregroundStyle(goldLA)
                    Text("\(context.state.daysRemaining)")
                        .font(.caption.weight(.heavy))
                        .foregroundStyle(.white)
                }
            } compactTrailing: {
                Text(context.state.phaseLabel)
                    .font(.caption2.weight(.heavy))
                    .foregroundStyle(goldLA)
                    .lineLimit(1)
            } minimal: {
                Text("\(context.state.daysRemaining)")
                    .font(.caption.weight(.heavy))
                    .foregroundStyle(goldLA)
            }
            .widgetURL(URL(string: "dashten://today"))
            .keylineTint(goldLA)
        }
    }
}
