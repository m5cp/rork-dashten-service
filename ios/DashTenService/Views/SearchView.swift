import SwiftUI

// MARK: - Search domain

enum SearchKind: String, CaseIterable, Identifiable, Hashable {
    case tool = "Tool"
    case guideContent = "Guide"
    case benefit = "Benefit"
    case article = "Article"

    var id: String { rawValue }

    var color: Color {
        switch self {
        case .tool: return AppTheme.forestGreen
        case .guideContent: return .indigo
        case .benefit: return .blue
        case .article: return .purple
        }
    }

    var icon: String {
        switch self {
        case .tool: return "wrench.and.screwdriver.fill"
        case .guideContent: return "book.fill"
        case .benefit: return "shield.lefthalf.filled"
        case .article: return "doc.text.fill"
        }
    }

    var sectionLabel: String {
        switch self {
        case .tool: return "Tools"
        case .guideContent: return "Guides"
        case .benefit: return "Benefits"
        case .article: return "Articles"
        }
    }
}

enum SearchDestination: Hashable {
    case route(PlanningRoute)
    case sheet(ToolboxSheet)
    case benefit(String)         // benefit category id
    case article(ArticleRoute)
}

enum ArticleRoute: Hashable {
    case mindsetShift(String)    // shift id to expand
    case mindsetShifts           // overview
    case civilianPlaybook
    case firstThirtyDays
    case firstYear(YearQuarter)
}

struct SearchItem: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let kind: SearchKind
    let keywords: [String]
    let body: String              // searchable long-form text
    let destination: SearchDestination

    static func == (lhs: SearchItem, rhs: SearchItem) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

// MARK: - Search View

struct SearchView: View {
    let storage: StorageService
    var store: StoreViewModel

    @State private var searchText: String = ""
    @State private var navPath = NavigationPath()
    @State private var activeSheet: ToolboxSheet?
    @State private var showPaywall: Bool = false
    @FocusState private var searchFocused: Bool

    private var isSearching: Bool { !searchText.trimmingCharacters(in: .whitespaces).isEmpty }

    // MARK: Tool & guide entries

    private var moneyTools: [SearchItem] {
        [
            SearchItem(id: "t.compensation", title: "Compensation Calculator", subtitle: "See what your military pay equals in civilian terms", icon: "equal.circle.fill", color: AppTheme.forestGreen, kind: .tool, keywords: ["pay", "salary", "money", "compensation"], body: "Base pay, BAH, BAS, special pay civilian equivalent", destination: .sheet(.compensation)),
            SearchItem(id: "t.incomeGap", title: "Income Gap Planner", subtitle: "How much savings you need for the gap", icon: "chart.line.downtrend.xyaxis", color: .orange, kind: .tool, keywords: ["savings", "gap", "income"], body: "Calculate the income gap during transition", destination: .sheet(.incomeGap)),
            SearchItem(id: "t.civilianBudget", title: "Civilian Budget Builder", subtitle: "Build your post-service monthly budget", icon: "creditcard.fill", color: .purple, kind: .tool, keywords: ["budget", "expenses", "monthly"], body: "Civilian monthly budget planner", destination: .sheet(.civilianBudget)),
            SearchItem(id: "t.emergencyFund", title: "Emergency Fund Calculator", subtitle: "Target 3–6 months of essential expenses", icon: "shield.lefthalf.filled", color: .teal, kind: .tool, keywords: ["emergency", "fund", "savings"], body: "Build an emergency fund", destination: .sheet(.emergencyFund)),
            SearchItem(id: "t.costOfLiving", title: "Cost of Living Comparator", subtitle: "Compare cities side by side", icon: "building.2.fill", color: .mint, kind: .tool, keywords: ["city", "cost", "compare", "living", "relocation"], body: "Compare cost of living between cities", destination: .route(.costOfLiving)),
            SearchItem(id: "t.tspRollover", title: "TSP Options", subtitle: "Explore rollover options after separation", icon: "arrow.triangle.swap", color: .blue, kind: .tool, keywords: ["tsp", "retirement", "401k", "rollover", "ira"], body: "TSP rollover IRA 401k options", destination: .route(.tspRollover)),
            SearchItem(id: "t.tspGrowth", title: "TSP Growth Estimator", subtitle: "Project your TSP at separation with DoD match", icon: "chart.line.uptrend.xyaxis", color: AppTheme.forestGreen, kind: .tool, keywords: ["tsp", "growth", "retirement", "match", "brs"], body: "TSP growth projection DoD match BRS", destination: .route(.tspGrowthEstimator)),
            SearchItem(id: "t.brsSnapshot", title: "BRS Retirement Snapshot", subtitle: "TSP + pension combined picture", icon: "chart.pie.fill", color: AppTheme.gold, kind: .tool, keywords: ["brs", "pension", "retirement", "snapshot"], body: "BRS pension TSP combined retirement", destination: .route(.brsRetirementSnapshot)),
            SearchItem(id: "t.vaLoanGuide", title: "VA Home Loan Guide", subtitle: "Eligibility, benefits, COE and homebuying steps", icon: "house.fill", color: AppTheme.forestGreen, kind: .tool, keywords: ["va", "home", "loan", "mortgage", "house", "coe", "eligibility", "no down payment", "pmi"], body: "VA home loan eligibility benefits certificate of eligibility no down payment no PMI", destination: .route(.vaHomeLoanGuide)),
            SearchItem(id: "t.vaFundingFee", title: "VA Funding Fee", subtitle: "Calculate your VA loan funding fee", icon: "percent", color: .blue, kind: .tool, keywords: ["va", "funding fee", "loan", "mortgage", "home", "house"], body: "VA funding fee calculator", destination: .route(.vaFundingFee)),
            SearchItem(id: "t.jobOffer", title: "Job Offer Compare", subtitle: "Side-by-side total compensation analysis", icon: "scalemass.fill", color: .indigo, kind: .tool, keywords: ["offer", "compare", "job", "salary"], body: "Compare job offers total compensation", destination: .route(.jobOfferCompare)),
            SearchItem(id: "t.salaryNegotiation", title: "Salary Negotiation", subtitle: "Know your worth and ask for it", icon: "hand.raised.fill", color: .pink, kind: .tool, keywords: ["negotiate", "salary"], body: "Salary negotiation scripts and strategy", destination: .route(.salaryNegotiation)),
        ]
    }

