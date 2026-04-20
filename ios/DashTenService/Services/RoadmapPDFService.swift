import UIKit
import PDFKit

enum RoadmapPDFService {
    static func generate(storage: StorageService) -> URL? {
        let pageWidth: CGFloat = 612
        let pageHeight: CGFloat = 792
        let margin: CGFloat = 48
        let contentWidth = pageWidth - margin * 2

        let format = UIGraphicsPDFRendererFormat()
        let metadata: [String: Any] = [
            kCGPDFContextCreator as String: "Dash Ten",
            kCGPDFContextAuthor as String: storage.profile.displayName.isEmpty ? "Service Member" : storage.profile.displayName,
            kCGPDFContextTitle as String: "Transition Roadmap"
        ]
        format.documentInfo = metadata

        let bounds = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        let renderer = UIGraphicsPDFRenderer(bounds: bounds, format: format)

        let url = FileManager.default.temporaryDirectory.appendingPathComponent("DashTen-Roadmap.pdf")

        do {
            try renderer.writePDF(to: url) { ctx in
                var context = PDFContext(ctx: ctx, pageWidth: pageWidth, pageHeight: pageHeight, margin: margin, contentWidth: contentWidth)

                // Cover
                context.beginPage()
                drawCover(storage: storage, context: &context)

                // Roadmap phases
                context.beginPage()
                context.drawH1("Your Roadmap")
                context.addSpace(8)

                for phase in TimelinePhase.allCases {
                    let items = storage.checklistItems.filter { $0.phase == phase }
                    guard !items.isEmpty else { continue }
                    context.ensureSpace(120)
                    drawPhase(phase: phase, items: items, context: &context)
                }

                // Planning areas
                context.ensureSpace(200)
                context.addSpace(16)
                context.drawH1("Planning Areas")
                context.addSpace(4)
                let readiness = ReadinessCalculator.calculate(
                    checklist: storage.checklistItems,
                    documents: storage.documents,
                    benefits: storage.benefitCategories
                )
                let areas: [(String, ReadinessCategory)] = [
                    ("Career", .employment), ("Education", .education),
                    ("Family", .family), ("Financial", .finance)
                ]
                for (name, cat) in areas {
                    let pct = Int((readiness.categories[cat] ?? 0) * 100)
                    context.drawBody("• \(name): \(pct)% complete")
                }

                // Documents
                context.ensureSpace(200)
                context.addSpace(16)
                context.drawH1("Documents")
                context.addSpace(4)
                for doc in storage.documents {
                    let mark = (doc.status == .verified || doc.status == .received) ? "✓" : "☐"
                    context.drawBody("\(mark) \(doc.name)")
                }
            }
            return url
        } catch {
            return nil
        }
    }

    private static func drawCover(storage: StorageService, context: inout PDFContext) {
        let name = storage.profile.displayName.isEmpty ? "Service Member" : storage.profile.displayName
        context.y = 180
        context.drawCentered("DASH TEN", font: .systemFont(ofSize: 14, weight: .heavy), color: UIColor(red: 0.176, green: 0.373, blue: 0.176, alpha: 1))
        context.addSpace(8)
        context.drawCentered("Transition Roadmap", font: .systemFont(ofSize: 32, weight: .bold), color: .label)
        context.addSpace(24)
        context.drawCentered("Prepared for \(name)", font: .systemFont(ofSize: 16, weight: .semibold), color: .secondaryLabel)
        context.addSpace(40)

        let readiness = ReadinessCalculator.calculate(
            checklist: storage.checklistItems,
            documents: storage.documents,
            benefits: storage.benefitCategories
        )
        let done = storage.checklistItems.filter(\.isCompleted).count
        let total = storage.checklistItems.count
        let docs = storage.documents.filter { $0.status == .verified || $0.status == .received }.count

        context.drawCentered("\(readiness.overallPercent)% Overall Readiness", font: .systemFont(ofSize: 22, weight: .bold), color: UIColor(red: 0.176, green: 0.373, blue: 0.176, alpha: 1))
        context.addSpace(16)
        context.drawCentered("\(done) of \(total) tasks complete  ·  \(docs) documents secured", font: .systemFont(ofSize: 13, weight: .medium), color: .secondaryLabel)
        context.addSpace(60)

        let formatter = DateFormatter()
        formatter.dateStyle = .long
        context.drawCentered("Generated \(formatter.string(from: Date()))", font: .systemFont(ofSize: 11, weight: .medium), color: .tertiaryLabel)
    }

