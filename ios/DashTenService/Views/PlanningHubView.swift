import SwiftUI

struct PlanningHubView: View {
    let storage: StorageService

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                NavigationLink(value: PlanningRoute.career) {
                    PlanningCard(
                        title: "Career & Employment",
                        subtitle: "Resume, interviews, networking, job search",
                        icon: "briefcase.fill",
                        color: .teal
                    )
                }
                .buttonStyle(.plain)

                NavigationLink(value: PlanningRoute.education) {
                    PlanningCard(
                        title: "Education & Training",
                        subtitle: "Education benefits, certifications, degree planning",
                        icon: "graduationcap.fill",
                        color: .blue
                    )
                }
                .buttonStyle(.plain)

                NavigationLink(value: PlanningRoute.family) {
                    PlanningCard(
                        title: "Family & Relocation",
                        subtitle: "Move planning, spouse employment, schools",
                        icon: "figure.2.and.child.holdinghands",
                        color: .pink
                    )
                }
                .buttonStyle(.plain)

                NavigationLink(value: PlanningRoute.financial) {
                    PlanningCard(
                        title: "Financial Reset",
                        subtitle: "Budget, emergency fund, insurance, taxes",
                        icon: "dollarsign.circle.fill",
                        color: AppTheme.gold
                    )
                }
                .buttonStyle(.plain)

                NavigationLink(value: PlanningRoute.readiness) {
                    PlanningCard(
                        title: "Readiness Dashboard",
                        subtitle: "Your overall transition readiness score",
                        icon: "chart.bar.fill",
                        color: AppTheme.forestGreen
                    )
                }
                .buttonStyle(.plain)

                NavigationLink(value: PlanningRoute.firstThirtyDays) {
                    PlanningCard(
                        title: "First 30 Days Civilian",
                        subtitle: "Week-by-week survival guide",
                        icon: "flag.fill",
                        color: .purple
                    )
                }
                .buttonStyle(.plain)

                NavigationLink(value: PlanningRoute.mindsetShifts) {
                    PlanningCard(
                        title: "Mindset Shifts",
                        subtitle: "Navigate the mental side of transition",
                        icon: "brain.fill",
                        color: .purple
                    )
                }
                .buttonStyle(.plain)

                NavigationLink(value: PlanningRoute.civilianPlaybook) {
                    PlanningCard(
                        title: "Civilian Playbook",
                        subtitle: "Unwritten rules of civilian life",
                        icon: "book.closed.fill",
                        color: .blue
                    )
                }
                .buttonStyle(.plain)

                NavigationLink(value: PlanningRoute.selfAssessment) {
                    PlanningCard(
                        title: "Readiness Check-In",
                        subtitle: "Quick self-assessment across all categories",
                        icon: "checklist.checked",
                        color: .teal
                    )
                }
                .buttonStyle(.plain)

                NavigationLink(value: PlanningRoute.finalGearCheck) {
                    PlanningCard(
                        title: "Final Gear Check",
                        subtitle: "Pre-separation readiness review",
                        icon: "checkmark.shield.fill",
                        color: .orange
                    )
                }
                .buttonStyle(.plain)

                NavigationLink(value: PlanningRoute.mentorTracker) {
                    PlanningCard(
                        title: "Mentor Tracker",
                        subtitle: "Build your civilian network",
                        icon: "person.2.fill",
                        color: .pink
                    )
                }
                .buttonStyle(.plain)

                NavigationLink(value: PlanningRoute.crisis) {
                    PlanningCard(
                        title: "Crisis & Support Resources",
                        subtitle: "24/7 help lines and support",
                        icon: "heart.fill",
                        color: .red
                    )
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Color(.systemGroupedBackground))
    }
}

