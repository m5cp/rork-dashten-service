import Foundation
#if canImport(FoundationModels)
import FoundationModels
#endif

@Observable
final class AICoachService {
    var message: String = ""
    var isGenerating: Bool = false
    var usedAI: Bool = false

    func generate(storage: StorageService) async {
        isGenerating = true
        defer { isGenerating = false }

        let context = Self.buildContext(storage: storage)

        #if canImport(FoundationModels)
        if #available(iOS 26.0, *) {
            if case .available = SystemLanguageModel.default.availability {
                do {
                    let instructions = """
                    You are a warm, direct transition coach for a U.S. military service member using the Dash Ten app. \
                    Always speak to the user as "you" (second person). Keep replies to 2-3 short sentences, \
                    grounded in their actual progress. No bullet lists. No headings. Plain prose only. \
                    Tone: clear, calm, encouraging, practical.
                    """
                    let session = LanguageModelSession(instructions: instructions)
                    let prompt = "Here's where the user is right now:\n\n\(context)\n\nWrite a short, personal status note that tells them where they stand and the single most useful thing to focus on next."
                    let response = try await session.respond(to: prompt)
                    message = response.content.trimmingCharacters(in: .whitespacesAndNewlines)
                    usedAI = true
                    return
                } catch {
                    // fall through to rule-based
                }
            }
        }
        #endif

        message = Self.fallback(storage: storage)
        usedAI = false
    }

    private static func buildContext(storage: StorageService) -> String {
        let total = storage.checklistItems.count
        let done = storage.checklistItems.filter(\.isCompleted).count
        let docs = storage.documents.count
        let docsSecured = storage.documents.filter { $0.status == .verified || $0.status == .received }.count
        let benefitsStarted = storage.benefitCategories.filter(\.isStarted).count
        let name = storage.profile.displayName.isEmpty ? "the user" : storage.profile.displayName
        var lines: [String] = []
        lines.append("Name: \(name)")
        if let branch = storage.profile.branch { lines.append("Branch: \(branch.rawValue)") }
        if let sepDate = storage.profile.separationDate {
            let months = Calendar.current.dateComponents([.month], from: Date(), to: sepDate).month ?? 0
            if months >= 0 {
                lines.append("Time until separation: \(months) months")
            } else {
                lines.append("Time since separation: \(-months) months")
            }
        }
        lines.append("Tasks complete: \(done) of \(total)")
        lines.append("Documents secured: \(docsSecured) of \(docs)")
        lines.append("Benefits started: \(benefitsStarted)")
        return lines.joined(separator: "\n")
    }

    private static func fallback(storage: StorageService) -> String {
        let total = storage.checklistItems.count
        let done = storage.checklistItems.filter(\.isCompleted).count
        let pct = total > 0 ? Int(Double(done) / Double(total) * 100) : 0
        let docsMissing = storage.documents.filter { $0.status == .missing }.count

        var months: Int?
        if let sepDate = storage.profile.separationDate {
            months = Calendar.current.dateComponents([.month], from: Date(), to: sepDate).month
        }

        var opener: String
        if let m = months {
            if m > 12 { opener = "You're \(m) months out — plenty of runway to build a strong foundation." }
            else if m > 6 { opener = "You're \(m) months out — time to lock in your plan." }
            else if m > 3 { opener = "You're \(m) months out — the window is narrowing." }
            else if m > 0 { opener = "You're \(m) months out — final push mode." }
            else if m == 0 { opener = "You're right at separation — stay steady and stabilize." }
            else { opener = "You're \(-m) months post-service — focus on building momentum." }
        } else {
            opener = "You haven't set a separation date yet — adding it unlocks a clearer roadmap."
        }

        let focus: String
        if docsMissing > 3 {
            focus = "Your biggest leverage right now is documents — you have \(docsMissing) still needed."
        } else if pct < 25 {
            focus = "Start with one task today. Small wins compound fast."
        } else if pct < 60 {
            focus = "You're \(pct)% through your checklist. Keep the rhythm going."
        } else {
            focus = "You're ahead of most at \(pct)%. Time to shift toward career and network building."
        }

        return "\(opener) \(focus)"
    }
}