    private var careerTools: [SearchItem] {
        [
            SearchItem(id: "t.resume", title: "Resume Translator", subtitle: "Military → civilian language + jargon lookup", icon: "doc.text.fill", color: .teal, kind: .tool, keywords: ["resume", "jargon", "translate", "mos"], body: "Translate military experience MOS into civilian resume", destination: .route(.resumeTranslator)),
            SearchItem(id: "t.skills", title: "Skills Inventory", subtitle: "Map your skills to civilian career fields", icon: "list.clipboard.fill", color: .orange, kind: .tool, keywords: ["skills", "career", "inventory"], body: "Skills inventory mapping civilian careers", destination: .route(.skillsInventory)),
            SearchItem(id: "t.interview", title: "Interview Prep", subtitle: "Practice with flashcards and coaching tips", icon: "person.fill.questionmark", color: .blue, kind: .tool, keywords: ["interview", "practice", "prep", "questions"], body: "Interview preparation behavioral STAR questions", destination: .route(.interviewPrep)),
            SearchItem(id: "t.elevator", title: "Elevator Pitch Builder", subtitle: "Craft your 30/60/90-second intro", icon: "mic.fill", color: .purple, kind: .tool, keywords: ["pitch", "intro", "elevator"], body: "Elevator pitch builder intro", destination: .route(.elevatorPitch)),
            SearchItem(id: "t.networking", title: "Networking Hub", subtitle: "Track contacts, events, and follow-ups", icon: "person.3.fill", color: .purple, kind: .tool, keywords: ["networking", "contacts", "events"], body: "Networking hub track contacts follow ups", destination: .route(.networkingScorecard)),
            SearchItem(id: "t.brand", title: "Personal Brand Audit", subtitle: "Score your professional presence", icon: "person.crop.circle.badge.checkmark", color: .blue, kind: .tool, keywords: ["brand", "linkedin", "audit"], body: "Personal brand audit LinkedIn professional presence", destination: .route(.personalBrandAudit)),
            SearchItem(id: "t.jargon", title: "Civilian Jargon Translator", subtitle: "Look up civilian terms and corporate-speak", icon: "character.bubble.fill", color: .teal, kind: .tool, keywords: ["jargon", "corporate", "lingo", "translate", "buzzword"], body: "Corporate jargon civilian terms lookup", destination: .route(.jargonTranslator)),
            SearchItem(id: "t.eventPrep", title: "Networking Event Prep", subtitle: "Plan, attend, and follow up on events", icon: "calendar.badge.plus", color: .purple, kind: .tool, keywords: ["networking", "event", "prep", "conference", "meetup"], body: "Networking event prep follow up", destination: .route(.networkingEventPrep)),
        ]
    }

