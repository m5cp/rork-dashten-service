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

struct CareerPlanningView: View {
    let storage: StorageService

    private let resumeTips = [
        "Replace military jargon with civilian equivalents",
        "Quantify achievements with numbers and percentages",
        "Focus on leadership, management, and problem-solving",
        "Use action verbs: led, managed, coordinated, developed",
        "Tailor each resume to the specific job posting",
        "Include certifications and security clearance level",
    ]

    private let interviewChecklist = [
        "Research the company and role thoroughly",
        "Prepare 3-5 stories using the STAR method",
        "Practice explaining military experience in civilian terms",
        "Prepare questions to ask the interviewer",
        "Dress appropriately for the industry",
        "Follow up with a thank-you email within 24 hours",
    ]

    private let networkingSteps = [
        "Update LinkedIn profile with civilian-friendly language",
        "Connect with veteran employee resource groups",
        "Attend at least one job fair or networking event monthly",
        "Reach out to 3 new contacts per week",
        "Join professional associations in your target field",
        "Request informational interviews with industry professionals",
    ]

    private let certificationSteps = [
        "Research which civilian certifications apply to your field",
        "Many military skills require separate civilian certification or licensing",
        "Check state-specific requirements — licensing varies by state",
        "Look into employer-sponsored certification programs",
        "Consider industry-recognized credentials (PMP, CompTIA, AWS, OSHA, etc.)",
        "Use education benefits to cover certification costs when possible",
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                realityCheckBanner

                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader("Resume Translation", icon: "doc.text.fill")
                    CardView {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Translating military experience to civilian language is one of the most important steps in your job search.")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.primary.opacity(0.8))
                            ForEach(resumeTips, id: \.self) { tip in
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.caption)
                                        .foregroundStyle(AppTheme.forestGreen)
                                        .padding(.top, 2)
                                    Text(tip)
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(.primary.opacity(0.8))
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader("Certifications & Licensing", icon: "rosette")
                    CardView {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Civilian employers often require specific certifications or licenses — even for roles you performed in the military. Don't assume your experience alone qualifies you.")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.primary.opacity(0.8))
                            ForEach(certificationSteps, id: \.self) { step in
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.caption)
                                        .foregroundStyle(.purple)
                                        .padding(.top, 2)
                                    Text(step)
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(.primary.opacity(0.8))
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader("Interview Prep", icon: "person.fill.questionmark")
                    CardView {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(interviewChecklist, id: \.self) { item in
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "circle")
                                        .font(.caption)
                                        .foregroundStyle(.primary.opacity(0.5))
                                        .padding(.top, 2)
                                    Text(item)
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(.primary.opacity(0.8))
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader("Networking", icon: "person.3.fill")
                    CardView {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Networking is often the single most effective way to land a civilian job. Most positions are filled through connections, not cold applications.")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.primary.opacity(0.8))
                            ForEach(networkingSteps, id: \.self) { step in
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "arrow.right.circle.fill")
                                        .font(.caption)
                                        .foregroundStyle(.teal)
                                        .padding(.top, 2)
                                    Text(step)
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(.primary.opacity(0.8))
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader("Education & Continuous Learning", icon: "book.fill")
                    CardView {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Many civilian careers require degrees or continuing education that military training alone may not satisfy. Investing in education — whether a degree, certificate, or trade program — can significantly improve your competitiveness.")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.primary.opacity(0.8))
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "lightbulb.fill")
                                    .font(.caption)
                                    .foregroundStyle(.blue)
                                    .padding(.top, 2)
                                Text("Use your education benefits strategically — align your program with your target career field.")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.primary.opacity(0.8))
                            }
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "lightbulb.fill")
                                    .font(.caption)
                                    .foregroundStyle(.blue)
                                    .padding(.top, 2)
                                Text("Research which employers in your target industry value specific degrees or certifications.")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.primary.opacity(0.8))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                OfficialLinkButton(title: "O*NET Military Crosswalk Search", url: "https://www.onetonline.org/crosswalk/MOC/")
                OfficialLinkButton(title: "USAJobs.gov (Federal Jobs)", url: "https://www.usajobs.gov/")

                Text("Always verify employment programs and eligibility with official sources.")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary.opacity(0.6))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Career Planning")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var realityCheckBanner: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.title3)
                    .foregroundStyle(.orange)
                Text("Set Realistic Expectations")
                    .font(.headline.weight(.bold))
            }

            Text("Military experience is valuable — but don't assume it will automatically translate to an equivalent or higher-level civilian position.")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary.opacity(0.8))

            Text("The civilian job market operates differently. Employers may not understand your military role, and many industries require specific civilian certifications, degrees, or licenses — even for work you've already done in uniform.")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary.opacity(0.8))

            VStack(alignment: .leading, spacing: 8) {
                RealityCheckPoint(text: "Certifications matter — many military skills need civilian equivalents to be recognized")
                RealityCheckPoint(text: "Networking is critical — who you know often matters more than what you've done")
                RealityCheckPoint(text: "Education fills gaps — degrees and credentials open doors that experience alone may not")
                RealityCheckPoint(text: "Start early — building credentials and connections takes time")
                RealityCheckPoint(text: "Be open to entry-level roles as a bridge to your target position")
            }
        }
        .padding(16)
        .background(.orange.opacity(0.06))
        .clipShape(.rect(cornerRadius: 14))
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

