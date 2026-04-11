import Foundation

enum ReadinessCalculator {
    struct ReadinessScore: Sendable {
        let overall: Double
        let categories: [ReadinessCategory: Double]

        var overallPercent: Int { Int(overall * 100) }

        func percent(for category: ReadinessCategory) -> Int {
            Int((categories[category] ?? 0) * 100)
        }
    }

    static func calculate(checklist: [ChecklistItem], documents: [DocumentItem], benefits: [BenefitCategory]) -> ReadinessScore {
        var categoryScores: [ReadinessCategory: Double] = [:]

        for category in ReadinessCategory.allCases {
            let items = checklist.filter { $0.readinessCategory == category }
            let checklistScore: Double = items.isEmpty ? 0 : Double(items.filter(\.isCompleted).count) / Double(items.count)

            let docScore: Double
            switch category {
            case .admin:
                let adminDocs = documents.filter { $0.category == .serviceRecords || $0.category == .evaluationsAwards || $0.category == .certificationsTranscripts }
                docScore = adminDocs.isEmpty ? 0 : Double(adminDocs.filter { $0.status == .received || $0.status == .verified }.count) / Double(adminDocs.count)
            case .health:
                let healthDocs = documents.filter { $0.category == .medicalRecords || $0.category == .benefitRecords }
                docScore = healthDocs.isEmpty ? 0 : Double(healthDocs.filter { $0.status == .received || $0.status == .verified }.count) / Double(healthDocs.count)
            case .employment:
                let empDocs = documents.filter { $0.category == .employmentDocs }
                docScore = empDocs.isEmpty ? 0 : Double(empDocs.filter { $0.status == .received || $0.status == .verified }.count) / Double(empDocs.count)
            case .family:
                let famDocs = documents.filter { $0.category == .dependentDocs }
                docScore = famDocs.isEmpty ? 0 : Double(famDocs.filter { $0.status == .received || $0.status == .verified }.count) / Double(famDocs.count)
            case .finance:
                let finDocs = documents.filter { $0.category == .financeTaxDocs }
                docScore = finDocs.isEmpty ? 0 : Double(finDocs.filter { $0.status == .received || $0.status == .verified }.count) / Double(finDocs.count)
            default:
                docScore = 0
            }

            let benefitScore: Double
            let relatedBenefits: [BenefitCategory]
            switch category {
            case .health:
                relatedBenefits = benefits.filter { $0.type == .healthCare || $0.type == .disabilityClaims }
            case .education:
                relatedBenefits = benefits.filter { $0.type == .educationTraining || $0.type == .careerReset }
            case .employment:
                relatedBenefits = benefits.filter { $0.type == .employmentResume }
            case .housing:
                relatedBenefits = benefits.filter { $0.type == .housingHomeLoan }
            case .finance:
                relatedBenefits = benefits.filter { $0.type == .financesBudget || $0.type == .insurance }
            case .family:
                relatedBenefits = benefits.filter { $0.type == .familyDependents }
            case .admin:
                relatedBenefits = benefits.filter { $0.type == .recordsAdmin }
            }

            let allActions = relatedBenefits.flatMap(\.actionItems)
            benefitScore = allActions.isEmpty ? 0 : Double(allActions.filter(\.isCompleted).count) / Double(allActions.count)

            let weight: Double = docScore > 0 ? 0.5 : 0.7
            let docWeight: Double = docScore > 0 ? 0.2 : 0
            let benefitWeight = 1.0 - weight - docWeight

            categoryScores[category] = checklistScore * weight + docScore * docWeight + benefitScore * benefitWeight
        }

        let overall = categoryScores.values.reduce(0, +) / Double(max(categoryScores.count, 1))
        return ReadinessScore(overall: overall, categories: categoryScores)
    }
}