    private var planningTools: [SearchItem] {
        [
            SearchItem(id: "t.decisionMatrix", title: "Decision Matrix", subtitle: "Weighted side-by-side comparison tool", icon: "square.grid.3x3.fill", color: .blue, kind: .tool, keywords: ["decision", "compare", "matrix"], body: "Weighted decision matrix comparison", destination: .route(.decisionMatrix)),
            SearchItem(id: "t.90day", title: "First 90 Days Planner", subtitle: "Week-by-week post-hire plan + goal tracking", icon: "calendar.badge.clock", color: .purple, kind: .tool, keywords: ["90 days", "planner", "goals", "post hire"], body: "First 90 days planner new job", destination: .route(.ninetyDayPlanner)),
            SearchItem(id: "t.journal", title: "Transition Journal", subtitle: "Daily guided prompts and reflections", icon: "book.fill", color: .purple, kind: .tool, keywords: ["journal", "write", "reflect", "prompts"], body: "Transition journal daily prompts", destination: .route(.transitionJournal)),
            SearchItem(id: "t.wellness", title: "Wellness Check-In", subtitle: "Track well-being and readiness over time", icon: "chart.xyaxis.line", color: .blue, kind: .tool, keywords: ["wellness", "checkin", "stress", "mental"], body: "Wellness weekly check in mental health", destination: .route(.weeklyCheckIn)),
            SearchItem(id: "t.giBillBah", title: "GI Bill BAH Calculator", subtitle: "Housing allowance by school location", icon: "house.fill", color: .blue, kind: .tool, keywords: ["gi bill", "bah", "housing", "post 911"], body: "GI Bill BAH housing allowance school", destination: .route(.giBillBAH)),
            SearchItem(id: "t.eduCompare", title: "Education Benefits", subtitle: "Compare GI Bill options side by side", icon: "chart.bar.doc.horizontal.fill", color: .indigo, kind: .tool, keywords: ["education", "gi bill", "compare", "montgomery"], body: "GI Bill Montgomery Post 9/11 compare", destination: .route(.educationComparison)),
            SearchItem(id: "t.relocation", title: "Move Budget", subtitle: "Plan your moving costs", icon: "shippingbox.fill", color: .pink, kind: .tool, keywords: ["moving", "relocation", "budget", "pcs"], body: "PCS relocation move budget", destination: .route(.relocationCost)),
            SearchItem(id: "t.stateBenefits", title: "State Benefits Finder", subtitle: "State-specific veteran benefits", icon: "flag.fill", color: AppTheme.forestGreen, kind: .tool, keywords: ["state", "benefits", "veteran", "property tax"], body: "State benefits property tax exemption tuition waiver", destination: .route(.stateBenefits)),
            SearchItem(id: "t.scra", title: "SCRA Protections", subtitle: "Your legal rights as a service member", icon: "shield.lefthalf.filled", color: .teal, kind: .tool, keywords: ["scra", "legal", "lease", "rights", "protection", "civil relief"], body: "SCRA Servicemembers Civil Relief Act legal protections", destination: .route(.scraProtections)),
            SearchItem(id: "t.financialReadiness", title: "Financial Readiness Help", subtitle: "Free help by branch — ACS, FFSC, MCCS and more", icon: "person.fill.checkmark", color: AppTheme.forestGreen, kind: .tool, keywords: ["acs", "ffsc", "mccs", "financial", "counselor", "help", "free", "budget"], body: "ACS FFSC MCCS free financial counseling", destination: .route(.financialReadiness)),
            SearchItem(id: "t.roadmap", title: "Transition Roadmap", subtitle: "Your phased path from service to civilian life", icon: "map.fill", color: .indigo, kind: .tool, keywords: ["roadmap", "timeline", "phases", "plan"], body: "Transition roadmap timeline phases", destination: .route(.roadmap)),
            SearchItem(id: "t.goals", title: "90-Day Goals", subtitle: "Set and track measurable goals", icon: "target", color: .orange, kind: .tool, keywords: ["goals", "targets", "tracker"], body: "90 day goal tracker", destination: .route(.goalTracker)),
            SearchItem(id: "t.weekly", title: "Weekly Challenges", subtitle: "Small actions that build big momentum", icon: "flag.checkered", color: .pink, kind: .tool, keywords: ["challenge", "weekly", "momentum"], body: "Weekly challenges micro actions", destination: .route(.weeklyChallenges)),
            SearchItem(id: "t.powerup", title: "Daily Power-Up", subtitle: "A daily action to keep you moving", icon: "bolt.fill", color: AppTheme.gold, kind: .tool, keywords: ["daily", "power", "motivation", "habit"], body: "Daily power up motivation habit", destination: .route(.dailyPowerUp)),
            SearchItem(id: "t.deadlines", title: "Benefits Enrollment Countdown", subtitle: "Track SGLI, VGLI, TAMP and other deadlines", icon: "hourglass", color: .red, kind: .tool, keywords: ["deadline", "sgli", "vgli", "tamp", "enrollment", "countdown"], body: "SGLI VGLI TAMP enrollment deadline countdown", destination: .route(.benefitsCountdown)),
            SearchItem(id: "t.badges", title: "Achievement Badges", subtitle: "Earn badges as you progress", icon: "rosette", color: AppTheme.gold, kind: .tool, keywords: ["achievement", "badge", "reward", "gamification"], body: "Achievement badges progress reward", destination: .route(.achievementBadges)),
        ]
    }

