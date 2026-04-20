import SwiftUI

struct FirstThirtyDaysContent: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
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
    }
}

struct FirstYearGuideContent: View {
    @State private var selectedQuarter: YearQuarter = .q1

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            GuideIntroBanner(
                text: "The first year after separation is about stabilizing, adjusting, and building momentum. This guide breaks it down into manageable quarters.",
                color: AppTheme.forestGreen
            )

            HStack(spacing: 6) {
                ForEach(YearQuarter.allCases) { quarter in
                    Button {
                        withAnimation(.snappy) { selectedQuarter = quarter }
                    } label: {
                        VStack(spacing: 4) {
                            Text(quarter.label)
                                .font(.caption.weight(.heavy))
                            Text(quarter.months)
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(selectedQuarter == quarter ? .white.opacity(0.8) : .secondary)
                        }
                        .foregroundStyle(selectedQuarter == quarter ? .white : .primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(selectedQuarter == quarter ? AppTheme.forestGreen : Color(.tertiarySystemBackground))
                        .clipShape(.rect(cornerRadius: 10))
                    }
                    .buttonStyle(.plain)
                    .sensoryFeedback(.selection, trigger: selectedQuarter)
                }
            }

            switch selectedQuarter {
            case .q1: q1
            case .q2: q2
            case .q3: q3
            case .q4: q4
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("Official Resources")
                    .font(.headline.weight(.bold))
                OfficialLinkButton(title: "VA.gov — Manage Your Benefits", url: "https://www.va.gov/")
                OfficialLinkButton(title: "CareerOneStop — Veterans", url: "https://www.careeronestop.org/Veterans/default.aspx")
            }

            GuideDisclaimer(text: "Adapt this guide to your situation and consult professionals for legal, medical, or financial decisions.")
        }
    }

    private var q1: some View {
        VStack(spacing: 16) {
            QuarterHeader(title: "Stabilize & Settle", subtitle: "Months 1–3", icon: "house.fill", color: .purple, description: "Your immediate priority is stability. Secure the basics: healthcare, income, housing, and a daily routine.")
            GuideSection(title: "Health & Wellbeing", icon: "heart.fill", color: .red, items: ["Enroll in veteran health care or confirm your civilian insurance is active", "Schedule your first primary care appointment", "Transfer prescriptions to a civilian pharmacy if needed", "Establish a mental health contact — even if you feel fine now", "Build a physical routine: walk, gym, whatever keeps you moving"])
            GuideSection(title: "Income & Employment", icon: "briefcase.fill", color: .teal, items: ["File for unemployment benefits if eligible in your state", "Activate your job search: 3-5 applications per week minimum", "Set up direct deposit for any benefit payments", "Track your spending — your first civilian paycheck may surprise you"])
            GuideSection(title: "Admin & Claims", icon: "doc.text.fill", color: .orange, items: ["Verify your DD214 is correct — errors get harder to fix over time", "File or follow up on any pending disability claims", "Register with your state's veteran affairs office", "Update your driver's license, vehicle registration, and voter info"])
        }
    }

    private var q2: some View {
        VStack(spacing: 16) {
            QuarterHeader(title: "Build Momentum", subtitle: "Months 4–6", icon: "arrow.up.right", color: .blue, description: "You've survived the initial shock. Now it's time to build. Refine your career path, deepen your network.")
            GuideSection(title: "Career Development", icon: "chart.line.uptrend.xyaxis", color: .blue, items: ["Assess your job — is it the right fit? If not, start planning your next move", "Attend at least 2 networking events or informational interviews this quarter", "Pursue any certifications that would boost your competitiveness", "Update LinkedIn with results and accomplishments, not just duties"])
            GuideSection(title: "Financial Foundation", icon: "dollarsign.circle.fill", color: AppTheme.gold, items: ["Review your first 3 months of civilian spending — identify leaks", "Start building an emergency fund (target: 3 months expenses)", "Decide on TSP: keep it, roll to IRA, or roll to employer 401(k)", "SGLI coverage ends 120 days post-separation — have a plan in place"])
            GuideSection(title: "Claims & Benefits", icon: "clock.arrow.circlepath", color: .orange, items: ["Check the status of any pending disability claims", "If you received a rating, review it for accuracy", "Apply for VGLI within 240 days if you want guaranteed life insurance"])
        }
    }

    private var q3: some View {
        VStack(spacing: 16) {
            QuarterHeader(title: "Optimize & Grow", subtitle: "Months 7–9", icon: "arrow.triangle.branch", color: .teal, description: "You're finding your footing. This quarter is about making strategic improvements.")
            GuideSection(title: "Career Growth", icon: "briefcase.fill", color: .teal, items: ["If employed, have a career development conversation with your manager", "Set 6-month professional goals with measurable outcomes", "Expand your professional network beyond veteran circles", "Consider a mentor in your new industry"])
            GuideSection(title: "Financial Optimization", icon: "chart.bar.fill", color: AppTheme.gold, items: ["Increase emergency fund target to 6 months if possible", "Review investment strategy — are you on track for retirement goals?", "Check your credit score and address any issues", "Evaluate homeownership timeline and VA loan eligibility"])
            GuideSection(title: "Health Check-In", icon: "heart.text.square.fill", color: .red, items: ["Schedule a comprehensive health screening if you haven't in 6 months", "Reassess your mental health — are old patterns returning?", "Review your sleep, nutrition, and exercise habits honestly"])
        }
    }

    private var q4: some View {
        VStack(spacing: 16) {
            QuarterHeader(title: "Reflect & Plan Ahead", subtitle: "Months 10–12", icon: "flag.checkered", color: AppTheme.forestGreen, description: "You've made it through year one. Take stock of how far you've come.")
            GuideSection(title: "Year-One Review", icon: "checklist.checked", color: AppTheme.forestGreen, items: ["Review your original transition goals — how many have you hit?", "Acknowledge your wins — even the small ones count", "Share your experience with someone still serving — pay it forward"])
            GuideSection(title: "Year-Two Planning", icon: "calendar.badge.plus", color: .blue, items: ["Set 3-5 goals for your second year", "If unhappy with your current path, this is a great time to pivot", "Re-evaluate your financial plan with a full year of civilian data"])
            GuideSection(title: "Mindset & Wellbeing", icon: "sparkles", color: .purple, items: ["You are not behind — everyone's timeline is different", "Celebrate making it through the hardest year of transition", "You've earned this new chapter. Own it."])
        }
    }
}