enum PlanningRoute: Hashable {
    case career
    case education
    case family
    case financial
    case readiness
    case crisis
    case firstThirtyDays
    case mindsetShifts
    case civilianPlaybook
    case selfAssessment
    case finalGearCheck
    case mentorTracker
    case documents
    case tspRollover
    case salaryNegotiation
    case costOfLiving
    case resumeTranslator
    case interviewPrep
    case networkingScorecard
    case skillsInventory
    case giBillBAH
    case educationComparison
    case relocationCost
    case stateBenefits
    case transitionJournal
    case goalTracker
    case weeklyCheckIn
    case elevatorPitch
    case jargonTranslator
    case jobOfferCompare
    case decisionMatrix
    case ninetyDayPlanner
    case weeklyChallenges
    case dailyPowerUp
    case networkingEventPrep
    case personalBrandAudit
    case benefitsCountdown
    case achievementBadges
    case firstYearGuide
}

struct PlanningCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.12))
                    .frame(width: 50, height: 50)
                Image(systemName: icon)
                    .font(.title3.weight(.bold))
                    .foregroundStyle(color)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline.weight(.bold))
                Text(subtitle)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary.opacity(0.7))
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(.primary.opacity(0.5))
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 14))
    }
}

// MARK: - Standardized Guide Section Component

struct GuideSection: View {
    let title: String
    let icon: String
    let color: Color
    let items: [String]
    var description: String? = nil
    @State private var isExpanded: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: icon)
                        .font(.body.weight(.bold))
                        .foregroundStyle(color)
                        .frame(width: 32, height: 32)
                        .background(color.opacity(0.12))
                        .clipShape(.rect(cornerRadius: 8))
                    Text(title)
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.primary)
                    Spacer()
                    Text("\(items.count)")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color(.tertiarySystemGroupedBackground))
                        .clipShape(Capsule())
                    Image(systemName: "chevron.down")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.secondary)
                        .rotationEffect(.degrees(isExpanded ? 0 : -90))
                }
                .padding(14)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(.rect(cornerRadius: 14))
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .sensoryFeedback(.selection, trigger: isExpanded)

            if isExpanded {
                VStack(alignment: .leading, spacing: 10) {
                    if let description {
                        Text(description)
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.secondary)
                    }

                    ForEach(items, id: \.self) { item in
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "circle.fill")
                                .font(.system(size: 5))
                                .foregroundStyle(color)
                                .padding(.top, 7)
                            Text(item)
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(.primary.opacity(0.85))
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 14)
                .padding(.bottom, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(.rect(cornerRadius: 14))
                .padding(.top, 6)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}

struct GuideIntroBanner: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.primary.opacity(0.85))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(color.opacity(0.06))
            .clipShape(.rect(cornerRadius: 14))
    }
}

struct GuideDisclaimer: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption.weight(.medium))
            .foregroundStyle(.tertiary)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding(.top, 8)
    }
}

// MARK: - Career Planning

struct CareerPlanningView: View {
    let storage: StorageService

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                GuideIntroBanner(
                    text: "Military experience is valuable — but the civilian job market works differently. Start early, get certified, and build your network.",
                    color: .orange
                )

                GuideSection(
                    title: "Resume Translation",
                    icon: "doc.text.fill",
                    color: .teal,
                    items: [
                        "Replace military jargon with civilian equivalents",
                        "Quantify achievements with numbers and percentages",
                        "Focus on leadership, management, and problem-solving",
                        "Use action verbs: led, managed, coordinated, developed",
                        "Tailor each resume to the specific job posting",
                        "Include certifications and security clearance level",
                    ],
                    description: "Translating military experience to civilian language is one of the most important steps."
                )

                GuideSection(
                    title: "Certifications & Licensing",
                    icon: "rosette",
                    color: .purple,
                    items: [
                        "Research which civilian certifications apply to your field",
                        "Many military skills require separate civilian certification",
                        "Check state-specific requirements — licensing varies by state",
                        "Look into employer-sponsored certification programs",
                        "Consider industry credentials (PMP, CompTIA, AWS, OSHA, etc.)",
                        "Use education benefits to cover certification costs",
                    ],
                    description: "Civilian employers often require specific certifications — even for roles you performed in the military."
                )

