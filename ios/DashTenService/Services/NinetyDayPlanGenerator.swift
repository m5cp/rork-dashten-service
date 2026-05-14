import Foundation

nonisolated enum NinetyDayTemplate: String, CaseIterable, Identifiable, Sendable {
    case civilianJob = "civilian_job"
    case schoolGIBill = "school_gi_bill"
    case business = "business"
    case retirement = "retirement"
    case balanced = "balanced"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .civilianJob: "New Civilian Job"
        case .schoolGIBill: "School / GI Bill"
        case .business: "Start a Business"
        case .retirement: "Retirement Transition"
        case .balanced: "Balanced Reset"
        }
    }

    var subtitle: String {
        switch self {
        case .civilianJob: "Ramp into a new role, build credibility fast"
        case .schoolGIBill: "Lock in benefits, register, build study habits"
        case .business: "Validate, register, and ship your first offer"
        case .retirement: "Tricare, SBP, DFAS, pension, and a new chapter"
        case .balanced: "A little of everything — mix and match"
        }
    }

    var icon: String {
        switch self {
        case .civilianJob: "briefcase.fill"
        case .schoolGIBill: "graduationcap.fill"
        case .business: "lightbulb.fill"
        case .retirement: "medal.fill"
        case .balanced: "circle.grid.3x3.fill"
        }
    }
}