struct MindsetShiftsContent: View {
    private let shifts = TransitionDataService.mindsetShifts()

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            GuideIntroBanner(
                text: "Transition isn't just logistical — it's mental. These shifts help you navigate the biggest changes.",
                color: .indigo
            )

            ForEach(shifts) { shift in
                MindsetShiftCard(shift: shift)
            }

            GuideDisclaimer(text: "Give yourself time. These shifts don't happen overnight, and that's okay.")
        }
    }
}

struct CivilianPlaybookContent: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            GuideIntroBanner(text: "The unwritten rules nobody tells you about civilian life.", color: .blue)

            GuideSection(title: "Workplace Norms", icon: "building.2.fill", color: .teal, items: [
                "Meetings run differently — expect open discussion where rank doesn't determine who speaks",
                "Civilian emails tend to be longer and more diplomatic — use a warmer tone",
                "Dress codes vary wildly — ask before your first day, overdress slightly when in doubt",
                "Feedback cycles are slower — don't wait for it, ask proactively",
            ])

            GuideSection(title: "Communication", icon: "bubble.left.and.bubble.right.fill", color: .blue, items: [
                "Soften the delivery — \"Do this now\" becomes \"Would you be able to prioritize this?\"",
                "Military acronyms are a foreign language to civilians — spell everything out",
                "Small talk isn't wasted time — it's how trust and relationships are built",
                "Conflict resolution is slower and more process-driven",
            ])

            GuideSection(title: "Social Dynamics", icon: "person.2.fill", color: .pink, items: [
                "Most civilians have no frame of reference for military life — don't take it personally",
                "\"Thank you for your service\" will happen constantly — have a comfortable response ready",
                "You'll miss the camaraderie — actively seek communities to rebuild your social circle",
            ])

            GuideSection(title: "Money & Benefits", icon: "dollarsign.circle.fill", color: .orange, items: [
                "Negotiate your salary — in the civilian world, negotiation is expected",
                "Evaluate total compensation (health, retirement, PTO), not just base salary",
                "Without tax-free allowances, your take-home may feel significantly lower",
            ])

            GuideDisclaimer(text: "Take what's useful, adapt what isn't, and give yourself grace.")
        }
    }
}

struct CareerPlanningContent: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            GuideIntroBanner(text: "Military experience is valuable — but the civilian job market works differently.", color: .orange)

            GuideSection(title: "Resume Translation", icon: "doc.text.fill", color: .teal, items: [
                "Replace military jargon with civilian equivalents",
                "Quantify achievements with numbers and percentages",
                "Focus on leadership, management, and problem-solving",
                "Tailor each resume to the specific job posting",
            ])

            GuideSection(title: "Certifications & Licensing", icon: "rosette", color: .purple, items: [
                "Research which civilian certifications apply to your field",
                "Check state-specific requirements — licensing varies by state",
                "Consider industry credentials (PMP, CompTIA, AWS, OSHA, etc.)",
                "Use education benefits to cover certification costs",
            ])

            GuideSection(title: "Interview Prep", icon: "person.fill.questionmark", color: .blue, items: [
                "Research the company and role thoroughly",
                "Prepare 3-5 stories using the STAR method",
                "Practice explaining military experience in civilian terms",
                "Follow up with a thank-you email within 24 hours",
            ])

            GuideSection(title: "Networking", icon: "person.3.fill", color: AppTheme.forestGreen, items: [
                "Update LinkedIn profile with civilian-friendly language",
                "Attend at least one job fair or networking event monthly",
                "Reach out to 3 new contacts per week",
                "Request informational interviews with industry professionals",
            ])

            OfficialLinkButton(title: "O*NET Military Crosswalk Search", url: "https://www.onetonline.org/crosswalk/MOC/")
            OfficialLinkButton(title: "USAJobs.gov (Federal Jobs)", url: "https://www.usajobs.gov/")

            GuideDisclaimer(text: "Always verify employment programs and eligibility with official sources.")
        }
    }
}