                GuideSection(
                    title: "Interview Prep",
                    icon: "person.fill.questionmark",
                    color: .blue,
                    items: [
                        "Research the company and role thoroughly",
                        "Prepare 3-5 stories using the STAR method",
                        "Practice explaining military experience in civilian terms",
                        "Prepare questions to ask the interviewer",
                        "Dress appropriately for the industry",
                        "Follow up with a thank-you email within 24 hours",
                    ]
                )

                GuideSection(
                    title: "Networking",
                    icon: "person.3.fill",
                    color: AppTheme.forestGreen,
                    items: [
                        "Update LinkedIn profile with civilian-friendly language",
                        "Connect with veteran employee resource groups",
                        "Attend at least one job fair or networking event monthly",
                        "Reach out to 3 new contacts per week",
                        "Join professional associations in your target field",
                        "Request informational interviews with industry professionals",
                    ],
                    description: "Most positions are filled through connections, not cold applications."
                )

                OfficialLinkButton(title: "O*NET Military Crosswalk Search", url: "https://www.onetonline.org/crosswalk/MOC/")
                OfficialLinkButton(title: "USAJobs.gov (Federal Jobs)", url: "https://www.usajobs.gov/")

                GuideDisclaimer(text: "Always verify employment programs and eligibility with official sources.")
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Career Planning")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Education Planning

struct EducationPlanningView: View {
    let storage: StorageService

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                GuideIntroBanner(
                    text: "Your education benefits are one of the most valuable parts of your service. Plan carefully to maximize them.",
                    color: .blue
                )

                GuideSection(
                    title: "Education Benefits",
                    icon: "graduationcap.fill",
                    color: .blue,
                    items: [
                        "Determine your education benefit eligibility and chapter",
                        "Request your Certificate of Eligibility (COE)",
                        "Research approved schools and programs",
                        "Compare monthly housing allowance by location",
                        "Understand the book and supply stipend",
                        "Consider transfer of benefits to dependents",
                        "Apply early — some programs have deadlines",
                    ]
                )

                GuideSection(
                    title: "Career Readiness Programs",
                    icon: "arrow.triangle.branch",
                    color: .purple,
                    items: [
                        "Check if you have a service-connected disability rating",
                        "Complete career readiness application (Form 28-1900)",
                        "Schedule initial counseling appointment",
                        "Prepare your career goals and interests",
                        "Career readiness programs can cover tuition, books, and supplies",
                        "Career programs may be available after education benefits are exhausted",
                    ]
                )

                GuideSection(
                    title: "Compare Paths",
                    icon: "arrow.triangle.swap",
                    color: .teal,
                    items: [
                        "College / University — 4-year degree, research focus, broad education",
                        "Trade / Certification — Focused skills, faster completion, high demand",
                        "Community College — 2-year programs, affordable, transfer options",
                        "Apprenticeship — Earn while you learn, hands-on training",
                        "Self-Employment — Start a business, use SBA resources",
                    ]
                )

                OfficialLinkButton(title: "Education Benefits Info", url: "https://www.benefits.gov/benefit/4769")

                GuideDisclaimer(text: "Verify all education benefit details with official sources before making enrollment decisions.")
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Education Planning")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Family Planning

struct FamilyPlanningView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                GuideIntroBanner(
                    text: "Transition affects the whole family. Plan your move, support your spouse's career, and get the kids settled.",
                    color: .pink
                )

                GuideSection(
                    title: "Civilian Move Checklist",
                    icon: "house.fill",
                    color: .pink,
                    items: [
                        "Research cost of living in target areas",
                        "Visit potential neighborhoods if possible",
                        "Create a moving budget and timeline",
                        "Arrange housing before your move date",
                        "Update address with USPS, banks, and subscriptions",
                        "Transfer medical records to new providers",
                        "Register vehicles in new state",
                        "Update voter registration",
                    ]
                )

                GuideSection(
                    title: "Spouse Employment",
                    icon: "person.fill",
                    color: .purple,
                    items: [
                        "Update spouse resume for civilian market",
                        "Research employment opportunities in target area",
                        "Explore remote work options",
                        "Connect with military spouse employment programs",
                        "Consider licensing or certification transfers between states",
                    ]
                )