    // MARK: Guides (high-level guides surfaced as searchable nav targets)

    private var guideEntries: [SearchItem] {
        [
            SearchItem(id: "g.mindsetShifts", title: "Mindset Shifts", subtitle: "Reframe your thinking from military to civilian", icon: "brain.fill", color: .indigo, kind: .guideContent, keywords: ["mindset", "identity", "culture", "transition"], body: "Mindset shifts identity culture communication daily life relationships", destination: .article(.mindsetShifts)),
            SearchItem(id: "g.playbook", title: "Civilian Playbook", subtitle: "Unwritten rules of civilian life", icon: "book.closed.fill", color: .blue, kind: .guideContent, keywords: ["playbook", "civilian", "norms", "rules"], body: "Civilian playbook workplace norms communication social money daily life", destination: .article(.civilianPlaybook)),
            SearchItem(id: "g.first30", title: "First 30 Days Guide", subtitle: "Week-by-week separation plan", icon: "flag.fill", color: AppTheme.gold, kind: .guideContent, keywords: ["first 30", "separation", "checklist", "30 days"], body: "First 30 days week by week checklist after separation", destination: .article(.firstThirtyDays)),
            SearchItem(id: "g.firstYear", title: "First Year Guide", subtitle: "Quarter-by-quarter after service", icon: "calendar", color: .purple, kind: .guideContent, keywords: ["first year", "after service", "month", "quarter"], body: "First year quarter by quarter roadmap", destination: .article(.firstYear(.q1))),
            SearchItem(id: "g.career", title: "Career Planning", subtitle: "Resume, networking, and career path", icon: "briefcase.fill", color: .teal, kind: .guideContent, keywords: ["career", "job", "resume"], body: "Career planning resume networking", destination: .route(.career)),
            SearchItem(id: "g.education", title: "Education Planning", subtitle: "GI Bill, VR&E, scholarships, and how to fund school", icon: "graduationcap.fill", color: .blue, kind: .guideContent, keywords: ["education", "gi bill", "vre", "yellow ribbon", "school", "college", "trade", "fafsa"], body: "Education planning GI Bill VRE Yellow Ribbon FAFSA", destination: .route(.education)),
            SearchItem(id: "g.family", title: "Family & Relocation", subtitle: "Move, spouse employment, kids", icon: "house.fill", color: .pink, kind: .guideContent, keywords: ["family", "spouse", "move", "relocation", "kids"], body: "Family relocation spouse employment kids", destination: .route(.family)),
            SearchItem(id: "g.financial", title: "Financial Planning", subtitle: "Budget, insurance, taxes", icon: "dollarsign.circle.fill", color: AppTheme.gold, kind: .guideContent, keywords: ["finance", "budget", "sgli", "vgli", "insurance", "tax"], body: "Financial planning budget insurance taxes", destination: .route(.financial)),
            SearchItem(id: "g.selfAssessment", title: "Self-Assessment", subtitle: "Score your readiness across categories", icon: "checkmark.seal.fill", color: AppTheme.forestGreen, kind: .guideContent, keywords: ["assessment", "readiness", "quiz"], body: "Self assessment readiness score", destination: .route(.selfAssessment)),
            SearchItem(id: "g.documents", title: "Documents Vault", subtitle: "Store DD214 and key paperwork", icon: "folder.fill", color: .orange, kind: .guideContent, keywords: ["dd214", "documents", "paperwork", "vault"], body: "Documents vault DD214 paperwork", destination: .route(.documents)),
            SearchItem(id: "g.mentor", title: "Mentor Tracker", subtitle: "Track mentors and outreach", icon: "person.crop.circle.badge.checkmark", color: .blue, kind: .guideContent, keywords: ["mentor", "contacts"], body: "Mentor tracker contacts outreach", destination: .route(.mentorTracker)),
            SearchItem(id: "g.finalGear", title: "Final Gear Check", subtitle: "Pre-separation final review", icon: "checklist", color: .pink, kind: .guideContent, keywords: ["gear check", "final", "checklist"], body: "Final gear check pre separation review", destination: .route(.finalGearCheck)),
            SearchItem(id: "g.readiness", title: "Readiness Dashboard", subtitle: "Your overall readiness score", icon: "gauge.medium", color: AppTheme.forestGreen, kind: .guideContent, keywords: ["readiness", "dashboard", "score"], body: "Readiness dashboard score", destination: .route(.readiness)),
        ]
    }

