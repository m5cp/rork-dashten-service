import SwiftUI

nonisolated struct AvatarPreset: Identifiable, Hashable, Sendable {
    let id: String
    let icon: String
    let colorName: String

    var color: Color {
        switch colorName {
        case "forestGreen": return AppTheme.forestGreen
        case "gold": return AppTheme.gold
        case "darkGreen": return AppTheme.darkGreen
        case "blue": return .blue
        case "orange": return .orange
        case "purple": return .purple
        case "teal": return .teal
        case "red": return .red
        default: return AppTheme.forestGreen
        }
    }

    nonisolated static let all: [AvatarPreset] = [
        AvatarPreset(id: "default", icon: "person.fill", colorName: "forestGreen"),
        AvatarPreset(id: "star", icon: "star.fill", colorName: "gold"),
        AvatarPreset(id: "shield", icon: "shield.fill", colorName: "darkGreen"),
        AvatarPreset(id: "flag", icon: "flag.fill", colorName: "red"),
        AvatarPreset(id: "compass", icon: "safari.fill", colorName: "blue"),
        AvatarPreset(id: "mountain", icon: "mountain.2.fill", colorName: "teal"),
        AvatarPreset(id: "bolt", icon: "bolt.fill", colorName: "orange"),
        AvatarPreset(id: "target", icon: "target", colorName: "purple"),
        AvatarPreset(id: "heart", icon: "heart.fill", colorName: "red"),
        AvatarPreset(id: "anchor", icon: "sailboat.fill", colorName: "blue"),
        AvatarPreset(id: "eagle", icon: "bird.fill", colorName: "darkGreen"),
        AvatarPreset(id: "medal", icon: "medal.fill", colorName: "gold")
    ]

    nonisolated static func preset(for id: String?) -> AvatarPreset {
        guard let id else { return all[0] }
        return all.first(where: { $0.id == id }) ?? all[0]
    }
}