struct EducationPlanningView: View {
    let storage: StorageService

    private let educationBenefitChecklist = [
        "Determine your education benefit eligibility and chapter",
        "Request your Certificate of Eligibility (COE)",
        "Research approved schools and programs",
        "Compare monthly housing allowance by location",
        "Understand the book and supply stipend",
        "Consider transfer of benefits to dependents",
        "Apply early — some programs have deadlines",
    ]

    private let careerReadinessChecklist = [
        "Check if you have a service-connected disability rating",
        "Complete career readiness application (Form 28-1900)",
        "Schedule initial counseling appointment",
        "Prepare your career goals and interests",
        "Understand career readiness programs can cover tuition, books, and supplies",
        "Know that career programs may be available after education benefits are exhausted",
    ]

    private let pathComparison: [(String, String, String)] = [
        ("College / University", "graduationcap.fill", "4-year degree, research focus, broad education"),
        ("Trade / Certification", "hammer.fill", "Focused skills, faster completion, high demand"),
        ("Community College", "book.fill", "2-year programs, affordable, transfer options"),
        ("Apprenticeship", "wrench.and.screwdriver.fill", "Earn while you learn, hands-on training"),
        ("Self-Employment", "lightbulb.fill", "Start a business, use SBA resources"),
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader("Education Benefit Planning", icon: "graduationcap.fill")
                    CardView {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(educationBenefitChecklist, id: \.self) { item in
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "circle")
                                        .font(.caption)
                                        .foregroundStyle(.primary.opacity(0.5))
                                        .padding(.top, 2)
                                    Text(item)
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(.primary.opacity(0.8))
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader("Career Readiness Programs", icon: "arrow.triangle.branch")
                    CardView {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(careerReadinessChecklist, id: \.self) { item in
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "circle")
                                        .font(.caption)
                                        .foregroundStyle(.primary.opacity(0.5))
                                        .padding(.top, 2)
                                    Text(item)
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(.primary.opacity(0.8))
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader("Compare Paths", icon: "arrow.triangle.swap")
                    VStack(spacing: 8) {
                        ForEach(pathComparison, id: \.0) { title, icon, desc in
                            HStack(spacing: 12) {
                                Image(systemName: icon)
                                    .font(.body.weight(.semibold))
                                    .foregroundStyle(.blue)
                                    .frame(width: 28)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(title)
                                        .font(.subheadline.weight(.bold))
                                    Text(desc)
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(.primary.opacity(0.7))
                                }
                                Spacer()
                            }
                            .padding(12)
                            .background(Color(.secondarySystemGroupedBackground))
                            .clipShape(.rect(cornerRadius: 10))
                        }
                    }
                }

                OfficialLinkButton(title: "Education Benefits Info", url: "https://www.benefits.gov/benefit/4769")

                Text("Verify all education benefit details with official sources before making enrollment decisions.")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary.opacity(0.6))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Education Planning")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FamilyPlanningView: View {
    private let moveChecklist = [
        "Research cost of living in target areas",
        "Visit potential neighborhoods if possible",
        "Create a moving budget and timeline",
        "Arrange housing before your move date",
        "Update address with USPS, banks, and subscriptions",
        "Transfer medical records to new providers",
        "Register vehicles in new state",
        "Update voter registration",
    ]

    private let spouseEmployment = [
        "Update spouse resume for civilian market",
        "Research employment opportunities in target area",
        "Explore remote work options",
        "Connect with military spouse employment programs",
        "Consider licensing or certification transfers between states",
    ]