    // MARK: Benefits — each VA/military benefit category becomes a search result

    private var benefitItems: [SearchItem] {
        storage.benefitCategories.map { cat in
            SearchItem(
                id: "b.\(cat.id)",
                title: cat.type.rawValue,
                subtitle: cat.type.teaser,
                icon: cat.type.icon,
                color: cat.type.accentColor,
                kind: .benefit,
                keywords: benefitKeywords(for: cat.type),
                body: cat.overview + " " + cat.whyItMatters + " " + cat.eligibilityFactors.joined(separator: " "),
                destination: .benefit(cat.id)
            )
        }
    }

    private func benefitKeywords(for type: BenefitCategoryType) -> [String] {
        switch type {
        case .healthCare: return ["health", "tricare", "va care", "doctor", "medical", "healthcare"]
        case .disabilityClaims: return ["disability", "claim", "va disability", "rating", "compensation", "service connected"]
        case .educationTraining: return ["education", "gi bill", "training", "school", "college", "scholarship", "fafsa", "yellow ribbon"]
        case .careerReset: return ["vre", "voc rehab", "vocational", "career", "training", "stipend", "chapter 31"]
        case .employmentResume: return ["employment", "resume", "job", "career", "hiring"]
        case .housingHomeLoan: return ["housing", "home loan", "va loan", "mortgage", "house", "buying"]
        case .insurance: return ["insurance", "sgli", "vgli", "life insurance", "tsgli"]
        case .familyDependents: return ["family", "dependents", "spouse", "kids", "deers", "fry", "chapter 35"]
        case .financesBudget: return ["finance", "budget", "tsp", "money", "savings"]
        case .recordsAdmin: return ["records", "dd214", "dd 214", "admin", "paperwork", "archives"]
        case .communityCrisis: return ["crisis", "community", "veterans crisis line", "peer", "support", "988"]
        }
    }

    // MARK: Articles — Mindset Shifts, Civilian Playbook entries, First Year quarters

    private var articleItems: [SearchItem] {
        var items: [SearchItem] = []

        // Individual mindset shifts
        for shift in TransitionDataService.mindsetShifts() {
            items.append(
                SearchItem(
                    id: "a.shift.\(shift.id)",
                    title: shift.title,
                    subtitle: shift.category.rawValue,
                    icon: mindsetIcon(for: shift.category),
                    color: mindsetColor(for: shift.category),
                    kind: .article,
                    keywords: ["mindset", shift.category.rawValue.lowercased()],
                    body: shift.militaryMindset + " " + shift.civilianMindset + " " + shift.insight,
                    destination: .article(.mindsetShift(shift.id))
                )
            )
        }

        // Civilian Playbook sections
        let playbookSections: [(String, String, Color, String)] = [
            ("Workplace Norms", "building.2.fill", .teal, "Civilian workplace meetings emails dress code feedback diplomatic tone"),
            ("Communication", "bubble.left.and.bubble.right.fill", .blue, "Soften delivery acronyms small talk conflict resolution"),
            ("Social Dynamics", "person.2.fill", .pink, "Frame of reference thank you for your service camaraderie friendships"),
            ("Money & Benefits", "dollarsign.circle.fill", .orange, "Negotiate salary total compensation tax free allowances"),
            ("Daily Life", "clock.fill", .purple, "Routine wake up applications rest productive"),
        ]
        for (title, icon, color, body) in playbookSections {
            items.append(
                SearchItem(
                    id: "a.playbook.\(title)",
                    title: title,
                    subtitle: "Civilian Playbook",
                    icon: icon,
                    color: color,
                    kind: .article,
                    keywords: ["playbook", "civilian"],
                    body: body,
                    destination: .article(.civilianPlaybook)
                )
            )
        }

        // First Year quarters
        let quarters: [(YearQuarter, String, String, String)] = [
            (.q1, "Stabilize & Settle", "Months 1–3", "Health enrollment income employment unemployment dd214 disability claim family routine"),
            (.q2, "Build Momentum", "Months 4–6", "Career networking certifications budget emergency fund tsp insurance sgli vgli identity purpose"),
            (.q3, "Optimize & Grow", "Months 7–9", "Career growth mentor financial optimization credit score va loan health check community"),
            (.q4, "Reflect & Plan Ahead", "Months 10–12", "Year one review estate planning beneficiaries year two goals mindset"),
        ]
        for (q, title, months, body) in quarters {
            items.append(
                SearchItem(
                    id: "a.year.\(q.rawValue)",
                    title: "First Year · \(title)",
                    subtitle: months,
                    icon: "calendar",
                    color: .purple,
                    kind: .article,
                    keywords: ["first year", q.rawValue.lowercased(), "after service"],
                    body: body,
                    destination: .article(.firstYear(q))
                )
            )
        }

        // First 30 Days
        items.append(
            SearchItem(
                id: "a.first30",
                title: "First 30 Days Plan",
                subtitle: "Week-by-week separation checklist",
                icon: "flag.fill",
                color: AppTheme.gold,
                kind: .article,
                keywords: ["30 days", "first 30", "separation week"],
                body: "First thirty days after separation week by week checklist",
                destination: .article(.firstThirtyDays)
            )
        )

        return items
    }

