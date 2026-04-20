import SwiftUI

struct FirstYearGuideView: View {
    @State private var selectedQuarter: YearQuarter = .q1
    @State private var appeared: Bool = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerCard

                quarterPicker

                switch selectedQuarter {
                case .q1:
                    quarterOneContent
                case .q2:
                    quarterTwoContent
                case .q3:
                    quarterThreeContent
                case .q4:
                    quarterFourContent
                }

                keyMilestonesSection

                officialLinks

                GuideDisclaimer(text: "Every transition is unique. Adapt this guide to your situation and consult professionals for legal, medical, or financial decisions.")
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 40)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("First Year Guide")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            withAnimation(.spring(response: 0.5)) { appeared = true }
        }
    }

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 14) {
                Image(systemName: "star.circle.fill")
                    .font(.system(size: 40, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 56, height: 56)
                    .background(
                        LinearGradient(
                            colors: [AppTheme.forestGreen, AppTheme.darkGreen],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(.rect(cornerRadius: 16))

                VStack(alignment: .leading, spacing: 4) {
                    Text("Your First Year")
                        .font(.title3.weight(.bold))
                    Text("Quarter-by-quarter roadmap")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }

            Text("The first year after separation is about stabilizing, adjusting, and building momentum. This guide breaks it down into manageable quarters so you know what to focus on and when.")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.primary.opacity(0.8))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(18)
        .background(
            LinearGradient(
                colors: [AppTheme.forestGreen.opacity(0.08), AppTheme.forestGreen.opacity(0.02)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(.rect(cornerRadius: 18))
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 12)
    }

    private var quarterPicker: some View {
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
                    .background(selectedQuarter == quarter ? AppTheme.forestGreen : Color(.secondarySystemGroupedBackground))
                    .clipShape(.rect(cornerRadius: 10))
                }
                .sensoryFeedback(.selection, trigger: selectedQuarter)
            }
        }
    }

    private var quarterOneContent: some View {
        VStack(spacing: 16) {
            QuarterHeader(
                title: "Stabilize & Settle",
                subtitle: "Months 1–3",
                icon: "house.fill",
                color: .purple,
                description: "Your immediate priority is stability. Secure the basics: healthcare, income, housing, and a daily routine. Don't try to optimize — just get grounded."
            )

            GuideSection(
                title: "Health & Wellbeing",
                icon: "heart.fill",
                color: .red,
                items: [
                    "Enroll in veteran health care or confirm your civilian insurance is active",
                    "Schedule your first primary care appointment",
                    "Transfer prescriptions to a civilian pharmacy if needed",
                    "Establish a mental health contact — even if you feel fine now",
                    "Build a physical routine: walk, gym, whatever keeps you moving",
                    "Allow yourself to grieve the identity shift — it's normal to feel lost",
                ]
            )

            GuideSection(
                title: "Income & Employment",
                icon: "briefcase.fill",
                color: .teal,
                items: [
                    "File for unemployment benefits if eligible in your state",
                    "Activate your job search: apply to 3-5 positions per week minimum",
                    "If starting school, confirm enrollment and benefit payments",
                    "Set up direct deposit for any benefit payments",
                    "Track your spending — your first civilian paycheck may surprise you",
                    "If you have a job lined up, focus on excelling in the first 90 days",
                ]
            )

            GuideSection(
                title: "Admin & Claims",
                icon: "doc.text.fill",
                color: .orange,
                items: [
                    "Verify your DD214 is correct — errors get harder to fix over time",
                    "File or follow up on any pending disability claims",
                    "Register with your state's veteran affairs office",
                    "Update your driver's license, vehicle registration, and voter info",
                    "Set up a filing system for all transition paperwork",
                ]
            )

            GuideSection(
                title: "Family & Social",
                icon: "figure.2.and.child.holdinghands",
                color: .pink,
                items: [
                    "Have an honest conversation with your family about the adjustment",
                    "Get kids enrolled and settled in school",
                    "Find at least one local community group — veteran, hobby, faith, anything",
                    "Reconnect with friends or family you lost touch with during service",
                    "Be patient with yourself and your family — everyone is adjusting",
                ]
            )
        }
        .transition(.opacity.combined(with: .move(edge: .trailing)))
    }

    private var quarterTwoContent: some View {
        VStack(spacing: 16) {
            QuarterHeader(
                title: "Build Momentum",
                subtitle: "Months 4–6",
                icon: "arrow.up.right",
                color: .blue,
                description: "You've survived the initial shock. Now it's time to build. Refine your career path, deepen your network, and start optimizing your finances."
            )

            GuideSection(
                title: "Career Development",
                icon: "chart.line.uptrend.xyaxis",
                color: .blue,
                items: [
                    "Assess your job — is it the right fit? If not, start planning your next move",
                    "If job hunting, expand your search strategy beyond online applications",
                    "Attend at least 2 networking events or informational interviews this quarter",
                    "Pursue any certifications that would boost your competitiveness",
                    "Ask for feedback at work — civilian performance culture is different",
                    "Update LinkedIn with results and accomplishments, not just duties",
                ]
            )

            GuideSection(
                title: "Financial Foundation",
                icon: "dollarsign.circle.fill",
                color: AppTheme.gold,
                items: [
                    "Review your first 3 months of civilian spending — identify leaks",
                    "Create or refine your civilian budget based on real data",
                    "Start or continue building an emergency fund (target: 3 months expenses)",
                    "Decide on TSP: keep it, roll to IRA, or roll to employer 401(k)",
                    "Review all insurance policies — are you still covered? Any gaps?",
                    "File your first civilian tax return on time — note any new deductions",
                ]
            )

            GuideSection(
                title: "Claims & Benefits Follow-Up",
                icon: "clock.arrow.circlepath",
                color: .orange,
                items: [
                    "Check the status of any pending disability claims",
                    "If you received a rating, review it for accuracy",
                    "Appeal or request an increase if your conditions have worsened",
                    "Explore additional benefits you may not have known about",
                    "SGLI coverage ends 120 days post-separation — have a plan in place",
                    "Apply for VGLI within 240 days if you want guaranteed life insurance",
                ]
            )

            GuideSection(
                title: "Identity & Purpose",
                icon: "brain.fill",
                color: .purple,
                items: [
                    "Reflect: what gives you purpose outside of service?",
                    "Consider volunteering — it rebuilds community and purpose",
                    "Explore hobbies or interests you couldn't pursue during service",
                    "If struggling with identity, talk to someone — this is the #1 transition challenge",
                    "Journal or track your progress — you've come further than you think",
                ]
            )
        }
        .transition(.opacity.combined(with: .move(edge: .trailing)))
    }

    private var quarterThreeContent: some View {
        VStack(spacing: 16) {
            QuarterHeader(
                title: "Optimize & Grow",
                subtitle: "Months 7–9",
                icon: "arrow.triangle.branch",
                color: .teal,
                description: "You're finding your footing. This quarter is about making strategic improvements — career growth, deeper financial planning, and investing in relationships."
            )

            GuideSection(
                title: "Career Growth",
                icon: "briefcase.fill",
                color: .teal,
                items: [
                    "If employed, have a career development conversation with your manager",
                    "Set 6-month professional goals with measurable outcomes",
                    "Expand your professional network beyond veteran circles",
                    "Research industry conferences, workshops, or online courses",
                    "If in school, check your academic progress against your plan",
                    "Consider a mentor in your new industry — fresh perspective matters",
                ]
            )

            GuideSection(
                title: "Financial Optimization",
                icon: "chart.bar.fill",
                color: AppTheme.gold,
                items: [
                    "Increase emergency fund target to 6 months if possible",
                    "Review investment strategy — are you on track for retirement goals?",
                    "Check your credit score and address any issues",
                    "Evaluate homeownership timeline and VA loan eligibility",
                    "Review subscription services and recurring charges",
                    "If starting a business, formalize your business plan and finances",
                ]
            )

            GuideSection(
                title: "Health Check-In",
                icon: "heart.text.square.fill",
                color: .red,
                items: [
                    "Schedule a comprehensive health screening if you haven't in 6 months",
                    "Reassess your mental health — are old patterns returning?",
                    "If you haven't used counseling, consider trying it now",
                    "Review your sleep, nutrition, and exercise habits honestly",
                    "Check that all dependents are up to date on medical care",
                ]
            )

            GuideSection(
                title: "Community & Relationships",
                icon: "person.3.fill",
                color: .pink,
                items: [
                    "Deepen relationships you've built since separation",
                    "If isolated, make one new social commitment this quarter",
                    "Give back: mentor a transitioning service member",
                    "Strengthen family bonds — schedule regular quality time",
                    "Evaluate your support system — do you have people you can call?",
                ]
            )
        }
        .transition(.opacity.combined(with: .move(edge: .trailing)))
    }

    private var quarterFourContent: some View {
        VStack(spacing: 16) {
            QuarterHeader(
                title: "Reflect & Plan Ahead",
                subtitle: "Months 10–12",
                icon: "flag.checkered",
                color: AppTheme.forestGreen,
                description: "You've made it through year one. Take stock of how far you've come, address any remaining gaps, and set yourself up for a strong year two."
            )

            GuideSection(
                title: "Year-One Review",
                icon: "checklist.checked",
                color: AppTheme.forestGreen,
                items: [
                    "Review your original transition goals — how many have you hit?",
                    "Identify what surprised you most about civilian life",
                    "Acknowledge your wins — even the small ones count",
                    "What do you wish you'd done differently? Write it down for clarity",
                    "Share your experience with someone still serving — pay it forward",
                ]
            )

            GuideSection(
                title: "Remaining Admin",
                icon: "tray.full.fill",
                color: .orange,
                items: [
                    "Follow up on any outstanding claims, appeals, or paperwork",
                    "Ensure all benefits are active and being utilized",
                    "Verify your contact info is up to date with all agencies",
                    "Review and update your estate planning documents",
                    "Check that your emergency contacts and beneficiaries are current",
                ]
            )

            GuideSection(
                title: "Year-Two Planning",
                icon: "calendar.badge.plus",
                color: .blue,
                items: [
                    "Set 3-5 goals for your second year — career, health, financial, personal",
                    "If unhappy with your current path, this is a great time to pivot",
                    "Plan for any education milestones or certification renewals",
                    "Re-evaluate your financial plan with a full year of civilian data",
                    "Consider long-term housing, career trajectory, and family needs",
                ]
            )

            GuideSection(
                title: "Mindset & Wellbeing",
                icon: "sparkles",
                color: .purple,
                items: [
                    "You are not behind — everyone's timeline is different",
                    "If you're still struggling, that's okay — seek professional support",
                    "Celebrate making it through the hardest year of transition",
                    "Remember: the skills you built in service are still your superpower",
                    "You've earned this new chapter. Own it.",
                ]
            )
        }
        .transition(.opacity.combined(with: .move(edge: .trailing)))
    }

    private var keyMilestonesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                Image(systemName: "flag.fill")
                    .font(.body.weight(.bold))
                    .foregroundStyle(AppTheme.gold)
                    .frame(width: 32, height: 32)
                    .background(AppTheme.gold.opacity(0.12))
                    .clipShape(.rect(cornerRadius: 8))
                Text("Key Deadlines")
                    .font(.headline.weight(.bold))
            }

            VStack(spacing: 8) {
                FirstYearDeadlineRow(timeframe: "120 Days", title: "SGLI Coverage Expires", detail: "Servicemembers' Group Life Insurance ends. Convert to VGLI or get private coverage.", color: .red, icon: "exclamationmark.triangle.fill")
                FirstYearDeadlineRow(timeframe: "180 Days", title: "TAMP Health Coverage Ends", detail: "Transitional health coverage expires. Ensure you have a plan in place.", color: .red, icon: "exclamationmark.triangle.fill")
                FirstYearDeadlineRow(timeframe: "240 Days", title: "VGLI Enrollment Deadline", detail: "Last day to apply for Veterans' Group Life Insurance without medical review.", color: .orange, icon: "clock.fill")
                FirstYearDeadlineRow(timeframe: "1 Year", title: "Intent to File Deadline", detail: "If you filed an Intent to File, your claim must be submitted within 1 year.", color: .orange, icon: "clock.fill")
                FirstYearDeadlineRow(timeframe: "1 Year", title: "Annual Benefits Review", detail: "Review all active benefits, update contact info, and reassess your needs.", color: .blue, icon: "calendar.badge.checkmark")
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))
        }
    }

    private var officialLinks: some View {
        EmptyView()
    }
}