nonisolated enum NinetyDayPlanGenerator {
    /// Returns the best-guess template for a profile.
    static func suggestedTemplate(profile: UserProfile) -> NinetyDayTemplate {
        if profile.postServiceStatus == .retired { return .retirement }
        let goals = Set(profile.goals)
        if goals.contains(.entrepreneurship) { return .business }
        if goals.contains(.school) || goals.contains(.certification) { return .schoolGIBill }
        if goals.contains(.employment) || goals.contains(.careerReadiness) { return .civilianJob }
        return .balanced
    }

    /// Generates a personalized 12-week plan.
    static func generate(profile: UserProfile, template: NinetyDayTemplate) -> NinetyDayPlan {
        var plan = NinetyDayPlan()
        let seeds = seedsFor(template: template, profile: profile)
        for (i, seed) in seeds.enumerated() where i < plan.weeks.count {
            plan.weeks[i].goals = seed.goals
            plan.weeks[i].peopleToMeet = seed.people
            plan.weeks[i].wins = seed.wins
        }
        return plan
    }

    // MARK: - Seeds

    private struct WeekSeed {
        let goals: [String]
        let people: [String]
        let wins: [String]
    }

    private static func seedsFor(template: NinetyDayTemplate, profile: UserProfile) -> [WeekSeed] {
        switch template {
        case .civilianJob: return civilianJobSeeds()
        case .schoolGIBill: return schoolSeeds()
        case .business: return businessSeeds()
        case .retirement: return retirementSeeds()
        case .balanced: return balancedSeeds()
        }
    }

    private static func civilianJobSeeds() -> [WeekSeed] {
        [
            // Month 1 — Stabilize & orient
            WeekSeed(goals: ["1:1 with your manager — clarify expectations", "Set up email signature, calendar, payroll, benefits"],
                     people: ["Direct manager", "HR / onboarding lead"],
                     wins: []),
            WeekSeed(goals: ["Meet every member of your immediate team", "Document how decisions actually get made here"],
                     people: ["Each teammate", "Skip-level manager"],
                     wins: []),
            WeekSeed(goals: ["Shadow one customer call or client interaction", "Identify the top 3 metrics your role is measured by"],
                     people: ["Cross-functional partner (sales, product, ops)"],
                     wins: []),
            WeekSeed(goals: ["30-day review with manager — share what you've learned", "Write down your first quick-win project"],
                     people: ["Mentor inside the company"],
                     wins: ["Completed first 30 days"]),
            // Month 2 — Build momentum
            WeekSeed(goals: ["Ship your first small deliverable", "Ask for feedback from 3 peers"],
                     people: ["Peer reviewer"],
                     wins: []),
            WeekSeed(goals: ["Volunteer for one cross-team project", "Schedule recurring 1:1s with key stakeholders"],
                     people: ["Stakeholder in another team"],
                     wins: []),
            WeekSeed(goals: ["Identify a stretch problem worth owning", "Update LinkedIn with your new role"],
                     people: ["Industry peer outside the company"],
                     wins: []),
            WeekSeed(goals: ["60-day check-in: what's working, what isn't", "Ask manager what 'great in 90 days' looks like"],
                     people: ["Manager"],
                     wins: ["Owned a stretch project"]),
            // Month 3 — Accelerate & assess
            WeekSeed(goals: ["Take ownership of one process improvement", "Mentor or onboard someone newer than you"],
                     people: ["A newer hire"],
                     wins: []),
            WeekSeed(goals: ["Document the playbook you'd give your replacement", "Quantify one result you've delivered"],
                     people: [],
                     wins: []),
            WeekSeed(goals: ["Pitch the next quarter's project to your manager", "Ask for a clear path to your next promotion"],
                     people: ["Senior leader / sponsor"],
                     wins: []),
            WeekSeed(goals: ["90-day self-review — strengths, gaps, next quarter goals", "Celebrate one specific win out loud"],
                     people: [],
                     wins: ["Completed first 90 days"])
        ]
    }

    private static func schoolSeeds() -> [WeekSeed] {
        [
            WeekSeed(goals: ["Confirm Certificate of Eligibility (COE) is on file with the school", "Verify housing allowance / BAH zip code for your campus"],
                     people: ["School Certifying Official (SCO)"],
                     wins: []),
            WeekSeed(goals: ["Submit all transcripts (including JST) for credit evaluation", "Map your degree plan and required courses"],
                     people: ["Academic advisor"],
                     wins: []),
            WeekSeed(goals: ["Set up student email + LMS notifications", "Find the Veterans Resource Center on campus"],
                     people: ["VRC / Veteran Services lead"],
                     wins: []),
            WeekSeed(goals: ["30-day check: confirm your benefit is paying out correctly", "Build a weekly study calendar"],
                     people: ["SCO follow-up"],
                     wins: ["Benefits flowing correctly"]),
            WeekSeed(goals: ["Form a study group in your hardest class", "Visit each professor in office hours once"],
                     people: ["Classmates in your major"],
                     wins: []),
            WeekSeed(goals: ["Apply for one veteran scholarship", "Map internships or part-time roles in your field"],
                     people: ["Career center"],
                     wins: []),
            WeekSeed(goals: ["Mid-semester self-review: grades, time, energy", "Adjust schedule if any course is at risk"],
                     people: ["Tutor or TA"],
                     wins: []),
            WeekSeed(goals: ["Lock in summer internship or research plan", "Update LinkedIn with current education"],
                     people: ["Faculty mentor"],
                     wins: []),
            WeekSeed(goals: ["Build a portfolio site or class portfolio", "Network with one veteran alumnus in your major"],
                     people: ["Veteran alum on LinkedIn"],
                     wins: []),
            WeekSeed(goals: ["Plan finals study schedule by class weight", "Confirm next semester registration"],
                     people: ["Advisor"],
                     wins: []),
            WeekSeed(goals: ["Sit a mock interview for internships", "Save final project / sample work for portfolio"],
                     people: ["Career counselor"],
                     wins: []),
            WeekSeed(goals: ["90-day review: GPA trajectory, benefit balance, next term plan", "Decide what to keep doing and what to drop"],
                     people: [],
                     wins: ["Completed first 90 days as a student"])
        ]
    }

    private static func businessSeeds() -> [WeekSeed] {
        [
            WeekSeed(goals: ["Write the one-sentence problem your business solves", "Define the exact customer you'll serve first"],
                     people: ["3 people in your target market"],
                     wins: []),
            WeekSeed(goals: ["Do 10 customer-discovery conversations", "Pick a business structure (LLC, S-Corp, sole prop)"],
                     people: ["10 potential customers", "CPA or SBA Boots-to-Business advisor"],
                     wins: []),
            WeekSeed(goals: ["Register the business + EIN", "Open a dedicated business bank account"],
                     people: ["Veteran-owned business mentor"],
                     wins: ["Legal entity formed"]),
            WeekSeed(goals: ["Define your first offer + price", "30-day review: refine problem, customer, and offer"],
                     people: [],
                     wins: []),
            WeekSeed(goals: ["Build a one-page website or landing page", "Set up basic accounting (QuickBooks / Wave)"],
                     people: ["Designer or no-code builder"],
                     wins: []),
            WeekSeed(goals: ["Sign your first paying customer", "Capture every lesson in a simple CRM or sheet"],
                     people: ["First customer"],
                     wins: ["First paying customer"]),
            WeekSeed(goals: ["Deliver and ask for a testimonial", "Define your repeatable sales motion"],
                     people: ["Industry peer running a similar business"],
                     wins: []),
            WeekSeed(goals: ["60-day review: revenue, costs, what's working", "Identify the single biggest bottleneck"],
                     people: ["Mentor / advisor"],
                     wins: []),
            WeekSeed(goals: ["Run a small paid marketing or outreach test", "Document your sales script and onboarding"],
                     people: ["3 new prospects per week"],
                     wins: []),
            WeekSeed(goals: ["Pitch to a VBOC or veteran business program", "Decide what you'll automate or delegate"],
                     people: ["Veterans Business Outreach Center (VBOC) advisor"],
                     wins: []),
            WeekSeed(goals: ["Lock in next quarter's revenue target", "Build a 90-day forecast for cash"],
                     people: ["Accountant / bookkeeper"],
                     wins: []),
            WeekSeed(goals: ["90-day review: keep / change / kill", "Pick the one move that defines the next quarter"],
                     people: [],
                     wins: ["Completed first 90 days as a founder"])
        ]
    }

    private static func retirementSeeds() -> [WeekSeed] {
        [
            WeekSeed(goals: ["Confirm DFAS retired pay is correct on the first deposit", "Verify Tricare enrollment (Prime / Select / TFL)"],
                     people: ["DFAS retired pay (1-800-321-1080)"],
                     wins: []),
            WeekSeed(goals: ["Review SBP election and confirm beneficiary", "File any remaining VA disability claim updates"],
                     people: ["VA-accredited VSO"],
                     wins: []),
            WeekSeed(goals: ["Update SGLI to VGLI before the conversion window closes", "Build a one-page post-retirement budget"],
                     people: ["VGLI rep at Prudential / OSGLI"],
                     wins: []),
            WeekSeed(goals: ["30-day check: DFAS, VA, Tricare all working", "Set up retiree ID renewal reminder"],
                     people: ["RAO / Retiree Activities Office"],
                     wins: ["Pay and benefits running clean"]),
            WeekSeed(goals: ["Meet with a fiduciary financial planner", "Map RMDs, TSP rollover options, IRA strategy"],
                     people: ["Fiduciary financial advisor"],
                     wins: []),
            WeekSeed(goals: ["Decide on a second-act path: work, consult, volunteer", "Identify 2 veteran communities to join locally"],
                     people: ["Veteran service organization near you"],
                     wins: []),
            WeekSeed(goals: ["Build a weekly routine: movement, learning, social", "Schedule a complete physical / dental / vision"],
                     people: ["Primary care provider"],
                     wins: []),
            WeekSeed(goals: ["60-day check: how are energy, identity, finances?", "Adjust budget against actual spending"],
                     people: ["Spouse / partner financial review"],
                     wins: []),
            WeekSeed(goals: ["Visit one veteran organization meeting in person", "Update estate docs: will, POA, healthcare directive"],
                     people: ["Estate attorney"],
                     wins: []),
            WeekSeed(goals: ["Decide on a part-time role, consulting, or volunteer cadence", "Set a quarterly travel or family goal"],
                     people: ["Mentor or coach"],
                     wins: []),
            WeekSeed(goals: ["Document benefits + access info for your spouse", "Confirm DEERS information is current"],
                     people: ["Spouse"],
                     wins: []),
            WeekSeed(goals: ["90-day review: finances, health, purpose, relationships", "Pick one big thing for the next 90 days"],
                     people: [],
                     wins: ["Completed first 90 days of retirement"])
        ]
    }

    private static func balancedSeeds() -> [WeekSeed] {
        [
            WeekSeed(goals: ["Confirm DD-214 and DEERS information are correct", "Set up post-service health care (VA or civilian)"],
                     people: ["VA enrollment counselor"],
                     wins: []),
            WeekSeed(goals: ["Update LinkedIn with civilian-friendly summary", "Map 3 career paths you'd realistically pursue"],
                     people: ["Veteran mentor in target field"],
                     wins: []),
            WeekSeed(goals: ["Translate your resume — remove acronyms, add metrics", "Build a one-page transition budget"],
                     people: ["Resume reviewer"],
                     wins: []),
            WeekSeed(goals: ["30-day review: docs, health, finances", "Pick the single most important focus for month 2"],
                     people: [],
                     wins: ["First 30 days complete"]),
            WeekSeed(goals: ["Run 5 informational interviews this week", "Apply or enroll in one concrete next step"],
                     people: ["5 informational interviews"],
                     wins: []),
            WeekSeed(goals: ["Establish a daily routine: sleep, movement, learning", "File or update your VA disability claim"],
                     people: ["VSO"],
                     wins: []),
            WeekSeed(goals: ["Attend one veteran community event in person", "Build an emergency fund target (3–6 months)"],
                     people: ["Local veteran community lead"],
                     wins: []),
            WeekSeed(goals: ["60-day review: what's working, what's stuck", "Set one stretch goal for the next 30 days"],
                     people: ["Mentor"],
                     wins: []),
            WeekSeed(goals: ["Ship one tangible piece of work (portfolio, project, offer)", "Schedule a financial check-in with a fiduciary"],
                     people: ["Financial advisor"],
                     wins: []),
            WeekSeed(goals: ["Strengthen one habit: workout, study, sales calls", "Document lessons learned so far"],
                     people: [],
                     wins: []),
            WeekSeed(goals: ["Plan the next 90 days based on what you've learned", "Identify 1 area you no longer need to focus on"],
                     people: [],
                     wins: []),
            WeekSeed(goals: ["90-day self-review across career, health, money, mindset", "Choose your next 'one big thing'"],
                     people: [],
                     wins: ["Completed first 90 days post-service"])
        ]
    }
}
