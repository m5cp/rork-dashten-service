import SwiftUI

/// Full-screen celebration shown when a badge is unlocked.
/// Multiple unlocks queue and play sequentially.
struct BadgeCelebrationPresenter: View {
    @Bindable var storage: StorageService

    @State private var currentBadge: AchievementBadge?
    @State private var isAnimating: Bool = false

    var body: some View {
        ZStack {
            if let badge = currentBadge {
                BadgeCelebrationOverlay(
                    badge: badge,
                    isAnimating: $isAnimating,
                    onDismiss: { dismissCurrent() }
                )
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
                .zIndex(100)
            }
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.85), value: currentBadge?.id)
        .onChange(of: storage.pendingBadgeIds) { _, _ in
            advanceQueueIfNeeded()
        }
        .onAppear { advanceQueueIfNeeded() }
    }

    private func advanceQueueIfNeeded() {
        guard currentBadge == nil, let nextId = storage.pendingBadgeIds.first else { return }
        guard let badge = storage.badges.first(where: { $0.id == nextId }) else {
            // Unknown badge id — drop and try next
            storage.pendingBadgeIds.removeFirst()
            advanceQueueIfNeeded()
            return
        }
        currentBadge = badge
        // Small tap haptic before reveal, success haptic on reveal
        let tapper = UIImpactFeedbackGenerator(style: .light)
        tapper.impactOccurred()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            withAnimation(.spring(response: 0.55, dampingFraction: 0.65)) {
                isAnimating = true
            }
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
    }

    private func dismissCurrent() {
        withAnimation(.easeOut(duration: 0.25)) {
            isAnimating = false
        }
        if !storage.pendingBadgeIds.isEmpty {
            storage.pendingBadgeIds.removeFirst()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            currentBadge = nil
            advanceQueueIfNeeded()
        }
    }
}

private struct BadgeCelebrationOverlay: View {
    let badge: AchievementBadge
    @Binding var isAnimating: Bool
    let onDismiss: () -> Void

    @State private var confettiTrigger: Int = 0

    var body: some View {
        ZStack {
            // Backdrop
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture { onDismiss() }

            // Confetti behind card
            ConfettiView(trigger: confettiTrigger)
                .ignoresSafeArea()
                .allowsHitTesting(false)

            VStack(spacing: 22) {
                Text("BADGE UNLOCKED")
                    .font(.caption.weight(.heavy))
                    .tracking(2.4)
                    .foregroundStyle(AppTheme.gold)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : -8)

                ZStack {
                    Circle()
                        .fill(AppTheme.gold.opacity(0.18))
                        .frame(width: 160, height: 160)
                        .blur(radius: 20)

                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [AppTheme.gold, AppTheme.gold.opacity(0.7)],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                        .shadow(color: AppTheme.gold.opacity(0.5), radius: 24, y: 8)

                    Image(systemName: badge.icon)
                        .font(.system(size: 56, weight: .bold))
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.15), radius: 4, y: 2)
                }
                .scaleEffect(isAnimating ? 1.0 : 0.4)
                .rotationEffect(.degrees(isAnimating ? 0 : -20))

                VStack(spacing: 8) {
                    Text(badge.title)
                        .font(.title.weight(.heavy))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)

                    Text(badge.subtitle)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.85))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : 16)

                Button(action: onDismiss) {
                    Text("Continue")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(AppTheme.darkGreen)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 50)
                        .background(AppTheme.gold)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 32)
                .padding(.top, 6)
                .opacity(isAnimating ? 1 : 0)
            }
            .padding(.vertical, 36)
        }
        .onAppear {
            // Trigger a fresh confetti burst whenever a new badge appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                confettiTrigger += 1
            }
        }
    }
}

// MARK: - Confetti

private struct ConfettiPiece: Identifiable {
    let id = UUID()
    let color: Color
    let size: CGFloat
    let startX: CGFloat   // 0...1 fraction
    let endX: CGFloat     // 0...1 fraction
    let delay: Double
    let duration: Double
    let rotationSpeed: Double
    let shape: Int        // 0 = rect, 1 = circle, 2 = capsule
}

private struct ConfettiView: View {
    let trigger: Int
    @State private var pieces: [ConfettiPiece] = []

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(pieces) { piece in
                    ConfettiPieceView(piece: piece, size: geo.size)
                }
            }
        }
        .onChange(of: trigger) { _, _ in
            pieces = ConfettiView.generate(count: 80)
        }
        .onAppear {
            if pieces.isEmpty { pieces = ConfettiView.generate(count: 80) }
        }
    }

    private static func generate(count: Int) -> [ConfettiPiece] {
        let palette: [Color] = [
            AppTheme.gold,
            AppTheme.forestGreen,
            .orange,
            .pink,
            .cyan,
            .yellow,
            .white
        ]
        return (0..<count).map { _ in
            let startX = CGFloat.random(in: 0.35...0.65)
            let drift = CGFloat.random(in: -0.45...0.45)
            return ConfettiPiece(
                color: palette.randomElement() ?? AppTheme.gold,
                size: CGFloat.random(in: 6...12),
                startX: startX,
                endX: max(0, min(1, startX + drift)),
                delay: Double.random(in: 0...0.3),
                duration: Double.random(in: 1.6...2.6),
                rotationSpeed: Double.random(in: 1.5...4.0),
                shape: Int.random(in: 0...2)
            )
        }
    }
}

private struct ConfettiPieceView: View {
    let piece: ConfettiPiece
    let size: CGSize

    @State private var progress: CGFloat = 0
    @State private var rotation: Double = 0

    var body: some View {
        Group {
            switch piece.shape {
            case 1: Circle().fill(piece.color)
            case 2: Capsule().fill(piece.color)
            default: RoundedRectangle(cornerRadius: 1.5).fill(piece.color)
            }
        }
        .frame(width: piece.size, height: piece.size * (piece.shape == 2 ? 0.55 : 1.0))
        .rotationEffect(.degrees(rotation))
        .position(
            x: lerp(piece.startX, piece.endX, progress) * size.width,
            y: lerp(-0.05, 1.1, progress) * size.height
        )
        .opacity(progress < 0.9 ? 1 : Double(1 - (progress - 0.9) / 0.1))
        .onAppear {
            withAnimation(.easeIn(duration: piece.duration).delay(piece.delay)) {
                progress = 1
            }
            withAnimation(.linear(duration: piece.duration).delay(piece.delay).repeatCount(1, autoreverses: false)) {
                rotation = 360 * piece.rotationSpeed
            }
        }
    }

    private func lerp(_ a: CGFloat, _ b: CGFloat, _ t: CGFloat) -> CGFloat {
        a + (b - a) * t
    }
}
