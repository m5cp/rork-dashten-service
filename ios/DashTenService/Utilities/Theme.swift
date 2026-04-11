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
}