                GuideSection(
                    title: "School & Childcare",
                    icon: "building.columns.fill",
                    color: .blue,
                    items: [
                        "Research school districts in target area",
                        "Request school records and transcripts",
                        "Identify childcare options and waitlists",
                        "Plan for school enrollment timelines",
                        "Look into after-school programs and activities",
                    ]
                )

                OfficialLinkButton(title: "USA.gov Moving Checklist", url: "https://www.usa.gov/moving")

                GuideDisclaimer(text: "Research state-specific requirements for licensing, registration, and enrollment in your target area.")
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Family & Relocation")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Financial Planning

nonisolated enum FinancialCalculator: String, CaseIterable, Identifiable, Sendable {
    case compensation = "Calculate current total compensation (base + BAH + BAS + special pay)"
    case estimateIncome = "Estimate post-service income realistically"
    case incomeGap = "Identify the income gap and plan for it"
    case civilianBudget = "Create a civilian budget based on new income"
    case reduceExpenses = "Reduce unnecessary expenses before separation"
    case emergencyFund = "Build an emergency fund of 3-6 months expenses"

    nonisolated var id: String { rawValue }

    var hasCalculator: Bool {
        switch self {
        case .compensation, .estimateIncome, .incomeGap, .civilianBudget, .emergencyFund:
            return true
        case .reduceExpenses:
            return false
        }
    }

    var icon: String {
        switch self {
        case .compensation: return "equal.circle.fill"
        case .estimateIncome: return "chart.line.uptrend.xyaxis"
        case .incomeGap: return "chart.line.downtrend.xyaxis"
        case .civilianBudget: return "creditcard.fill"
        case .reduceExpenses: return "scissors"
        case .emergencyFund: return "shield.lefthalf.filled"
        }
    }

    var iconColor: Color {
        switch self {
        case .compensation: return AppTheme.forestGreen
        case .estimateIncome: return .blue
        case .incomeGap: return .orange
        case .civilianBudget: return .purple
        case .reduceExpenses: return .pink
        case .emergencyFund: return .teal
        }
    }
}

struct FinancialPlanningView: View {
    @State private var activeCalculator: FinancialCalculator?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                GuideIntroBanner(
                    text: "This section provides general planning guidance. Consult a qualified financial professional for advice specific to your situation.",
                    color: .orange
                )

                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 10) {
                        Image(systemName: "dollarsign.circle.fill")
                            .font(.body.weight(.bold))
                            .foregroundStyle(AppTheme.gold)
                            .frame(width: 32, height: 32)
                            .background(AppTheme.gold.opacity(0.12))
                            .clipShape(.rect(cornerRadius: 8))
                        Text("Budget Reset")
                            .font(.headline.weight(.bold))
                    }

                    VStack(spacing: 6) {
                        ForEach(FinancialCalculator.allCases) { item in
                            if item.hasCalculator {
                                Button {
                                    activeCalculator = item
                                } label: {
                                    FinancialChecklistRow(
                                        text: item.rawValue,
                                        icon: item.icon,
                                        iconColor: item.iconColor,
                                        hasCalculator: true
                                    )
                                }
                                .buttonStyle(.plain)
                            } else {
                                FinancialChecklistRow(
                                    text: item.rawValue,
                                    icon: item.icon,
                                    iconColor: item.iconColor,
                                    hasCalculator: false
                                )
                            }
                        }
                    }
                    .padding(14)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(.rect(cornerRadius: 14))
                }

                GuideSection(
                    title: "Insurance Transition",
                    icon: "shield.fill",
                    color: .orange,
                    items: [
                        "Note SGLI expiration date (120 days after separation)",
                        "Apply for VGLI within 240 days for guaranteed coverage",
                        "Compare VGLI rates with private life insurance",
                        "Set up health insurance for the gap period",
                        "Review dental and vision coverage options",
                        "Update all beneficiary designations",
                    ]
                )

                GuideSection(
                    title: "Tax Reminders",
                    icon: "doc.text.fill",
                    color: AppTheme.gold,
                    items: [
                        "Understand which income is taxable after separation",
                        "Research state tax benefits for veterans",
                        "Know that disability compensation is tax-free",
                        "Keep copies of W-2s and tax returns",
                        "Consider TSP rollover options (IRA, 401k)",
                        "Consult a tax professional about your specific situation",
                    ]
                )