nonisolated enum YearQuarter: String, CaseIterable, Identifiable, Sendable {
    case q1 = "Q1"
    case q2 = "Q2"
    case q3 = "Q3"
    case q4 = "Q4"

    var id: String { rawValue }

    var label: String { rawValue }

    var months: String {
        switch self {
        case .q1: "Mo 1–3"
        case .q2: "Mo 4–6"
        case .q3: "Mo 7–9"
        case .q4: "Mo 10–12"
        }
    }
}

struct QuarterHeader: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(color.gradient)
                    .clipShape(.rect(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.title3.weight(.bold))
                    Text(subtitle)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(color)
                }

                Spacer()
            }

            Text(description)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .background(color.opacity(0.06))
        .clipShape(.rect(cornerRadius: 16))
    }
}

struct FirstYearDeadlineRow: View {
    let timeframe: String
    let title: String
    let detail: String
    let color: Color
    let icon: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(spacing: 2) {
                Image(systemName: icon)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(color)
                Text(timeframe)
                    .font(.system(size: 9, weight: .heavy))
                    .foregroundStyle(color)
            }
            .frame(width: 56)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.subheadline.weight(.bold))
                Text(detail)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
        .padding(10)
        .background(color.opacity(0.04))
        .clipShape(.rect(cornerRadius: 10))
    }
}
