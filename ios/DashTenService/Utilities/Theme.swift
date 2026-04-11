import SwiftUI

enum AppTheme {
    static let forestGreen = Color(red: 0.176, green: 0.373, blue: 0.176)
    static let gold = Color(red: 0.788, green: 0.659, blue: 0.298)
    static let darkGreen = Color(red: 0.102, green: 0.239, blue: 0.102)
    static let lightGold = Color(red: 0.918, green: 0.859, blue: 0.698)

    static let cardBackground = Color(.secondarySystemGroupedBackground)
    static let groupedBackground = Color(.systemGroupedBackground)

    static var accentGradient: LinearGradient {
        LinearGradient(
            colors: [forestGreen, darkGreen],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var goldGradient: LinearGradient {
        LinearGradient(
            colors: [gold, lightGold],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var heroMesh: MeshGradient {
        MeshGradient(
            width: 3, height: 3,
            points: [
                [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                [0.0, 0.5], [0.6, 0.4], [1.0, 0.5],
                [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
            ],
            colors: [
                darkGreen, forestGreen, darkGreen,
                forestGreen, forestGreen.opacity(0.8), darkGreen,
                darkGreen, forestGreen, darkGreen
            ]
        )
    }

    static var darkHeroMesh: MeshGradient {
        MeshGradient(
            width: 3, height: 3,
            points: [
                [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                [0.0, 0.5], [0.55, 0.45], [1.0, 0.5],
                [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
            ],
            colors: [
                Color(red: 0.05, green: 0.12, blue: 0.05),
                darkGreen,
                Color(red: 0.05, green: 0.12, blue: 0.05),
                darkGreen,
                gold.opacity(0.2),
                Color(red: 0.05, green: 0.12, blue: 0.05),
                Color(red: 0.05, green: 0.12, blue: 0.05),
                darkGreen,
                Color(red: 0.05, green: 0.12, blue: 0.05)
            ]
        )
    }

    static var urgentHeroMesh: MeshGradient {
        MeshGradient(
            width: 3, height: 3,
            points: [
                [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                [0.0, 0.5], [0.6, 0.4], [1.0, 0.5],
                [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
            ],
            colors: [
                Color(red: 0.3, green: 0.15, blue: 0.05),
                Color(red: 0.4, green: 0.2, blue: 0.05),
                Color(red: 0.3, green: 0.15, blue: 0.05),
                Color(red: 0.35, green: 0.18, blue: 0.05),
                gold.opacity(0.4),
                Color(red: 0.3, green: 0.15, blue: 0.05),
                Color(red: 0.3, green: 0.15, blue: 0.05),
                Color(red: 0.35, green: 0.18, blue: 0.05),
                Color(red: 0.3, green: 0.15, blue: 0.05)
            ]
        )
    }

    static func timeOfDayGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 { return "Good morning" }
        if hour < 17 { return "Good afternoon" }
        return "Good evening"
    }
}