                OfficialLinkButton(title: "Consumer Financial Protection Bureau", url: "https://www.consumerfinance.gov/consumer-tools/educator-tools/servicemembers/")
                OfficialLinkButton(title: "TSP.gov (Thrift Savings Plan)", url: "https://www.tsp.gov/")

                GuideDisclaimer(text: "This is not financial advice. Consult qualified professionals for decisions about investments, taxes, and insurance.")
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Financial Reset")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $activeCalculator) { calc in
            switch calc {
            case .compensation, .estimateIncome:
                MilitaryCompCalculatorView()
            case .incomeGap:
                IncomeGapCalculatorView()
            case .civilianBudget:
                CivilianBudgetCalculatorView()
            case .emergencyFund:
                EmergencyFundCalculatorView()
            case .reduceExpenses:
                EmptyView()
            }
        }
    }
}

struct FinancialChecklistRow: View {
    let text: String
    let icon: String
    let iconColor: Color
    let hasCalculator: Bool

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Image(systemName: icon)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(iconColor)
                .frame(width: 28, height: 28)
                .background(iconColor.opacity(0.1))
                .clipShape(.rect(cornerRadius: 6))

            Text(text)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.primary.opacity(0.85))
                .multilineTextAlignment(.leading)

            Spacer()

            if hasCalculator {
                Image(systemName: "chevron.right")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(10)
        .contentShape(Rectangle())
        .background {
            if hasCalculator {
                RoundedRectangle(cornerRadius: 10)
                    .fill(iconColor.opacity(0.04))
            }
        }
    }
}

struct RealityCheckPoint: View {
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "arrow.forward.circle.fill")
                .font(.caption)
                .foregroundStyle(.orange)
                .padding(.top, 2)
            Text(text)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.primary.opacity(0.8))
        }
    }
}

// MARK: - First 30 Days

struct FirstThirtyDaysView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                GuideIntroBanner(
                    text: "Your first 30 days as a civilian are about stabilizing, not perfecting. Focus on the essentials and build from there.",
                    color: .purple
                )

                GuideSection(
                    title: "Week 1: Stabilize",
                    icon: "1.circle.fill",
                    color: .purple,
                    items: [
                        "Secure your DD214 copies and store safely",
                        "Set up a civilian bank account if needed",
                        "File for unemployment (if eligible in your state)",
                        "Update your address with all important contacts",
                        "Enroll in veteran health care if eligible",
                        "Take a breath — the first week is about stabilizing",
                    ]
                )

                GuideSection(
                    title: "Week 2: Activate",
                    icon: "2.circle.fill",
                    color: .blue,
                    items: [
                        "Begin applying for jobs or start your education enrollment",
                        "Set up your civilian health insurance if not yet covered",
                        "Create a 30/60/90-day personal plan",
                        "Connect with a local veteran organization",
                        "Review your budget based on actual civilian costs",
                    ]
                )

                GuideSection(
                    title: "Week 3: Build Momentum",
                    icon: "3.circle.fill",
                    color: .teal,
                    items: [
                        "Follow up on any pending claims or applications",
                        "Schedule medical appointments if needed",
                        "Continue networking — aim for 3 new contacts this week",
                        "Review and update your resume based on feedback",
                        "Start building a daily routine that supports your goals",
                    ]
                )

                GuideSection(
                    title: "Week 4: Assess & Adjust",
                    icon: "4.circle.fill",
                    color: AppTheme.forestGreen,
                    items: [
                        "Assess your first month — what's working, what's not",
                        "Adjust your budget based on real spending",
                        "Follow up on all outstanding paperwork",
                        "Plan your goals for month 2",
                        "Celebrate your first month — you've made it through the hardest part",
                    ]
                )

                GuideDisclaimer(text: "Everyone's transition is different. Adjust this guide to fit your situation.")
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("First 30 Days")
        .navigationBarTitleDisplayMode(.inline)
    }
}
