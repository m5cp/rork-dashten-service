import Foundation

@Observable
@MainActor
class AICoachViewModel {
    var messages: [ChatMessage] = []
    var isLoading: Bool = false
    var errorMessage: String?
    var inputText: String = ""

    private let geminiService = GeminiService()

    private var systemPrompt: String {
        """
        You are a supportive, knowledgeable AI Transition Coach for U.S. military service members \
        transitioning to civilian life. Your name is "Coach."

        Your expertise includes:
        - VA benefits enrollment and claims (disability, education, healthcare)
        - Resume translation from military to civilian language
        - Interview preparation and civilian workplace culture
        - GI Bill and education benefits (Post-9/11, VR&E, etc.)
        - TSP rollover and financial planning for transition
        - Housing assistance (VA home loans, relocation planning)
        - Mental health resources and adjustment support
        - Timeline-based transition planning (TAP/SFL-TAP milestones)
        - Family readiness and dependent benefits
        - Networking and career development strategies

        Guidelines:
        - Be warm, direct, and encouraging — like a senior NCO or mentor who genuinely cares
        - Use clear, actionable advice with specific next steps
        - Reference official resources (VA.gov, MilitaryOneSource, etc.) when relevant
        - Acknowledge the difficulty of transition — validate feelings without being patronizing
        - If someone expresses crisis or distress, immediately suggest the Veterans Crisis Line (988, press 1) or Crisis Text Line (text 838255)
        - Keep responses concise but thorough — aim for 2-4 paragraphs max
        - Never make up specific policy details — say "I'd recommend verifying at VA.gov" when unsure
        - Avoid excessive military jargon unless the user uses it first
        - You are NOT a replacement for professional legal, medical, or financial advice — remind users when appropriate
        """
    }

    func sendMessage(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let userMessage = ChatMessage(role: .user, content: trimmed)
        messages.append(userMessage)
        inputText = ""
        errorMessage = nil
        isLoading = true

        Task {
            do {
                let history = messages.map { msg in
                    GeminiMessage(
                        role: msg.role == .user ? "user" : "model",
                        parts: [GeminiPart(text: msg.content)]
                    )
                }

                let responseText = try await geminiService.sendMessage(
                    conversationHistory: history,
                    systemPrompt: systemPrompt
                )

                let assistantMessage = ChatMessage(role: .assistant, content: responseText)
                messages.append(assistantMessage)
            } catch GeminiServiceError.invalidAPIKey {
                errorMessage = "AI Coach is not configured yet. Please add your Gemini API key."
            } catch {
                errorMessage = "Couldn't reach Coach right now. Please try again."
            }
            isLoading = false
        }
    }

    func clearChat() {
        messages.removeAll()
        errorMessage = nil
    }
}