struct EducationPlanningContent: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            GuideIntroBanner(text: "Your education benefits are one of the most valuable parts of your service.", color: .blue)

            GuideSection(title: "Education Benefits", icon: "graduationcap.fill", color: .blue, items: [
                "Determine your education benefit eligibility and chapter",
                "Request your Certificate of Eligibility (COE)",
                "Research approved schools and programs",
                "Compare monthly housing allowance by location",
                "Consider transfer of benefits to dependents",
            ])

            GuideSection(title: "Career Readiness Programs", icon: "arrow.triangle.branch", color: .purple, items: [
                "Check if you have a service-connected disability rating",
                "Complete career readiness application (Form 28-1900)",
                "Schedule initial counseling appointment",
                "Programs can cover tuition, books, and supplies",
            ])

            GuideSection(title: "Compare Paths", icon: "arrow.triangle.swap", color: .teal, items: [
                "College / University — 4-year degree, research focus",
                "Trade / Certification — Focused skills, faster completion",
                "Community College — 2-year programs, transfer options",
                "Apprenticeship — Earn while you learn",
            ])

            OfficialLinkButton(title: "Education Benefits Info", url: "https://www.benefits.gov/benefit/4769")

            GuideDisclaimer(text: "Verify all education benefit details with official sources before enrollment decisions.")
        }
    }
}

struct FamilyPlanningContent: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            GuideIntroBanner(text: "Transition affects the whole family. Plan your move, support your spouse, settle the kids.", color: .pink)

            GuideSection(title: "Civilian Move Checklist", icon: "house.fill", color: .pink, items: [
                "Research cost of living in target areas",
                "Create a moving budget and timeline",
                "Arrange housing before your move date",
                "Update address with USPS, banks, and subscriptions",
                "Transfer medical records to new providers",
                "Register vehicles in new state",
            ])

            GuideSection(title: "Spouse Employment", icon: "person.fill", color: .purple, items: [
                "Update spouse resume for civilian market",
                "Research employment opportunities in target area",
                "Explore remote work options",
                "Consider licensing transfers between states",
            ])

            GuideSection(title: "School & Childcare", icon: "building.columns.fill", color: .blue, items: [
                "Research school districts in target area",
                "Request school records and transcripts",
                "Identify childcare options and waitlists",
                "Plan for school enrollment timelines",
            ])

            OfficialLinkButton(title: "USA.gov Moving Checklist", url: "https://www.usa.gov/moving")

            GuideDisclaimer(text: "Research state-specific requirements for licensing, registration, and enrollment.")
        }
    }
}

struct FinancialPlanningContent: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            GuideIntroBanner(text: "General planning guidance. Consult a qualified financial professional for specific advice.", color: .orange)

            GuideSection(title: "Budget Reset", icon: "dollarsign.circle.fill", color: AppTheme.gold, items: [
                "Calculate current total compensation (base + BAH + BAS + special pay)",
                "Estimate post-service income realistically",
                "Identify the income gap and plan for it",
                "Create a civilian budget based on new income",
                "Build an emergency fund of 3-6 months expenses",
            ])

            GuideSection(title: "Insurance Transition", icon: "shield.fill", color: .orange, items: [
                "Note SGLI expiration date (120 days after separation)",
                "Apply for VGLI within 240 days for guaranteed coverage",
                "Set up health insurance for the gap period",
                "Update all beneficiary designations",
            ])

            GuideSection(title: "Tax Reminders", icon: "doc.text.fill", color: AppTheme.gold, items: [
                "Understand which income is taxable after separation",
                "Research state tax benefits for veterans",
                "Know that disability compensation is tax-free",
                "Consider TSP rollover options (IRA, 401k)",
            ])

            OfficialLinkButton(title: "Consumer Financial Protection Bureau", url: "https://www.consumerfinance.gov/consumer-tools/educator-tools/servicemembers/")
            OfficialLinkButton(title: "TSP.gov (Thrift Savings Plan)", url: "https://www.tsp.gov/")

            GuideDisclaimer(text: "This is not financial advice. Consult qualified professionals.")
        }
    }
}