    private func mindsetIcon(for c: MindsetCategory) -> String {
        switch c {
        case .identity: "person.fill"
        case .culture: "building.2.fill"
        case .communication: "bubble.left.and.bubble.right.fill"
        case .dailyLife: "clock.fill"
        case .relationships: "person.2.fill"
        }
    }

    private func mindsetColor(for c: MindsetCategory) -> Color {
        switch c {
        case .identity: .purple
        case .culture: .teal
        case .communication: .blue
        case .dailyLife: .orange
        case .relationships: .pink
        }
    }

    // MARK: Aggregate

    private var allItems: [SearchItem] {
        moneyTools + careerTools + planningTools + guideEntries + benefitItems + articleItems
    }

    private var trimmedQuery: String {
        searchText.trimmingCharacters(in: .whitespaces)
    }

    private var searchResults: [SearchItem] {
        guard isSearching else { return [] }
        let q = trimmedQuery
        return allItems.filter { item in
            item.title.localizedStandardContains(q) ||
            item.subtitle.localizedStandardContains(q) ||
            item.body.localizedStandardContains(q) ||
            item.keywords.contains(where: { $0.localizedStandardContains(q) })
        }
    }

    private var groupedResults: [(SearchKind, [SearchItem])] {
        SearchKind.allCases.compactMap { kind in
            let items = searchResults.filter { $0.kind == kind }
            return items.isEmpty ? nil : (kind, items)
        }
    }

    private let popularSearches: [String] = [
        "Resume", "Interview", "TSP", "Budget", "GI Bill", "TRICARE", "SGLI", "VA Loan", "Mindset", "BAH",
    ]

    private var recentItems: [SearchItem] {
        let used = storage.toolsUsedIds
        guard !used.isEmpty else { return [] }
        let candidates = moneyTools + careerTools + planningTools
        // Match by a normalized id mapping. We use last segment of item.id.
        return candidates.filter { item in
            let suffix = item.id.split(separator: ".").last.map(String.init) ?? item.id
            return used.contains(suffix)
        }
    }

    // MARK: Body

