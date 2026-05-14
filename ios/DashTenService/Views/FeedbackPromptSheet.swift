import SwiftUI
import StoreKit

struct FeedbackPromptSheet: View {
    let storage: StorageService
    @Environment(\.dismiss) private var dismiss
    @Environment(\.requestReview) private var requestReview
    @State private var step: Step = .ask

    enum Step {
        case ask
        case positive
        case negative
    }

    var body: some View {
        VStack(spacing: 24) {
            switch step {
            case .ask: askView
            case .positive: positiveView
            case .negative: negativeView
            }
        }
        .padding(24)
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
        .onAppear {
            storage.feedbackPromptShown = true
            storage.feedbackPromptLastShownAt = Date()
            storage.pendingFeedbackPrompt = false
            AnalyticsService.shared.log(.featureUsed, properties: ["name": "feedback_prompt_shown"])
        }
    }

    private var askView: some View {
        VStack(spacing: 18) {
            Image(systemName: "heart.text.square.fill")
                .font(.system(size: 48))
                .foregroundStyle(AppTheme.gold)
            Text("How's DashTen treating you?")
                .font(.title3.weight(.heavy))
                .multilineTextAlignment(.center)
            Text("Honest feedback helps us build for service members like you.")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            VStack(spacing: 10) {
                Button {
                    withAnimation(.spring) { step = .positive }
                } label: {
                    Label("Loving it", systemImage: "hand.thumbsup.fill")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 52)
                        .background(AppTheme.forestGreen)
                        .clipShape(.rect(cornerRadius: 14))
                }
                Button {
                    withAnimation(.spring) { step = .negative }
                } label: {
                    Label("Could be better", systemImage: "hand.thumbsdown")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(AppTheme.forestGreen)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 52)
                        .background(AppTheme.forestGreen.opacity(0.1))
                        .clipShape(.rect(cornerRadius: 14))
                }
                Button("Not now") { dismiss() }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .frame(minHeight: 44)
            }
        }
    }

    private var positiveView: some View {
        VStack(spacing: 18) {
            Image(systemName: "star.circle.fill")
                .font(.system(size: 56))
                .foregroundStyle(AppTheme.gold)
            Text("Mind leaving a quick review?")
                .font(.title3.weight(.heavy))
                .multilineTextAlignment(.center)
            Text("App Store reviews help more service members find DashTen.")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            VStack(spacing: 10) {
                Button {
                    requestReview()
                    AnalyticsService.shared.log(.featureUsed, properties: ["name": "review_requested"])
                    dismiss()
                } label: {
                    Text("Rate DashTen")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 52)
                        .background(AppTheme.forestGreen)
                        .clipShape(.rect(cornerRadius: 14))
                }
                Button("Maybe later") { dismiss() }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .frame(minHeight: 44)
            }
        }
    }

    private var negativeView: some View {
        VStack(spacing: 18) {
            Image(systemName: "envelope.fill")
                .font(.system(size: 48))
                .foregroundStyle(AppTheme.forestGreen)
            Text("Tell us what's missing")
                .font(.title3.weight(.heavy))
                .multilineTextAlignment(.center)
            Text("Use the App Store \"Report a Problem\" link or share feedback through the DashTen listing. We read every note.")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button("Got it") { dismiss() }
                .font(.headline.weight(.bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(minHeight: 52)
                .background(AppTheme.forestGreen)
                .clipShape(.rect(cornerRadius: 14))
        }
    }
}
