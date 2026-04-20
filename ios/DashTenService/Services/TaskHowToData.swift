import Foundation

nonisolated struct TaskHowTo: Sendable {
    let steps: [String]
    let tip: String?
    let tool: (title: String, route: PlanningRoute)?
}

enum TaskHowToData {
    static func howTo(for itemId: String) -> TaskHowTo? {
        Self.map[itemId]
    }

    static let map: [String: TaskHowTo] = [
        "c1": TaskHowTo(steps: [
            "Contact your installation's transition office to find the next briefing date.",
            "Block the time on your calendar — most briefings run a full day.",
            "Bring a notebook; you'll get a lot of resource contacts at once.",
            "Ask for handouts or slide decks you can review later."
        ], tip: "Even if you've been told it's 'just a briefing,' the networking alone is worth it.", tool: nil),
        "c2": TaskHowTo(steps: [
            "Open the Plan tab and add your separation date in your profile.",
            "List your 3-5 biggest transition goals (job, school, location, etc.).",
            "Work backward from your separation date — assign a milestone to each phase.",
            "Review and adjust every 30 days."
        ], tip: "A written timeline reduces transition anxiety by about half. Write it down.", tool: ("Open Goal Tracker", .goalTracker)),
        "c3": TaskHowTo(steps: [
            "Log in to your service's personnel records portal (e.g. myPay, iPERMS, BOL).",
            "Print or export a copy of your service record.",
            "Check awards, deployments, training, and personal info for accuracy.",
            "Submit a correction request immediately if anything is wrong."
        ], tip: "Errors get much harder to fix after separation. Do this now.", tool: ("Open Documents", .documents)),
        "c4": TaskHowTo(steps: [
            "Identify which education chapter you're eligible for.",
            "Request your Certificate of Eligibility (COE).",
            "Research approved schools and programs you're interested in.",
            "Compare monthly housing allowance by location."
        ], tip: "Benefits can often transfer to a spouse or children — check eligibility early.", tool: ("Compare Education Benefits", .educationComparison)),
        "c5": TaskHowTo(steps: [
            "Calculate your current monthly expenses.",
            "Multiply by 3 to 6 — that's your target emergency fund.",
            "Open a high-yield savings account separate from checking.",
            "Set up automatic transfers every payday."
        ], tip: "Even $50 a paycheck adds up. Automate it and forget it.", tool: ("Open Financial Reset", .financial)),
        "c6": TaskHowTo(steps: [
            "Take a skills inventory — what are you actually good at?",
            "Map your military experience to civilian roles you could step into.",
            "Research salary ranges for 3-5 target roles in your target location.",
            "Talk to 2-3 people already doing those jobs."
        ], tip: "Informational interviews open more doors than cold applications.", tool: ("Open Skills Inventory", .skillsInventory)),
        "c7": TaskHowTo(steps: [
            "Check your base's career readiness calendar for workshops.",
            "Register at least 2 weeks in advance — they fill up.",
            "Bring a draft resume for feedback.",
            "Follow up with instructors afterward — they have employer contacts."
        ], tip: nil, tool: ("Open Resume Translator", .resumeTranslator)),
        "c8": TaskHowTo(steps: [
            "Confirm your health care eligibility before your current coverage ends.",
            "Gather your DD214 (when available) and medical records.",
            "Schedule an enrollment appointment.",
            "If not eligible, research marketplace plans before your TAMP coverage ends."
        ], tip: "Service-connected disabilities typically qualify you for priority enrollment.", tool: nil),
        "c9": TaskHowTo(steps: [
            "Request copies of all treatment records from your military health system.",
            "Include dental, behavioral health, and civilian referrals.",
            "Store digital copies in a secure place (cloud + encrypted backup).",
            "Give a copy to your new primary care provider when you transition."
        ], tip: "Missing records are the #1 reason disability claims get delayed.", tool: ("Open Documents", .documents)),
        "c10": TaskHowTo(steps: [
            "Decide: rent, buy, or stay with family initially?",
            "If buying, get a VA loan pre-qualification — no down payment required.",
            "Research cost of living in 2-3 target cities.",
            "Visit potential neighborhoods if at all possible."
        ], tip: "Your first year is about stability — renting often beats buying until you know you're staying.", tool: ("Open Cost of Living", .costOfLiving)),
        "c11": TaskHowTo(steps: [
            "Use the Resume Translator tool in this app as a starting point.",
            "Quantify everything: people led, budget managed, % improvements.",
            "Remove acronyms — spell out every military term.",
            "Tailor for each job — don't send one generic version."
        ], tip: "Recruiters scan resumes in 6-8 seconds. Front-load your top results.", tool: ("Open Resume Translator", .resumeTranslator)),
        "c12": TaskHowTo(steps: [
            "Note SGLI expires 120 days after separation.",
            "Request a VGLI application — you have 240 days.",
            "Compare VGLI rates with private term life insurance.",
            "Update beneficiaries on any policy you keep."
        ], tip: "Private term life is often cheaper than VGLI if you're healthy.", tool: nil),
        "c13": TaskHowTo(steps: [
            "Schedule a sit-down conversation with your spouse/family.",
            "Cover: location, budget, timeline, expectations for the first year.",
            "Listen more than you talk — this is the #1 relationship stressor in transition.",
            "Revisit the conversation every 30-60 days."
        ], tip: "Most transition-related divorces start with unspoken expectations. Talk it out.", tool: nil),
        "c14": TaskHowTo(steps: [
            "List your top 3 target cities with pros and cons.",
            "Compare cost of living, job market, and family factors.",
            "Confirm housing availability — tour remotely if needed.",
            "Make the decision and commit — indecision is expensive."
        ], tip: nil, tool: ("Open Decision Matrix", .decisionMatrix)),
        "c15": TaskHowTo(steps: [
            "Identify your top 3 programs or schools.",
            "Check application deadlines — many are 6-9 months out.",
            "Gather transcripts, test scores, and recommendation letters.",
            "Submit applications at least 30 days before the deadline."
        ], tip: nil, tool: ("Open Education Planning", .education)),
        "c16": TaskHowTo(steps: [
            "File an Intent to File early to lock in your effective date.",
            "Gather supporting evidence — medical records, statements, nexus letters.",
            "Consider working with an accredited VSO — they're free.",
            "Track your claim progress and respond to any requests quickly."
        ], tip: "The BDD program lets you file 90-180 days before separation.", tool: ("Open Benefits Countdown", .benefitsCountdown)),
        "c17": TaskHowTo(steps: [
            "Set a target: 5 applications and 3 networking touches per week.",
            "Use LinkedIn to connect with 2-3 new industry contacts weekly.",
            "Attend at least one job fair or industry event each month.",
            "Track everything in a simple spreadsheet."
        ], tip: "Most jobs are filled through networking, not applications. Spend 70% of your effort on people.", tool: ("Open Networking Scorecard", .networkingScorecard)),
        "c18": TaskHowTo(steps: [
            "List every monthly expense — rent, food, insurance, subscriptions.",
            "Subtract from estimated civilian take-home pay.",
            "Identify the gap and how long your savings will cover it.",
            "Cut non-essentials now, not after separation."
        ], tip: "Use the Income Gap Planner tool in this app to model this precisely.", tool: ("Open Income Gap Planner", .financial)),
        "c19": TaskHowTo(steps: [
            "Research school districts in your target area.",
            "Check enrollment timelines and required documents.",
            "Visit or tour remotely if possible.",
            "Get on childcare waitlists early — some are 6+ months."
        ], tip: nil, tool: ("Open Family Planning", .family)),
        "c20": TaskHowTo(steps: [
            "Schedule your separation health assessment.",
            "Complete any outstanding dental, vision, and specialty exams.",
            "Request all exam results in writing for your records.",
            "Use these findings as evidence for any claims."
        ], tip: "Every exam you complete while covered is one you don't pay for after.", tool: nil),
        "c21": TaskHowTo(steps: [
            "Confirm your DOS with your admin section.",
            "Verify terminal leave dates.",
            "Get a copy of your orders in writing.",
            "Notify family and employers of the confirmed date."
        ], tip: nil, tool: nil),
        "c22": TaskHowTo(steps: [
            "Schedule medical, dental, and vision exams.",
            "Get copies of all results.",
            "Request referrals for anything needing ongoing treatment.",
            "Stock up on any prescriptions — at least 90 days."
        ], tip: nil, tool: nil),
        "c23": TaskHowTo(steps: [
            "Set up mail forwarding with your postal service.",
            "Update address with bank, IRS, DMV, subscriptions, and employers.",
            "Notify friends and family.",
            "Update voter registration in your new state."
        ], tip: nil, tool: nil),
        "c24": TaskHowTo(steps: [
            "Decide: DITY move, contracted movers, or hybrid?",
            "Schedule movers or rental truck 60+ days out.",
            "Inventory high-value items and photograph them.",
            "Keep receipts — some moving costs are reimbursable."
        ], tip: nil, tool: ("Open Relocation Cost", .relocationCost)),
        "c25": TaskHowTo(steps: [
            "Request a final leave and earnings statement (LES).",
            "Verify leave sell-back, separation pay, and final allowances.",
            "Confirm your final paycheck direct deposit details.",
            "Set aside taxes on any lump-sum payments."
        ], tip: nil, tool: ("Open Financial Reset", .financial)),
        "c26": TaskHowTo(steps: [
            "Get your checkout sheet from your unit admin.",
            "Schedule appointments early — they fill the last two weeks.",
            "Return all equipment, clear housing, turn in ID if required.",
            "Get your DD214 in hand before you walk out the gate."
        ], tip: "Keep at least 10 certified copies of your DD214 — you'll need them for years.", tool: ("Open Final Gear Check", .finalGearCheck)),
        "c27": TaskHowTo(steps: [
            "Review every block of your draft DD214 carefully.",
            "Check dates, awards, MOS, character of service.",
            "Submit corrections via DD Form 149 if anything is wrong.",
            "Store multiple copies — digital, paper, and with a trusted family member."
        ], tip: nil, tool: ("Open Documents", .documents)),
        "c28": TaskHowTo(steps: [
            "Evaluate options: employer plan, marketplace, VA, or spouse's plan.",
            "Compare premiums, deductibles, and network coverage.",
            "Enroll before your TAMP or current coverage ends.",
            "Confirm your prescriptions and doctors are in-network."
        ], tip: "Healthcare gaps are one of the biggest financial risks in transition — don't leave uncovered.", tool: nil),
        "c29": TaskHowTo(steps: [
            "Open a civilian checking and savings account if you don't already have one.",
            "Update direct deposit for any ongoing benefits.",
            "Keep your old account open briefly to catch any final deposits.",
            "Set up at least one credit card to build credit history."
        ], tip: nil, tool: nil),
        "c30": TaskHowTo(steps: [
            "Update or create your will.",
            "Designate power of attorney for health and finance.",
            "Update beneficiaries on every insurance and retirement account.",
            "Store copies securely — physical and digital."
        ], tip: nil, tool: ("Open Documents", .documents)),
        "c31": TaskHowTo(steps: [
            "Confirm your eligibility and gather your DD214.",
            "Complete the enrollment application.",
            "Schedule your first appointment after enrollment.",
            "Bring any prior medical records to the first visit."
        ], tip: nil, tool: nil),
        "c32": TaskHowTo(steps: [
            "Find your state's veteran affairs office.",
            "Complete their registration or ID form.",
            "Ask about state-specific benefits — property tax, education, licensing.",
            "Join their mailing list for updates."
        ], tip: nil, tool: ("Open State Benefits", .stateBenefits)),
        "c33": TaskHowTo(steps: [
            "Visit your state DMV with your DD214.",
            "Request a veteran designation on your license or ID.",
            "Some states waive fees for veterans — ask.",
            "Keep your old ID as backup until the new one arrives."
        ], tip: nil, tool: nil),
        "c34": TaskHowTo(steps: [
            "Gather W-2s and any 1099s or separation pay statements.",
            "Research veteran tax benefits in your state.",
            "Know that disability compensation is tax-free at the federal level.",
            "Use a CPA or a volunteer tax assistance site if unsure."
        ], tip: nil, tool: nil),
        "c35": TaskHowTo(steps: [
            "Find a local American Legion, VFW, or veteran nonprofit.",
            "Attend at least one meeting or event.",
            "Join online veteran communities specific to your interests.",
            "Give back — mentor someone still in."
        ], tip: "Community is the #1 protector against transition isolation.", tool: ("Open Mentor Tracker", .mentorTracker)),
        "c36": TaskHowTo(steps: [
            "Pull 6 months of spending data.",
            "Compare actual vs. budget — where did you leak?",
            "Adjust your budget for the next 6 months.",
            "Increase emergency fund target to 6 months if possible."
        ], tip: nil, tool: ("Open Financial Reset", .financial)),
        "c37": TaskHowTo(steps: [
            "List your career goals from when you separated.",
            "Honestly rate your progress on each.",
            "Identify what's working, what's not, what to pivot.",
            "Set new 6-month goals."
        ], tip: nil, tool: ("Open Goal Tracker", .goalTracker)),
        "c38": TaskHowTo(steps: [
            "Check your claim status through your benefits portal.",
            "Follow up if nothing has moved in 60 days.",
            "Submit any additional evidence requested.",
            "Consider an accredited VSO if you're stuck."
        ], tip: nil, tool: nil),
        "c39": TaskHowTo(steps: [
            "Request a degree audit from your school.",
            "Confirm benefit payments are processing correctly.",
            "Adjust course load if you're overwhelmed or under-challenged.",
            "Use tutoring, writing centers, and veteran student services."
        ], tip: nil, tool: ("Open Education Planning", .education)),
        "c40": TaskHowTo(steps: [
            "Schedule annual physical and any specialty follow-ups.",
            "Review medications and refills.",
            "Update mental health check-in — even if you feel fine.",
            "Review dependents' care if applicable."
        ], tip: nil, tool: nil),
    ]
}