    private let childcare = [
        "Research school districts in target area",
        "Request school records and transcripts",
        "Identify childcare options and waitlists",
        "Plan for school enrollment timelines",
        "Look into after-school programs and activities",
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader("Civilian Move Checklist", icon: "house.fill")
                    CardView {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(moveChecklist, id: \.self) { item in
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "circle")
                                        .font(.caption)
                                        .foregroundStyle(.primary.opacity(0.5))
                                        .padding(.top, 2)
                                    Text(item)
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(.primary.opacity(0.8))
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader("Spouse Employment", icon: "person.fill")
                    CardView {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(spouseEmployment, id: \.self) { item in
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "arrow.right.circle.fill")
                                        .font(.caption)
                                        .foregroundStyle(.pink)
                                        .padding(.top, 2)
                                    Text(item)
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(.primary.opacity(0.8))
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader("School & Childcare", icon: "building.columns.fill")
                    CardView {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(childcare, id: \.self) { item in
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "circle")
                                        .font(.caption)
                                        .foregroundStyle(.primary.opacity(0.5))
                                        .padding(.top, 2)
                                    Text(item)
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(.primary.opacity(0.8))
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                OfficialLinkButton(title: "USA.gov Moving Checklist", url: "https://www.usa.gov/moving")

                Text("Research state-specific requirements for licensing, registration, and enrollment in your target area.")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary.opacity(0.6))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Family & Relocation")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FinancialPlanningView: View {
    private let budgetChecklist = [
        "Calculate current total compensation (base + BAH + BAS + special pay)",
        "Estimate post-service income realistically",
        "Identify the income gap and plan for it",
        "Create a civilian budget based on new income",
        "Reduce unnecessary expenses before separation",
        "Build an emergency fund of 3-6 months expenses",
    ]

    private let insuranceItems = [
        "Note SGLI expiration date (120 days after separation)",
        "Apply for VGLI within 240 days for guaranteed coverage",
        "Compare VGLI rates with private life insurance",
        "Set up health insurance for the gap period",
        "Review dental and vision coverage options",
        "Update all beneficiary designations",
    ]

    private let taxItems = [
        "Understand which income is taxable after separation",
        "Research state tax benefits for veterans",
        "Know that disability compensation is tax-free",
        "Keep copies of W-2s and tax returns",
        "Consider TSP rollover options (IRA, 401k)",
        "Consult a tax professional about your specific situation",
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("Not Financial Advice", systemImage: "exclamationmark.triangle.fill")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.orange)
                    Text("This section provides general planning guidance. Consult a qualified financial professional for advice specific to your situation.")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.primary.opacity(0.8))
                }
                .padding(14)
                .background(.orange.opacity(0.06))
                .clipShape(.rect(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader("Budget Reset", icon: "dollarsign.circle.fill")
                    CardView {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(budgetChecklist, id: \.self) { item in
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "circle")
                                        .font(.caption)
                                        .foregroundStyle(.primary.opacity(0.5))
                                        .padding(.top, 2)
                                    Text(item)
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(.primary.opacity(0.8))
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader("Insurance Transition", icon: "shield.fill")
                    CardView {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(insuranceItems, id: \.self) { item in
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "clock.fill")
                                        .font(.caption)
                                        .foregroundStyle(.orange)
                                        .padding(.top, 2)
                                    Text(item)
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(.primary.opacity(0.8))
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    SectionHeader("Tax Reminders", icon: "doc.text.fill")
                    CardView {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(taxItems, id: \.self) { item in
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.caption)
                                        .foregroundStyle(AppTheme.gold)
                                        .padding(.top, 2)
                                    Text(item)
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(.primary.opacity(0.8))
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                OfficialLinkButton(title: "Consumer Financial Protection Bureau", url: "https://www.consumerfinance.gov/consumer-tools/educator-tools/servicemembers/")
                OfficialLinkButton(title: "TSP.gov (Thrift Savings Plan)", url: "https://www.tsp.gov/")

                Text("This is not financial advice. Consult qualified professionals for decisions about investments, taxes, and insurance.")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary.opacity(0.6))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Financial Reset")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FirstThirtyDaysView: View {
    private let week1 = [
        "Secure your DD214 copies and store safely",
        "Set up a civilian bank account if needed",
        "File for unemployment (if eligible in your state)",
        "Update your address with all important contacts",
        "Enroll in veteran health care if eligible",
        "Take a breath — the first week is about stabilizing",
    ]

    private let week2 = [
        "Begin applying for jobs or start your education enrollment",
        "Set up your civilian health insurance if not yet covered",
        "Create a 30/60/90-day personal plan",
        "Connect with a local veteran organization",
        "Review your budget based on actual civilian costs",
    ]

    private let week3 = [
        "Follow up on any pending claims or applications",
        "Schedule medical appointments if needed",
        "Continue networking — aim for 3 new contacts this week",
        "Review and update your resume based on feedback",
        "Start building a daily routine that supports your goals",
    ]

    private let week4 = [
        "Assess your first month — what's working, what's not",
        "Adjust your budget based on real spending",
        "Follow up on all outstanding paperwork",
        "Plan your goals for month 2",
        "Celebrate your first month — you've made it through the hardest part",
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your first 30 days as a civilian are about stabilizing, not perfecting. Focus on the essentials and build from there.")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.primary.opacity(0.8))
                }
                .padding(14)
                .background(.purple.opacity(0.06))
                .clipShape(.rect(cornerRadius: 12))

                weekSection(title: "Week 1: Stabilize", icon: "1.circle.fill", color: .purple, items: week1)
                weekSection(title: "Week 2: Activate", icon: "2.circle.fill", color: .blue, items: week2)
                weekSection(title: "Week 3: Build Momentum", icon: "3.circle.fill", color: .teal, items: week3)
                weekSection(title: "Week 4: Assess & Adjust", icon: "4.circle.fill", color: AppTheme.forestGreen, items: week4)

                Text("Everyone's transition is different. Adjust this guide to fit your situation.")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary.opacity(0.6))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("First 30 Days")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func weekSection(title: String, icon: String, color: Color, items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(color)
                Text(title)
                    .font(.headline.weight(.bold))
            }

            CardView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(items, id: \.self) { item in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "circle")
                                .font(.caption)
                                .foregroundStyle(color)
                                .padding(.top, 2)
                            Text(item)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.primary.opacity(0.8))
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}
