import Foundation

nonisolated enum MilitaryBranch: String, Codable, CaseIterable, Identifiable, Sendable {
    case army = "Army"
    case navy = "Navy"
    case airForce = "Air Force"
    case marineCorps = "Marine Corps"
    case spaceForce = "Space Force"
    case coastGuard = "Coast Guard"
    case nationalGuard = "National Guard"
    case reserve = "Reserve"
    case spouseFamily = "Spouse / Family"
    case veteran = "Veteran"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .army: "shield.fill"
        case .navy: "water.waves"
        case .airForce: "airplane"
        case .marineCorps: "globe.americas.fill"
        case .spaceForce: "sparkles"
        case .coastGuard: "lifepreserver.fill"
        case .nationalGuard: "shield.lefthalf.filled"
        case .reserve: "shield.checkered"
        case .spouseFamily: "heart.fill"
        case .veteran: "star.fill"
        }
    }
}

nonisolated enum TransitionTimeline: String, Codable, CaseIterable, Identifiable, Sendable {
    case twentyFourPlus = "24+ months out"
    case twelveMonths = "12 months out"
    case sixMonths = "6 months out"
    case ninetyDays = "90 days out"
    case separated = "Separated / Retired"

    var id: String { rawValue }

    var shortLabel: String {
        switch self {
        case .twentyFourPlus: "24+ mo"
        case .twelveMonths: "12 mo"
        case .sixMonths: "6 mo"
        case .ninetyDays: "90 days"
        case .separated: "Post-service"
        }
    }

    var icon: String {
        switch self {
        case .twentyFourPlus: "calendar.badge.clock"
        case .twelveMonths: "calendar"
        case .sixMonths: "clock.fill"
        case .ninetyDays: "exclamationmark.clock.fill"
        case .separated: "checkmark.circle.fill"
        }
    }
}

nonisolated enum TransitionGoal: String, Codable, CaseIterable, Identifiable, Sendable {
    case employment = "Employment"
    case school = "School / Degree"
    case certification = "Trade / Certification"
    case entrepreneurship = "Entrepreneurship"
    case healthCareSetup = "Health Care Setup"
    case disabilityPrep = "Disability Claim Prep"
    case careerReadiness = "Career Readiness"
    case relocation = "Relocation"
    case familyReadiness = "Family Readiness"
    case financialReset = "Financial Reset"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .employment: "briefcase.fill"
        case .school: "graduationcap.fill"
        case .certification: "hammer.fill"
        case .entrepreneurship: "lightbulb.fill"
        case .healthCareSetup: "cross.case.fill"
        case .disabilityPrep: "doc.text.fill"
        case .careerReadiness: "arrow.triangle.branch"
        case .relocation: "house.fill"
        case .familyReadiness: "figure.2.and.child.holdinghands"
        case .financialReset: "dollarsign.circle.fill"
        }
    }
}

nonisolated enum DocumentStatus: String, Codable, CaseIterable, Identifiable, Sendable {
    case missing = "Missing"
    case requested = "Requested"
    case received = "Received"
    case verified = "Verified"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .missing: "xmark.circle.fill"
        case .requested: "clock.fill"
        case .received: "checkmark.circle"
        case .verified: "checkmark.seal.fill"
        }
    }

    var color: String {
        switch self {
        case .missing: "red"
        case .requested: "orange"
        case .received: "blue"
        case .verified: "green"
        }
    }
}

nonisolated enum DocumentCategory: String, Codable, CaseIterable, Identifiable, Sendable {
    case serviceRecords = "Service Records"
    case medicalRecords = "Medical Records"
    case evaluationsAwards = "Evaluations & Awards"
    case certificationsTranscripts = "Certifications & Transcripts"
    case benefitRecords = "Benefit-Related Records"
    case employmentDocs = "Employment Documents"
    case dependentDocs = "Dependent Documents"
    case financeTaxDocs = "Finance & Tax Documents"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .serviceRecords: "folder.fill"
        case .medicalRecords: "cross.case.fill"
        case .evaluationsAwards: "star.fill"
        case .certificationsTranscripts: "doc.text.fill"
        case .benefitRecords: "building.columns.fill"
        case .employmentDocs: "briefcase.fill"
        case .dependentDocs: "person.2.fill"
        case .financeTaxDocs: "dollarsign.circle.fill"
        }
    }
}