    private static func drawPhase(phase: TimelinePhase, items: [ChecklistItem], context: inout PDFContext) {
        context.addSpace(12)
        let completed = items.filter(\.isCompleted).count
        context.drawH2("\(phase.rawValue)  —  \(completed)/\(items.count)")
        context.addSpace(4)

        for item in items {
            let mark = item.isCompleted ? "✓" : "☐"
            context.ensureSpace(80)
            context.drawBody("\(mark) \(item.title)", bold: true)
            if !item.subtitle.isEmpty {
                context.drawBody("    \(item.subtitle)", color: .secondaryLabel)
            }
            if let howTo = TaskHowToData.howTo(for: item.id) {
                for (idx, step) in howTo.steps.enumerated() {
                    context.drawBody("    \(idx + 1). \(step)", color: .darkGray, size: 10)
                }
                if let tip = howTo.tip {
                    context.drawBody("    Tip: \(tip)", color: .systemOrange, size: 10, italic: true)
                }
            }
            context.addSpace(4)
        }
    }
}

private struct PDFContext {
    let ctx: UIGraphicsPDFRendererContext
    let pageWidth: CGFloat
    let pageHeight: CGFloat
    let margin: CGFloat
    let contentWidth: CGFloat
    var y: CGFloat = 0

    mutating func beginPage() {
        ctx.beginPage()
        y = margin
    }

    mutating func ensureSpace(_ needed: CGFloat) {
        if y + needed > pageHeight - margin {
            beginPage()
        }
    }

    mutating func addSpace(_ px: CGFloat) {
        y += px
    }

    mutating func drawH1(_ text: String) {
        draw(text, font: .systemFont(ofSize: 22, weight: .bold), color: .label)
    }

    mutating func drawH2(_ text: String) {
        draw(text, font: .systemFont(ofSize: 16, weight: .bold), color: UIColor(red: 0.176, green: 0.373, blue: 0.176, alpha: 1))
    }

    mutating func drawBody(_ text: String, bold: Bool = false, color: UIColor = .label, size: CGFloat = 11, italic: Bool = false) {
        var font: UIFont = bold
            ? .systemFont(ofSize: size, weight: .semibold)
            : .systemFont(ofSize: size, weight: .regular)
        if italic, let desc = font.fontDescriptor.withSymbolicTraits(.traitItalic) {
            font = UIFont(descriptor: desc, size: size)
        }
        draw(text, font: font, color: color)
    }

    mutating func draw(_ text: String, font: UIFont, color: UIColor) {
        let attrs: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color]
        let attributed = NSAttributedString(string: text, attributes: attrs)
        let rect = CGRect(x: margin, y: y, width: contentWidth, height: .greatestFiniteMagnitude)
        let size = attributed.boundingRect(with: CGSize(width: contentWidth, height: .greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size
        if y + size.height > pageHeight - margin {
            beginPage()
        }
        attributed.draw(with: CGRect(x: margin, y: y, width: contentWidth, height: size.height), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        _ = rect
        y += ceil(size.height) + 2
    }

    mutating func drawCentered(_ text: String, font: UIFont, color: UIColor) {
        let para = NSMutableParagraphStyle()
        para.alignment = .center
        let attrs: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color, .paragraphStyle: para]
        let attributed = NSAttributedString(string: text, attributes: attrs)
        let size = attributed.boundingRect(with: CGSize(width: contentWidth, height: .greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size
        attributed.draw(with: CGRect(x: margin, y: y, width: contentWidth, height: size.height), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        y += ceil(size.height)
    }
}