    var body: some View {
        NavigationStack(path: $navPath) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    if isSearching {
                        searchResultsSection
                    } else {
                        browseSection
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 100)
            }
            .background(Color(.systemGroupedBackground))
            .keyboardDoneToolbar()
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search tools, guides, benefits & topics")
            .navigationTitle("Search")
            .navigationDestination(for: PlanningRoute.self) { route in
                routeDestination(route)
            }
            .navigationDestination(for: ArticleRoute.self) { route in
                articleDestination(route)
            }
            .navigationDestination(for: String.self) { benefitId in
                if let category = storage.benefitCategories.first(where: { $0.id == benefitId }) {
                    BenefitDetailView(storage: storage, category: category)
                }
            }
            .sheet(item: $activeSheet) { sheet in
                sheetContent(sheet)
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView(store: store)
            }
        }
    }

    // MARK: Browse

    private var browseSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            if !recentItems.isEmpty {
                recentSection
            }
            popularSection
            categoryGroupsSection
        }
    }

    private var recentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "clock.arrow.circlepath")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.secondary)
                Text("Recently Viewed")
                    .font(.headline.weight(.bold))
            }
            VStack(spacing: 0) {
                ForEach(Array(recentItems.prefix(4).enumerated()), id: \.element.id) { index, item in
                    resultRow(item, showsTag: true)
                    if index < min(recentItems.count, 4) - 1 {
                        Divider().padding(.leading, 58)
                    }
                }
            }
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))
        }
    }

    private var popularSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(AppTheme.gold)
                Text("Popular Searches")
                    .font(.headline.weight(.bold))
            }

            FlowLayout(spacing: 8) {
                ForEach(popularSearches, id: \.self) { term in
                    Button {
                        searchText = term
                        searchFocused = true
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "magnifyingglass")
                                .font(.caption2.weight(.bold))
                            Text(term)
                                .font(.caption.weight(.bold))
                        }
                        .foregroundStyle(.primary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var categoryGroupsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            categoryGroup(title: "Tools", icon: "wrench.and.screwdriver.fill", color: AppTheme.forestGreen, items: moneyTools + careerTools + planningTools)
            categoryGroup(title: "Guides", icon: "book.fill", color: .indigo, items: guideEntries)
            categoryGroup(title: "Benefits", icon: "shield.lefthalf.filled", color: .blue, items: benefitItems)
            categoryGroup(title: "Articles", icon: "doc.text.fill", color: .purple, items: articleItems)
        }
    }

    private func categoryGroup(title: String, icon: String, color: Color, items: [SearchItem]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(color)
                Text(title)
                    .font(.headline.weight(.bold))
                Spacer()
                Text("\(items.count)")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 0) {
                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                    resultRow(item)
                    if index < items.count - 1 {
                        Divider().padding(.leading, 58)
                    }
                }
            }
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))
        }
    }

    // MARK: Results

    private var searchResultsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            if searchResults.isEmpty {
                emptyResultsView
            } else {
                Text("\(searchResults.count) result\(searchResults.count == 1 ? "" : "s")")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)

                ForEach(groupedResults, id: \.0) { kind, items in
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(spacing: 8) {
                            Image(systemName: kind.icon)
                                .font(.subheadline.weight(.bold))
                                .foregroundStyle(kind.color)
                            Text(kind.sectionLabel)
                                .font(.headline.weight(.bold))
                            Spacer()
                            Text("\(items.count)")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(.secondary)
                        }
                        VStack(spacing: 0) {
                            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                                resultRow(item, showsTag: false)
                                if index < items.count - 1 {
                                    Divider().padding(.leading, 58)
                                }
                            }
                        }
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(.rect(cornerRadius: 14))
                    }
                }
            }
        }
    }

    private var emptyResultsView: some View {
        VStack(spacing: 16) {
            ContentUnavailableView.search(text: trimmedQuery)
                .frame(minHeight: 200)

            VStack(alignment: .leading, spacing: 10) {
                Text("Try one of these")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                FlowLayout(spacing: 8) {
                    ForEach(popularSearches, id: \.self) { term in
                        Button {
                            searchText = term
                        } label: {
                            Text(term)
                                .font(.caption.weight(.bold))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color(.secondarySystemGroupedBackground))
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private func resultRow(_ item: SearchItem, showsTag: Bool = true) -> some View {
        Button {
            handle(item)
        } label: {
            HStack(spacing: 12) {
                Image(systemName: item.icon)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(item.color)
                    .frame(width: 32, height: 32)
                    .background(item.color.opacity(0.12))
                    .clipShape(.rect(cornerRadius: 8))

                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Text(item.title)
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(.primary)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                        if showsTag {
                            Text(item.kind.rawValue.uppercased())
                                .font(.system(size: 9, weight: .heavy))
                                .tracking(0.6)
                                .foregroundStyle(item.kind.color)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(item.kind.color.opacity(0.12))
                                .clipShape(Capsule())
                        }
                    }
                    Text(item.subtitle)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 0)
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.tertiary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    // MARK: Actions

    private func handle(_ item: SearchItem) {
        // If this is a tool and locked, show paywall.
        if item.kind == .tool && store.isToolLocked(item.title) {
            showPaywall = true
            return
        }
        switch item.destination {
        case .route(let r): navPath.append(r)
        case .sheet(let s): activeSheet = s
        case .benefit(let id): navPath.append(id)
        case .article(let a): navPath.append(a)
        }
    }

    // MARK: Routing

    @ViewBuilder
    private func routeDestination(_ route: PlanningRoute) -> some View {
        switch route {
        case .career: CareerPlanningView(storage: storage)
        case .education: EducationPlanningView(storage: storage)
        case .family: FamilyPlanningView()
        case .financial: FinancialPlanningView()
        case .readiness: ReadinessDashboardView(storage: storage)
        case .roadmap: RoadmapView(storage: storage)
        case .firstThirtyDays: FirstThirtyDaysView()
        case .mindsetShifts: MindsetShiftsView()
        case .civilianPlaybook: CivilianPlaybookView()
        case .selfAssessment: SelfAssessmentView(storage: storage)
        case .finalGearCheck: FinalGearCheckView(storage: storage)
        case .mentorTracker: MentorTrackerView(storage: storage)
        case .documents: DocumentsView(storage: storage)
        case .tspRollover: TSPRolloverView()
        case .salaryNegotiation: SalaryNegotiationView()
        case .costOfLiving: CostOfLivingView()
        case .resumeTranslator: ResumeTranslatorView()
        case .interviewPrep: InterviewPrepView(storage: storage)
        case .networkingScorecard: NetworkingScorecardView(storage: storage)
        case .skillsInventory: SkillsInventoryView()
        case .giBillBAH: GIBillBAHCalculatorView()
        case .educationComparison: EducationBenefitComparisonView()
        case .relocationCost: RelocationCostView()
        case .stateBenefits: StateBenefitsFinderView()
        case .transitionJournal: TransitionJournalView(storage: storage)
        case .goalTracker: GoalTrackerView(storage: storage)
        case .weeklyCheckIn: WeeklyCheckInView(storage: storage)
        case .elevatorPitch: ElevatorPitchBuilderView(storage: storage)
        case .jargonTranslator: CivilianJargonTranslatorView()
        case .jobOfferCompare: JobOfferComparisonView(storage: storage)
        case .decisionMatrix: DecisionMatrixView(storage: storage)
        case .ninetyDayPlanner: NinetyDayPlannerView(storage: storage)
        case .weeklyChallenges: WeeklyChallengesView(storage: storage)
        case .dailyPowerUp: DailyPowerUpView(storage: storage)
        case .networkingEventPrep: NetworkingEventPrepView(storage: storage)
        case .personalBrandAudit: PersonalBrandAuditView(storage: storage)
        case .benefitsCountdown: BenefitsEnrollmentCountdownView(storage: storage)
        case .achievementBadges: AchievementBadgesView(storage: storage)
        case .firstYearGuide: FirstYearGuideView()
        case .tspGrowthEstimator: TSPGrowthEstimatorView()
        case .brsRetirementSnapshot: BRSRetirementSnapshotView()
        case .scraProtections: SCRAProtectionsView()
        case .financialReadiness: FinancialReadinessResourcesView()
        case .vaFundingFee: VAFundingFeeCalculatorView()
        case .vaHomeLoanGuide: VAHomeLoanGuideView()
        }
    }

    @ViewBuilder
    private func articleDestination(_ route: ArticleRoute) -> some View {
        switch route {
        case .mindsetShift(let id):
            MindsetShiftsView(highlightedShiftId: id)
        case .mindsetShifts:
            MindsetShiftsView()
        case .civilianPlaybook:
            CivilianPlaybookView()
        case .firstThirtyDays:
            FirstThirtyDaysView()
        case .firstYear(let q):
            FirstYearGuideView(initialQuarter: q)
        }
    }

    @ViewBuilder
    private func sheetContent(_ sheet: ToolboxSheet) -> some View {
        switch sheet {
        case .compensation: MilitaryCompCalculatorView()
        case .incomeGap: IncomeGapCalculatorView()
        case .civilianBudget: CivilianBudgetCalculatorView()
        case .emergencyFund: EmergencyFundCalculatorView()
        }
    }
}

// MARK: - Simple flow layout for chips

private struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var totalWidth: CGFloat = 0

        for sub in subviews {
            let size = sub.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                y += rowHeight + spacing
                x = 0
                rowHeight = 0
            }
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
            totalWidth = max(totalWidth, x)
        }

        return CGSize(width: maxWidth.isFinite ? maxWidth : totalWidth, height: y + rowHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x: CGFloat = bounds.minX
        var y: CGFloat = bounds.minY
        var rowHeight: CGFloat = 0
        let maxX = bounds.maxX

        for sub in subviews {
            let size = sub.sizeThatFits(.unspecified)
            if x + size.width > maxX, x > bounds.minX {
                y += rowHeight + spacing
                x = bounds.minX
                rowHeight = 0
            }
            sub.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}