nonisolated enum ReadinessCategory: String, Codable, CaseIterable, Identifiable, Sendable {
    case admin = "Admin & Records"
    case health = "Health Care"
    case education = "Education"
    case employment = "Employment"
    case family = "Family"
    case finance = "Finance"
    case housing = "Housing"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .admin: "doc.text.fill"
        case .health: "heart.fill"
        case .education: "graduationcap.fill"
        case .employment: "briefcase.fill"
        case .family: "figure.2.and.child.holdinghands"
        case .finance: "dollarsign.circle.fill"
        case .housing: "house.fill"
        }
    }
}

nonisolated enum TimelinePhase: String, Codable, CaseIterable, Identifiable, Sendable {
    case eighteenToTwentyFour = "18–24 Months Out"
    case twelveMonths = "12 Months Out"
    case sixMonths = "6 Months Out"
    case ninetyDays = "90 Days Out"
    case thirtyDays = "30 Days Out"
    case firstNinety = "First 90 Days After"
    case firstYear = "First Year After"

    var id: String { rawValue }

    var monthsFromSeparation: Int {
        switch self {
        case .eighteenToTwentyFour: -24
        case .twelveMonths: -12
        case .sixMonths: -6
        case .ninetyDays: -3
        case .thirtyDays: -1
        case .firstNinety: 3
        case .firstYear: 12
        }
    }

    var icon: String {
        switch self {
        case .eighteenToTwentyFour: "calendar.badge.clock"
        case .twelveMonths: "calendar"
        case .sixMonths: "clock.fill"
        case .ninetyDays: "exclamationmark.clock.fill"
        case .thirtyDays: "alarm.fill"
        case .firstNinety: "flag.fill"
        case .firstYear: "star.circle.fill"
        }
    }

    var subtitle: String {
        switch self {
        case .eighteenToTwentyFour: "Start planning early"
        case .twelveMonths: "Build your foundation"
        case .sixMonths: "Lock in your plan"
        case .ninetyDays: "Final preparations"
        case .thirtyDays: "Last-minute essentials"
        case .firstNinety: "Your first steps as a civilian"
        case .firstYear: "Settle into your new life"
        }
    }
}

nonisolated enum BenefitCategoryType: String, Codable, CaseIterable, Identifiable, Sendable {
    case healthCare = "Health Care"
    case disabilityClaims = "Disability & Claims Prep"
    case educationTraining = "Education & Training"
    case careerReset = "Career Reset & Readiness"
    case employmentResume = "Employment & Resume"
    case housingHomeLoan = "Housing & Home Loan"
    case insurance = "Insurance"
    case familyDependents = "Family & Dependents"
    case financesBudget = "Finances & Budget"
    case recordsAdmin = "Records & Admin"
    case communityCrisis = "Community & Crisis"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .healthCare: "cross.case.fill"
        case .disabilityClaims: "doc.text.magnifyingglass"
        case .educationTraining: "graduationcap.fill"
        case .careerReset: "arrow.triangle.branch"
        case .employmentResume: "briefcase.fill"
        case .housingHomeLoan: "house.fill"
        case .insurance: "shield.fill"
        case .familyDependents: "figure.2.and.child.holdinghands"
        case .financesBudget: "dollarsign.circle.fill"
        case .recordsAdmin: "folder.fill"
        case .communityCrisis: "hands.sparkles.fill"
        }
    }

    var color: String {
        switch self {
        case .healthCare: "red"
        case .disabilityClaims: "orange"
        case .educationTraining: "blue"
        case .careerReset: "purple"
        case .employmentResume: "teal"
        case .housingHomeLoan: "green"
        case .insurance: "indigo"
        case .familyDependents: "pink"
        case .financesBudget: "yellow"
        case .recordsAdmin: "gray"
        case .communityCrisis: "red"
        }
    }
}

import SwiftUI

extension BenefitCategoryType {
    var accentColor: Color {
        switch self {
        case .healthCare: .red
        case .disabilityClaims: .orange
        case .educationTraining: .blue
        case .careerReset: .purple
        case .employmentResume: .teal
        case .housingHomeLoan: Color(red: 0.176, green: 0.373, blue: 0.176)
        case .insurance: .indigo
        case .familyDependents: .pink
        case .financesBudget: Color(red: 0.788, green: 0.659, blue: 0.298)
        case .recordsAdmin: .gray
        case .communityCrisis: .red
        }
    }
}

extension TimelinePhase {
    var shortLabel: String {
        switch self {
        case .eighteenToTwentyFour: "18-24 mo"
        case .twelveMonths: "12 mo"
        case .sixMonths: "6 mo"
        case .ninetyDays: "90 days"
        case .thirtyDays: "30 days"
        case .firstNinety: "Post 90"
        case .firstYear: "Year 1"
        }
    }
}
