import SwiftUI

// Shared ambient backdrop and liquid-glass card treatments used across all tabs
// to keep the look cohesive with the Home tab.

struct AmbientBackdrop: View {
    var body: some View {
        let hour = Calendar.current.component(.hour, from: Date())
        let palette: [Color]
        if hour < 6 {
            palette = [Color(red: 0.07, green: 0.10, blue: 0.16), Color(red: 0.05, green: 0.08, blue: 0.12)]
        } else if hour < 11 {
            palette = [Color(red: 0.94, green: 0.96, blue: 0.93), Color(red: 0.86, green: 0.92, blue: 0.88)]
        } else if hour < 17 {
            palette = [Color(red: 0.96, green: 0.97, blue: 0.95), Color(red: 0.88, green: 0.93, blue: 0.90)]
        } else if hour < 20 {
            palette = [Color(red: 0.98, green: 0.92, blue: 0.84), Color(red: 0.90, green: 0.84, blue: 0.78)]
        } else {
            palette = [Color(red: 0.10, green: 0.14, blue: 0.18), Color(red: 0.06, green: 0.09, blue: 0.12)]
        }
        return ZStack {
            LinearGradient(colors: palette, startPoint: .top, endPoint: .bottom)
            Circle()
                .fill(AppTheme.forestGreen.opacity(0.12))
                .frame(width: 320, height: 320)
                .blur(radius: 80)
                .offset(x: -120, y: -260)
            Circle()
                .fill(AppTheme.gold.opacity(0.10))
                .frame(width: 280, height: 280)
                .blur(radius: 80)
                .offset(x: 140, y: -140)
        }
    }
}

struct GlassCardBackground: View {
    var cornerRadius: CGFloat = 22

    var body: some View {
        if #available(iOS 26.0, *) {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .strokeBorder(
                            LinearGradient(
                                colors: [.white.opacity(0.4), .white.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: .black.opacity(0.06), radius: 14, y: 6)
        } else {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .strokeBorder(.white.opacity(0.25), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.06), radius: 14, y: 6)
        }
    }
}

extension View {
    /// Apply the calm liquid-glass card background used on the Home tab.
    func glassCard(cornerRadius: CGFloat = 22) -> some View {
        background(GlassCardBackground(cornerRadius: cornerRadius))
    }
}
