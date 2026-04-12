import Foundation

nonisolated struct GeminiMessage: Codable, Sendable {
    let role: String
    let parts: [GeminiPart]
}

nonisolated struct GeminiPart: Codable, Sendable {
    let text: String
}

nonisolated struct GeminiRequest: Codable, Sendable {
    let contents: [GeminiMessage]
    let systemInstruction: GeminiMessage?
    let generationConfig: GeminiGenerationConfig?
}

nonisolated struct GeminiGenerationConfig: Codable, Sendable {
    let temperature: Double?
    let maxOutputTokens: Int?
}

nonisolated struct GeminiResponse: Codable, Sendable {
    let candidates: [GeminiCandidate]?
}

nonisolated struct GeminiCandidate: Codable, Sendable {
    let content: GeminiCandidateContent?
}

nonisolated struct GeminiCandidateContent: Codable, Sendable {
    let parts: [GeminiPart]?
}

nonisolated enum GeminiServiceError: Error, Sendable {
    case invalidAPIKey
    case networkError(String)
    case decodingError
    case noResponse
}

@MainActor
class GeminiService {
    private let model = "gemini-2.0-flash"
    private let baseURL = "https://generativelanguage.googleapis.com/v1beta/models"

    func sendMessage(conversationHistory: [GeminiMessage], systemPrompt: String) async throws -> String {
        let apiKey = Config.EXPO_PUBLIC_GEMINI_API_KEY
        guard !apiKey.isEmpty else { throw GeminiServiceError.invalidAPIKey }

        let url = URL(string: "\(baseURL)/\(model):generateContent?key=\(apiKey)")!

        let request = GeminiRequest(
            contents: conversationHistory,
            systemInstruction: GeminiMessage(role: "user", parts: [GeminiPart(text: systemPrompt)]),
            generationConfig: GeminiGenerationConfig(temperature: 0.8, maxOutputTokens: 1024)
        )

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(request)

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            let errorText = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw GeminiServiceError.networkError(errorText)
        }

        let geminiResponse = try JSONDecoder().decode(GeminiResponse.self, from: data)

        guard let text = geminiResponse.candidates?.first?.content?.parts?.first?.text else {
            throw GeminiServiceError.noResponse
        }

        return text
    }
}
