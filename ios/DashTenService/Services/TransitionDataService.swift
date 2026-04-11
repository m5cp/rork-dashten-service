import Foundation

enum TransitionDataService {
    static func defaultChecklist() -> [ChecklistItem] {
        var items: [ChecklistItem] = []

        let phase18 = TimelinePhase.eighteenToTwentyFour
        items.append(contentsOf: [
            ChecklistItem(id: "c1", title: "Attend initial transition briefing", subtitle: "Learn about available resources and programs", phase: phase18, readinessCategory: .admin),
            ChecklistItem(id: "c2", title: "Create a transition timeline", subtitle: "Map out key dates and milestones", phase: phase18, readinessCategory: .admin),
            ChecklistItem(id: "c3", title: "Review service record for accuracy", subtitle: "Check for errors or missing entries", phase: phase18, readinessCategory: .admin),
            ChecklistItem(id: "c4", title: "Begin researching education benefits", subtitle: "Understand eligibility and options", phase: phase18, readinessCategory: .education),
            ChecklistItem(id: "c5", title: "Start building an emergency fund", subtitle: "Target 3-6 months of expenses", phase: phase18, readinessCategory: .finance),
            ChecklistItem(id: "c6", title: "Research potential career fields", subtitle: "Identify civilian roles matching your skills", phase: phase18, readinessCategory: .employment),
        ])

        let phase12 = TimelinePhase.twelveMonths
        items.append(contentsOf: [
            ChecklistItem(id: "c7", title: "Attend a career skills workshop", subtitle: "Resume writing, interviewing, networking", phase: phase12, readinessCategory: .employment),
            ChecklistItem(id: "c8", title: "Schedule a health care enrollment review", subtitle: "Understand your eligibility before you separate", phase: phase12, readinessCategory: .health),
            ChecklistItem(id: "c9", title: "Begin gathering medical records", subtitle: "Request copies of all treatment records", phase: phase12, readinessCategory: .health),
            ChecklistItem(id: "c10", title: "Research housing options", subtitle: "Explore home loan eligibility and rental markets", phase: phase12, readinessCategory: .housing),
            ChecklistItem(id: "c11", title: "Create or update your resume", subtitle: "Translate military experience to civilian language", phase: phase12, readinessCategory: .employment),
            ChecklistItem(id: "c12", title: "Review life insurance transition options", subtitle: "Understand conversion deadlines", phase: phase12, readinessCategory: .finance),
            ChecklistItem(id: "c13", title: "Discuss transition plan with family", subtitle: "Align on goals, location, and budget", phase: phase12, readinessCategory: .family),
        ])

        let phase6 = TimelinePhase.sixMonths
        items.append(contentsOf: [
            ChecklistItem(id: "c14", title: "Finalize post-service location", subtitle: "Choose where you'll live after separation", phase: phase6, readinessCategory: .housing),
            ChecklistItem(id: "c15", title: "Apply to schools or training programs", subtitle: "Submit applications before deadlines", phase: phase6, readinessCategory: .education),
            ChecklistItem(id: "c16", title: "File disability-related claims if applicable", subtitle: "Don't wait — processing takes time", phase: phase6, readinessCategory: .health),
            ChecklistItem(id: "c17", title: "Begin active job search or networking", subtitle: "Attend job fairs and reach out to contacts", phase: phase6, readinessCategory: .employment),
            ChecklistItem(id: "c18", title: "Review and update budget for civilian income", subtitle: "Account for income changes and new expenses", phase: phase6, readinessCategory: .finance),
            ChecklistItem(id: "c19", title: "Research childcare and school options", subtitle: "If relocating with children", phase: phase6, readinessCategory: .family),
            ChecklistItem(id: "c20", title: "Schedule required medical exams", subtitle: "Complete while still covered", phase: phase6, readinessCategory: .health),
        ])

        let phase90 = TimelinePhase.ninetyDays
        items.append(contentsOf: [
            ChecklistItem(id: "c21", title: "Confirm separation date and orders", subtitle: "Verify with your admin office", phase: phase90, readinessCategory: .admin),
            ChecklistItem(id: "c22", title: "Complete final medical and dental exams", subtitle: "Last chance for covered care", phase: phase90, readinessCategory: .health),
            ChecklistItem(id: "c23", title: "Set up mail forwarding", subtitle: "Update address with USPS and important contacts", phase: phase90, readinessCategory: .admin),
            ChecklistItem(id: "c24", title: "Begin household move planning", subtitle: "Schedule movers or transportation", phase: phase90, readinessCategory: .housing),
            ChecklistItem(id: "c25", title: "Review final pay and benefits", subtitle: "Understand last paycheck, leave balance, and entitlements", phase: phase90, readinessCategory: .finance),
        ])

        let phase30 = TimelinePhase.thirtyDays
        items.append(contentsOf: [
            ChecklistItem(id: "c26", title: "Complete installation checkout", subtitle: "Return equipment, clear housing, turn in ID if required", phase: phase30, readinessCategory: .admin),
            ChecklistItem(id: "c27", title: "Verify DD214 information", subtitle: "Ensure accuracy before it's finalized", phase: phase30, readinessCategory: .admin),
            ChecklistItem(id: "c28", title: "Set up civilian health insurance", subtitle: "Enroll in health coverage through employer, marketplace, or veteran program", phase: phase30, readinessCategory: .health),
            ChecklistItem(id: "c29", title: "Open or verify civilian bank accounts", subtitle: "Ensure payroll and benefits can be deposited", phase: phase30, readinessCategory: .finance),
            ChecklistItem(id: "c30", title: "Update legal documents", subtitle: "Will, power of attorney, beneficiaries", phase: phase30, readinessCategory: .admin),
        ])

        let phaseFirst90 = TimelinePhase.firstNinety
        items.append(contentsOf: [
            ChecklistItem(id: "c31", title: "Enroll in veteran health care if eligible", subtitle: "Research eligibility and enroll through official channels", phase: phaseFirst90, readinessCategory: .health),
            ChecklistItem(id: "c32", title: "Register with your state's veteran services office", subtitle: "Access state-level benefits", phase: phaseFirst90, readinessCategory: .admin),
            ChecklistItem(id: "c33", title: "Apply for state veteran ID or driver's license", subtitle: "Many states offer veteran designation", phase: phaseFirst90, readinessCategory: .admin),
            ChecklistItem(id: "c34", title: "File taxes with veteran-specific considerations", subtitle: "Understand what income is taxable", phase: phaseFirst90, readinessCategory: .finance),
            ChecklistItem(id: "c35", title: "Connect with local veteran organizations", subtitle: "Build your civilian support network", phase: phaseFirst90, readinessCategory: .family),
        ])

        let phaseYear = TimelinePhase.firstYear
        items.append(contentsOf: [
            ChecklistItem(id: "c36", title: "Review and adjust financial plan", subtitle: "Six-month check on budget and savings", phase: phaseYear, readinessCategory: .finance),
            ChecklistItem(id: "c37", title: "Evaluate career progress", subtitle: "Are you on track with your goals?", phase: phaseYear, readinessCategory: .employment),
            ChecklistItem(id: "c38", title: "Follow up on pending claims or applications", subtitle: "Check status of any submitted claims", phase: phaseYear, readinessCategory: .health),
            ChecklistItem(id: "c39", title: "Review education progress if enrolled", subtitle: "Ensure benefits are being applied correctly", phase: phaseYear, readinessCategory: .education),
            ChecklistItem(id: "c40", title: "Schedule annual health check-up", subtitle: "Maintain continuity of care", phase: phaseYear, readinessCategory: .health),
        ])

        return items
    }

    static func defaultDocuments() -> [DocumentItem] {
        [
            DocumentItem(id: "d1", name: "DD214 (Certificate of Release)", category: .serviceRecords),
            DocumentItem(id: "d2", name: "Service Record Brief / ERB / ORB", category: .serviceRecords),
            DocumentItem(id: "d3", name: "Last 5 Evaluations (NCOERs / OERs / Fitness Reports)", category: .evaluationsAwards),
            DocumentItem(id: "d4", name: "Awards and Decorations Summary", category: .evaluationsAwards),
            DocumentItem(id: "d5", name: "Training Certificates and Transcripts", category: .certificationsTranscripts),
            DocumentItem(id: "d6", name: "Joint Services Transcript (JST)", category: .certificationsTranscripts),
            DocumentItem(id: "d7", name: "College Transcripts", category: .certificationsTranscripts),
            DocumentItem(id: "d8", name: "Medical Treatment Records", category: .medicalRecords),
            DocumentItem(id: "d9", name: "Dental Records", category: .medicalRecords),
            DocumentItem(id: "d10", name: "Mental Health Records (if applicable)", category: .medicalRecords),
            DocumentItem(id: "d11", name: "Separation Physical Results", category: .medicalRecords),
            DocumentItem(id: "d12", name: "Disability Claim Documentation", category: .benefitRecords),
            DocumentItem(id: "d13", name: "Health Care Enrollment Confirmation", category: .benefitRecords),
            DocumentItem(id: "d14", name: "Certificate of Eligibility (Home Loan)", category: .benefitRecords),
            DocumentItem(id: "d15", name: "Education Benefits Statement", category: .benefitRecords),
            DocumentItem(id: "d16", name: "Civilian Resume (Updated)", category: .employmentDocs),
            DocumentItem(id: "d17", name: "LinkedIn Profile (Updated)", category: .employmentDocs),
            DocumentItem(id: "d18", name: "Professional References List", category: .employmentDocs),
            DocumentItem(id: "d19", name: "Security Clearance Verification", category: .employmentDocs),
            DocumentItem(id: "d20", name: "Marriage Certificate", category: .dependentDocs),
            DocumentItem(id: "d21", name: "Birth Certificates (Children)", category: .dependentDocs),
            DocumentItem(id: "d22", name: "Spouse Resume (if applicable)", category: .dependentDocs),
            DocumentItem(id: "d23", name: "Power of Attorney", category: .dependentDocs),
            DocumentItem(id: "d24", name: "Last 3 Years Tax Returns", category: .financeTaxDocs),
            DocumentItem(id: "d25", name: "W-2 Forms (Last 3 Years)", category: .financeTaxDocs),
            DocumentItem(id: "d26", name: "TSP Account Statement", category: .financeTaxDocs),
            DocumentItem(id: "d27", name: "Life Insurance Policy Documents", category: .financeTaxDocs),
            DocumentItem(id: "d28", name: "State Driver's License", category: .serviceRecords),
            DocumentItem(id: "d29", name: "Social Security Card", category: .serviceRecords),
            DocumentItem(id: "d30", name: "Passport (Current)", category: .serviceRecords),
        ]
    }

    static func defaultBenefits() -> [BenefitCategory] {
        [
            BenefitCategory(
                id: "b1",
                type: .healthCare,
                overview: "After military service, you may be eligible for comprehensive health care including primary care, mental health services, prescriptions, and specialty care. Enrollment is based on priority groups determined by service-connected conditions, income, and other factors.",
                whyItMatters: "Health care is one of the most valuable benefits available. Many veterans don't realize they're eligible or wait too long to enroll. Getting set up early ensures continuity of care after separation.",
                eligibilityFactors: [
                    "Served on active duty and received an honorable or general discharge",
                    "Service-connected disability rating may qualify you for higher priority",
                    "Combat veterans may receive 5 years of enhanced eligibility",
                    "Income-based eligibility for those without service-connected conditions"
                ],
                requiredDocuments: [
                    "DD214 or equivalent separation document",
                    "Health Benefits Application (Form 10-10EZ)",
                    "Insurance information (if applicable)",
                    "Financial information for means test"
                ],
                commonMistakes: [
                    "Waiting until after separation to begin enrollment",
                    "Not bringing complete medical records to initial appointments",
                    "Assuming you're not eligible without checking",
                    "Not enrolling in dental separately (dental coverage is a separate program)"
                ],
                questionsToAsk: [
                    "What priority group would I fall into?",
                    "Are there any enrollment deadlines I should be aware of?",
                    "What happens to my health coverage during the transition gap?",
                    "Can my dependents receive health care through veteran programs?"
                ],
                officialLink: "https://www.healthcare.gov/",
                actionItems: [
                    BenefitAction(id: "ba1", title: "Research post-service health care eligibility"),
                    BenefitAction(id: "ba2", title: "Gather required documents"),
                    BenefitAction(id: "ba3", title: "Complete health benefits application"),
                    BenefitAction(id: "ba4", title: "Locate nearest medical facility"),
                    BenefitAction(id: "ba5", title: "Schedule initial appointment"),
                ],
                isStarted: false,
                isSaved: false
            ),
            BenefitCategory(
                id: "b2",
                type: .disabilityClaims,
                overview: "If you have health conditions related to your military service, you may be eligible for disability compensation. This is a tax-free monthly payment based on your disability rating. Filing before or shortly after separation is critical.",
                whyItMatters: "Disability compensation can provide crucial financial support and access to additional benefits. The claims process can take months, so starting early is essential.",
                eligibilityFactors: [
                    "Current medical condition connected to military service",
                    "Condition documented in service medical records",
                    "Condition worsened by military service (aggravation)",
                    "Presumptive conditions for certain service eras"
                ],
                requiredDocuments: [
                    "DD214",
                    "Complete service medical records",
                    "Private medical records supporting your claim",
                    "Buddy statements from fellow service members",
                    "Disability compensation application (Form 21-526EZ)"
                ],
                commonMistakes: [
                    "Not claiming all conditions — even ones you think are minor",
                    "Missing the Benefits Delivery at Discharge (BDD) window",
                    "Not getting a nexus letter connecting conditions to service",
                    "Relying solely on official exams without submitting supporting evidence"
                ],
                questionsToAsk: [
                    "Am I within the BDD filing window (180-90 days before separation)?",
                    "Should I work with a Veterans Service Organization (VSO)?",
                    "What conditions should I document before separating?",
                    "How do I request my complete medical records?"
                ],
                officialLink: "https://www.benefits.gov/benefit/4868",
                actionItems: [
                    BenefitAction(id: "ba6", title: "Review all medical conditions from service"),
                    BenefitAction(id: "ba7", title: "Request complete service medical records"),
                    BenefitAction(id: "ba8", title: "Contact a veteran service organization for guidance"),
                    BenefitAction(id: "ba9", title: "File initial claim or intent to file"),
                    BenefitAction(id: "ba10", title: "Attend all scheduled examinations"),
                ],
                isStarted: false,
                isSaved: false
            ),
            BenefitCategory(
                id: "b3",
                type: .educationTraining,
                overview: "Education benefits can help you pay for college, graduate school, trade programs, certifications, and on-the-job training. The most well-known is the Post-9/11 GI Bill, but other programs exist depending on your service era and goals.",
                whyItMatters: "Education benefits represent tens of thousands of dollars in tuition, housing, and book stipends. Understanding your options helps you make the best choice for your career goals.",
                eligibilityFactors: [
                    "At least 90 days of aggregate active duty service after 9/10/2001",
                    "Honorable discharge",
                    "Benefit level based on months of active duty service",
                    "May transfer unused benefits to dependents (if eligible)"
                ],
                requiredDocuments: [
                    "DD214",
                    "Certificate of Eligibility (COE)",
                    "School acceptance letter",
                    "Prior college transcripts (if applicable)"
                ],
                commonMistakes: [
                    "Not comparing education benefit chapters to find the best fit",
                    "Using benefits at a school that isn't approved for veteran education benefits",
                    "Not understanding the housing allowance calculation",
                    "Forgetting about the book and supply stipend"
                ],
                questionsToAsk: [
                    "How many months of benefits do I have?",
                    "Can I transfer benefits to my spouse or children?",
                    "Is my intended school/program approved for veteran education benefits?",
                    "What is the monthly housing allowance for my school's ZIP code?"
                ],
                officialLink: "https://www.benefits.gov/benefit/4769",
                actionItems: [
                    BenefitAction(id: "ba11", title: "Determine which education benefit applies to you"),
                    BenefitAction(id: "ba12", title: "Request your Certificate of Eligibility"),
                    BenefitAction(id: "ba13", title: "Research approved schools and programs"),
                    BenefitAction(id: "ba14", title: "Apply to schools or training programs"),
                    BenefitAction(id: "ba15", title: "Submit enrollment certification"),
                ],
                isStarted: false,
                isSaved: false
            ),
            BenefitCategory(
                id: "b4",
                type: .careerReset,
                overview: "Career readiness and employment programs help veterans with service-connected disabilities prepare for, obtain, and maintain suitable employment. This can include education, training, resume development, job coaching, and more.",
                whyItMatters: "Career readiness programs can cover tuition, books, supplies, and provide a monthly subsistence allowance — sometimes even after education benefits are exhausted. These are among the most underused veteran benefits.",
                eligibilityFactors: [
                    "Service-connected disability rating of at least 10%",
                    "Received a discharge other than dishonorable",
                    "An employment handicap determination by a career counselor",
                    "Applied within 12 years of notification of disability rating"
                ],
                requiredDocuments: [
                    "DD214",
                    "Disability rating letter",
                    "Career readiness application (Form 28-1900)",
                    "Resume or employment history"
                ],
                commonMistakes: [
                    "Assuming career readiness programs are only for severely disabled veterans",
                    "Not knowing you can use career programs after exhausting education benefits",
                    "Skipping the initial counseling appointment",
                    "Not having a clear career goal when meeting your counselor"
                ],
                questionsToAsk: [
                    "Am I eligible based on my current disability rating?",
                    "Can I use career readiness programs for self-employment or starting a business?",
                    "What support services are available beyond tuition?",
                    "How do career readiness programs interact with my education benefits?"
                ],
                officialLink: "https://www.benefits.gov/benefit/5886",
                actionItems: [
                    BenefitAction(id: "ba16", title: "Check eligibility based on disability rating"),
                    BenefitAction(id: "ba17", title: "Complete career readiness application"),
                    BenefitAction(id: "ba18", title: "Schedule initial counseling appointment"),
                    BenefitAction(id: "ba19", title: "Prepare career goals for counselor meeting"),
                ],
                isStarted: false,
                isSaved: false
            ),
            BenefitCategory(
                id: "b5",
                type: .employmentResume,
                overview: "Transitioning from military to civilian employment requires translating your experience, building a network, and understanding civilian workplace culture. Multiple resources exist to help with job search, resume writing, and interview preparation.",
                whyItMatters: "Employment is the foundation of financial stability after service. Starting your job search early and building civilian-ready skills gives you the best outcomes.",
                eligibilityFactors: [
                    "Available to all separating and recently separated service members",
                    "Some programs have timeline requirements",
                    "Veterans' preference applies to federal jobs",
                    "State-level employment assistance varies by location"
                ],
                requiredDocuments: [
                    "Civilian resume (military-to-civilian translated)",
                    "DD214 (for veterans' preference)",
                    "Professional references",
                    "Certifications and training records"
                ],
                commonMistakes: [
                    "Using military jargon on civilian resumes",
                    "Not networking before separation",
                    "Undervaluing leadership and management experience",
                    "Waiting until after separation to begin job searching",
                    "Assuming military rank translates to equivalent civilian seniority",
                    "Not obtaining civilian certifications or licenses for your field"
                ],
                questionsToAsk: [
                    "How do I translate my MOS/AFSC/NEC to civilian job titles?",
                    "What is veterans' preference and how do I claim it?",
                    "Are there veteran-friendly employers in my target industry?",
                    "What career fairs are available for transitioning service members?"
                ],
                officialLink: "https://www.dol.gov/agencies/vets",
                actionItems: [
                    BenefitAction(id: "ba20", title: "Create a civilian-ready resume"),
                    BenefitAction(id: "ba21", title: "Set up LinkedIn profile"),
                    BenefitAction(id: "ba22", title: "Practice civilian interview skills"),
                    BenefitAction(id: "ba23", title: "Research target companies and industries"),
                    BenefitAction(id: "ba24", title: "Attend a job fair or networking event"),
                ],
                isStarted: false,
                isSaved: false
            ),
            BenefitCategory(
                id: "b6",
                type: .housingHomeLoan,
                overview: "The veteran home loan benefit helps eligible veterans purchase, build, or refinance a home with favorable terms including no down payment, no private mortgage insurance, and competitive interest rates.",
                whyItMatters: "Housing is likely your biggest expense. The veteran home loan can save tens of thousands of dollars over the life of a mortgage. Understanding eligibility early helps you plan.",
                eligibilityFactors: [
                    "Served 90 consecutive days during wartime or 181 days during peacetime",
                    "Served 6+ years in Guard/Reserve",
                    "Surviving spouse of veteran who died in service or from service-connected disability",
                    "Certificate of Eligibility (COE) required"
                ],
                requiredDocuments: [
                    "DD214",
                    "Certificate of Eligibility request (Form 26-1880)",
                    "Proof of income",
                    "Credit history"
                ],
                commonMistakes: [
                    "Not knowing your COE entitlement amount",
                    "Skipping the appraisal process",
                    "Not comparing veteran loan rates across lenders",
                    "Assuming veteran home loans are only for first-time homebuyers"
                ],
                questionsToAsk: [
                    "What is my remaining home loan entitlement?",
                    "Do I need to pay the funding fee?",
                    "Can I use a veteran home loan for a multi-family property?",
                    "What credit score do approved lenders require?"
                ],
                officialLink: "https://www.benefits.gov/benefit/5574",
                actionItems: [
                    BenefitAction(id: "ba25", title: "Request Certificate of Eligibility"),
                    BenefitAction(id: "ba26", title: "Research approved lenders"),
                    BenefitAction(id: "ba27", title: "Get pre-approved for a veteran home loan"),
                    BenefitAction(id: "ba28", title: "Understand the funding fee"),
                ],
                isStarted: false,
                isSaved: false
            ),
            BenefitCategory(
                id: "b7",
                type: .insurance,
                overview: "During and after service, you have access to life insurance programs that require timely action to maintain or convert. Missing deadlines can mean losing coverage permanently.",
                whyItMatters: "Life insurance conversion deadlines are strict. If you don't act within the required window after separation, you may lose access to affordable coverage.",
                eligibilityFactors: [
                    "SGLI coverage ends 120 days after separation",
                    "VGLI application must be submitted within 240 days (no health evidence needed)",
                    "After 240 days, health evidence required for VGLI",
                    "Traumatic injury coverage (TSGLI) for qualifying injuries"
                ],
                requiredDocuments: [
                    "DD214",
                    "SGLI coverage documentation",
                    "SGLV 8714 (VGLI application form)",
                    "Medical records (if applying after 240 days)"
                ],
                commonMistakes: [
                    "Letting SGLI lapse without converting to VGLI",
                    "Missing the 240-day window for guaranteed VGLI enrollment",
                    "Not comparing VGLI rates with private insurance options",
                    "Forgetting to update beneficiary designations"
                ],
                questionsToAsk: [
                    "When exactly does my SGLI coverage end?",
                    "What are the VGLI premium rates for my age group?",
                    "Should I convert to VGLI or get private life insurance?",
                    "Am I eligible for TSGLI?"
                ],
                officialLink: "https://www.benefits.gov/benefit/4785",
                actionItems: [
                    BenefitAction(id: "ba29", title: "Note your SGLI expiration date"),
                    BenefitAction(id: "ba30", title: "Research VGLI vs. private insurance costs"),
                    BenefitAction(id: "ba31", title: "Apply for VGLI if appropriate"),
                    BenefitAction(id: "ba32", title: "Update all beneficiary designations"),
                ],
                isStarted: false,
                isSaved: false
            ),
            BenefitCategory(
                id: "b8",
                type: .familyDependents,
                overview: "Your family members may be eligible for benefits including education assistance, health care, survivor benefits, and support programs. Planning for their needs is a key part of a successful transition.",
                whyItMatters: "Transition affects your entire family. Understanding dependent benefits helps ensure continuity of support for your spouse, children, and other dependents.",
                eligibilityFactors: [
                    "Spouse and children of eligible veterans",
                    "Dependent education benefits (Chapter 35) tied to disability rating",
                    "Dependent health coverage for families of disabled veterans",
                    "Survivor benefits for dependents of deceased veterans"
                ],
                requiredDocuments: [
                    "Marriage certificate",
                    "Birth certificates of children",
                    "DD214 of the veteran",
                    "Disability rating letter (if applicable)"
                ],
                commonMistakes: [
                    "Not registering dependents for benefits",
                    "Missing DEERS updates during transition",
                    "Not exploring dependent health coverage if eligible",
                    "Overlooking spouse employment assistance programs"
                ],
                questionsToAsk: [
                    "Are my dependents eligible for health coverage?",
                    "Can my spouse or children use education benefits?",
                    "How do I update DEERS after separation?",
                    "What survivor benefits should I set up?"
                ],
                officialLink: "https://www.benefits.gov/benefit/4868",
                actionItems: [
                    BenefitAction(id: "ba33", title: "Update DEERS records"),
                    BenefitAction(id: "ba34", title: "Research dependent health care options"),
                    BenefitAction(id: "ba35", title: "Explore dependent education benefits"),
                    BenefitAction(id: "ba36", title: "Review survivor benefit plan"),
                ],
                isStarted: false,
                isSaved: false
            ),
            BenefitCategory(
                id: "b9",
                type: .financesBudget,
                overview: "Financial planning during transition is critical. Your income, expenses, tax situation, and benefits will all change. Building a post-service budget and understanding your financial landscape prevents common pitfalls.",
                whyItMatters: "Financial stress is one of the top challenges during transition. Planning ahead reduces the shock of income changes and helps you build a stable foundation.",
                eligibilityFactors: [
                    "All separating service members should create a transition budget",
                    "TSP (Thrift Savings Plan) can be maintained, rolled over, or withdrawn",
                    "Some states offer tax benefits for veteran income",
                    "Disability compensation is tax-free"
                ],
                requiredDocuments: [
                    "Leave and Earnings Statement (LES)",
                    "TSP account statements",
                    "Tax returns (last 3 years)",
                    "Debt and credit reports"
                ],
                commonMistakes: [
                    "Not accounting for the loss of BAH, BAS, and other allowances",
                    "Withdrawing TSP funds early and paying penalties",
                    "Not building an emergency fund before separation",
                    "Underestimating civilian cost of living in target location"
                ],
                questionsToAsk: [
                    "What will my income gap be between separation and first civilian paycheck?",
                    "Should I roll over my TSP to an IRA?",
                    "What tax benefits are available to veterans in my state?",
                    "How do I calculate my total civilian compensation needs?"
                ],
                officialLink: "https://www.consumerfinance.gov/consumer-tools/educator-tools/servicemembers/",
                actionItems: [
                    BenefitAction(id: "ba37", title: "Create post-separation budget"),
                    BenefitAction(id: "ba38", title: "Review TSP options and make a plan"),
                    BenefitAction(id: "ba39", title: "Build emergency fund (3-6 months)"),
                    BenefitAction(id: "ba40", title: "Pull credit report and review"),
                    BenefitAction(id: "ba41", title: "Research state tax benefits for veterans"),
                ],
                isStarted: false,
                isSaved: false
            ),
            BenefitCategory(
                id: "b10",
                type: .recordsAdmin,
                overview: "Your military records are the foundation for accessing nearly every veteran benefit. Ensuring they are complete, accurate, and in your possession before separation prevents delays and complications down the road.",
                whyItMatters: "Missing or inaccurate records can delay disability claims, education benefits, and employment verification. Getting everything organized while you still have easy access saves enormous headaches later.",
                eligibilityFactors: [
                    "All service members should request records before separation",
                    "Records requests after separation go through National Archives",
                    "Post-separation requests can take months to process",
                    "Some records may be difficult to obtain after discharge"
                ],
                requiredDocuments: [
                    "DD214 (multiple certified copies recommended)",
                    "Complete service record",
                    "Medical and dental records",
                    "Training records and certificates"
                ],
                commonMistakes: [
                    "Only getting one copy of DD214",
                    "Not reviewing DD214 for errors before signing",
                    "Assuming records will be easy to get after separation",
                    "Not saving digital copies of everything"
                ],
                questionsToAsk: [
                    "How many certified copies of my DD214 should I get?",
                    "How do I correct errors on my DD214?",
                    "Where will my records be stored after separation?",
                    "How do I request records after separation?"
                ],
                officialLink: "https://www.archives.gov/veterans",
                actionItems: [
                    BenefitAction(id: "ba42", title: "Request multiple certified DD214 copies"),
                    BenefitAction(id: "ba43", title: "Review DD214 for accuracy"),
                    BenefitAction(id: "ba44", title: "Save digital copies of all records"),
                    BenefitAction(id: "ba45", title: "Request complete medical records"),
                ],
                isStarted: false,
                isSaved: false
            ),
            BenefitCategory(
                id: "b11",
                type: .communityCrisis,
                overview: "The transition period can be challenging. Connecting with community support, veteran organizations, and knowing how to access crisis resources is important for long-term wellbeing.",
                whyItMatters: "Isolation is one of the biggest risks during transition. Building connections and knowing where to turn in difficult moments can make a critical difference.",
                eligibilityFactors: [
                    "988 Suicide & Crisis Lifeline is available to everyone",
                    "Readjustment counseling centers offer free support",
                    "Many non-profit organizations serve veterans and families",
                    "State and local programs vary by location"
                ],
                requiredDocuments: [
                    "No documents needed for crisis resources",
                    "DD214 may be needed for some community programs",
                    "Health care enrollment for certain services"
                ],
                commonMistakes: [
                    "Thinking asking for help is a sign of weakness",
                    "Not knowing readjustment counseling centers exist",
                    "Waiting until crisis to find resources",
                    "Not connecting with local veteran community"
                ],
                questionsToAsk: [
                    "Where is my nearest counseling or support center?",
                    "What veteran organizations are active in my area?",
                    "Are there peer support groups near me?",
                    "What crisis resources are available 24/7?"
                ],
                officialLink: "https://988lifeline.org/",
                actionItems: [
                    BenefitAction(id: "ba46", title: "Save 988 Suicide & Crisis Lifeline number"),
                    BenefitAction(id: "ba47", title: "Locate nearest counseling or support center"),
                    BenefitAction(id: "ba48", title: "Research local veteran organizations"),
                    BenefitAction(id: "ba49", title: "Connect with at least one community group"),
                ],
                isStarted: false,
                isSaved: false
            ),
        ]
    }

    static func insightCards() -> [InsightCard] {
        [
            InsightCard(title: "Start Earlier Than You Think", body: "Most people say they wish they had started transition planning at least 12 months out. The earlier you begin, the less stressful the final months become.", category: .wishIKnew),
            InsightCard(title: "Your DD214 Is Everything", body: "This single document unlocks nearly every veteran benefit. Get multiple certified copies and verify every line before signing. Errors can take months to fix.", category: .wishIKnew),
            InsightCard(title: "Civilian Time Moves Differently", body: "In the military, things happen on schedule. In the civilian world, job searches, claims, and applications can take much longer than expected. Build in buffer time.", category: .wishIKnew),
            InsightCard(title: "Your Network Is Your Lifeline", body: "Start building civilian connections before you separate. LinkedIn, veteran organizations, and informational interviews are more powerful than cold applications.", category: .wishIKnew),
            InsightCard(title: "Waiting Too Long to File Claims", body: "Many veterans wait years to file disability claims. If you have service-connected conditions, start the process before or immediately after separation.", category: .commonMistake),
            InsightCard(title: "Not Using All Available Benefits", body: "Many veterans don't know about career readiness programs, state benefits, or health care eligibility. Research everything — you've earned it.", category: .commonMistake),
            InsightCard(title: "Underestimating the Budget Gap", body: "The loss of BAH, BAS, and other allowances can be shocking. Build a realistic civilian budget before your last paycheck.", category: .commonMistake),
            InsightCard(title: "Going It Alone", body: "Transition is hard. Not connecting with veteran organizations, mentors, or support systems is one of the most common mistakes. You don't have to figure it all out yourself.", category: .commonMistake),
            InsightCard(title: "Service Medical Records", body: "Request your complete medical records while you're still in. After separation, getting these can take months through the National Archives.", category: .forgottenDoc),
            InsightCard(title: "Joint Services Transcript", body: "Your JST translates military training to college credits. Many veterans don't even know it exists. Get it before you separate.", category: .forgottenDoc),
            InsightCard(title: "Security Clearance Verification", body: "If you have an active security clearance, get documentation. This can be extremely valuable for civilian employment.", category: .forgottenDoc),
            InsightCard(title: "Buddy Statements", body: "Written statements from fellow service members supporting disability claims. Get these while you're still in contact with your unit.", category: .forgottenDoc),
            InsightCard(title: "Veteran Health Care Enrollment", body: "Did you know combat veterans get 5 years of enhanced eligibility? Don't wait — enroll early and ensure continuity of care.", category: .benefitSpotlight),
            InsightCard(title: "Veterans' Preference for Federal Jobs", body: "Your military service gives you hiring preference for federal positions. Learn how to claim it on USAJobs.gov.", category: .benefitSpotlight),
            InsightCard(title: "Veteran Home Loan: No Down Payment", body: "The veteran home loan benefit lets you buy a home with no down payment and no PMI. It's one of the most valuable benefits you have.", category: .benefitSpotlight),
        ]
    }

    static func crisisResources() -> [CrisisResource] {
        [
            CrisisResource(title: "988 Suicide & Crisis Lifeline", subtitle: "Free, confidential support 24/7 for veterans, service members, and their families", phoneNumber: "988", textLine: "838255", url: "https://www.veteranscrisisline.net/", icon: "phone.fill", isEmergency: true),
            CrisisResource(title: "Crisis Text Line", subtitle: "Text HOME to 741741 for free crisis support", textLine: "741741", url: "https://www.crisistextline.org/", icon: "message.fill", isEmergency: true),
            CrisisResource(title: "National Suicide Prevention Lifeline", subtitle: "Call or text 988 for immediate help", phoneNumber: "988", url: "https://988lifeline.org/", icon: "heart.fill", isEmergency: true),
            CrisisResource(title: "SAMHSA National Helpline", subtitle: "Free referrals for substance abuse and mental health", phoneNumber: "1-800-662-4357", url: "https://www.samhsa.gov/find-help/national-helpline", icon: "cross.case.fill"),
        ]
    }

    static func mindsetShifts() -> [MindsetShift] {
        [
            MindsetShift(
                id: "ms1",
                title: "Identity Beyond the Uniform",
                militaryMindset: "I am my rank and role. My identity is tied to my unit and mission.",
                civilianMindset: "I am more than my job title. My identity includes my values, interests, relationships, and goals.",
                insight: "Losing the structure of military identity is one of the hardest parts of transition. Give yourself permission to explore who you are outside of service. It takes time — and that's completely normal.",
                category: .identity
            ),
            MindsetShift(
                id: "ms2",
                title: "Purpose After the Mission",
                militaryMindset: "My purpose was clear every day — the mission came first.",
                civilianMindset: "I get to define my own purpose now. It can be family, career, community, or something entirely new.",
                insight: "Many people describe feeling adrift after leaving service. Building a new sense of purpose is a process, not a switch. Start small — volunteer, mentor, or pursue something you've always been curious about.",
                category: .identity
            ),
            MindsetShift(
                id: "ms3",
                title: "Daily Structure",
                militaryMindset: "My day was planned for me — PT, formations, duty hours, chow.",
                civilianMindset: "I own my schedule now. Building my own routine is a skill I need to develop.",
                insight: "The sudden absence of externally imposed structure can feel liberating and terrifying at the same time. Create your own morning routine, set weekly goals, and protect your productive hours.",
                category: .dailyLife
            ),
            MindsetShift(
                id: "ms4",
                title: "Communication Styles",
                militaryMindset: "Direct, brief, assertive. Say what needs to be said. Time is limited.",
                civilianMindset: "Civilian workplaces often value diplomacy, context, and collaborative language.",
                insight: "Your directness is a strength — but in some civilian settings, it can be misread as aggressive or dismissive. Practice adding context to requests and asking for input before giving directives.",
                category: .communication
            ),
            MindsetShift(
                id: "ms5",
                title: "Hierarchy vs. Flat Teams",
                militaryMindset: "Chain of command is everything. Respect flows through rank.",
                civilianMindset: "Many workplaces use flat or matrixed teams. Input is expected from everyone regardless of seniority.",
                insight: "You may find yourself in meetings where a junior employee challenges a VP — and that's normal. Civilian authority is often earned through expertise, not position. Be ready to collaborate as an equal.",
                category: .culture
            ),
            MindsetShift(
                id: "ms6",
                title: "Feedback Culture",
                militaryMindset: "Feedback is direct, immediate, and sometimes harsh. You adapt or you don't.",
                civilianMindset: "Feedback cycles are slower, more nuanced, and often delivered in 1-on-1s or annual reviews.",
                insight: "If you're used to immediate corrective feedback, civilian workplaces may feel frustratingly vague. Ask for feedback proactively and be specific about what you want to improve.",
                category: .culture
            ),
            MindsetShift(
                id: "ms7",
                title: "Accountability Differences",
                militaryMindset: "If the standard isn't met, someone is held accountable — immediately.",
                civilianMindset: "Accountability varies widely. Some workplaces are rigorous, others are... flexible.",
                insight: "You may be frustrated by what seems like a lack of accountability. Channel that energy into leading by example rather than trying to impose military standards on a civilian team.",
                category: .culture
            ),
            MindsetShift(
                id: "ms8",
                title: "Asking for Help",
                militaryMindset: "Self-reliance is valued. Asking for help can feel like admitting weakness.",
                civilianMindset: "Successful civilians build networks and ask for help constantly. It's called being resourceful.",
                insight: "The strongest thing you can do during transition is ask for help. Reach out to mentors, join communities, and don't try to figure everything out alone.",
                category: .relationships
            ),
            MindsetShift(
                id: "ms9",
                title: "Professional Networking",
                militaryMindset: "Connections happen naturally through units, deployments, and shared experiences.",
                civilianMindset: "You have to intentionally build and maintain a professional network.",
                insight: "Networking feels unnatural to many transitioning service members. Start by reconnecting with people who've already made the jump. They understand your experience and can open doors.",
                category: .relationships
            ),
            MindsetShift(
                id: "ms10",
                title: "Work-Life Boundaries",
                militaryMindset: "The mission comes first. Personal time is what's left over.",
                civilianMindset: "Healthy boundaries between work and personal life are expected and respected.",
                insight: "You don't have to be available 24/7 anymore. Setting boundaries isn't being lazy — it's being sustainable. Protect your time for family, hobbies, and rest.",
                category: .dailyLife
            ),
        ]
    }

    static func assessmentQuestions() -> [AssessmentQuestion] {
        [
            AssessmentQuestion(id: "aq1", question: "How confident are you in your post-service career plan?", category: .employment, options: [
                AssessmentOption(id: "aq1a", label: "No plan yet", score: 0),
                AssessmentOption(id: "aq1b", label: "Some ideas but nothing concrete", score: 1),
                AssessmentOption(id: "aq1c", label: "Clear direction, working on it", score: 2),
                AssessmentOption(id: "aq1d", label: "Plan is set and in motion", score: 3),
            ]),
            AssessmentQuestion(id: "aq2", question: "Have you started building a civilian resume?", category: .employment, options: [
                AssessmentOption(id: "aq2a", label: "Haven't started", score: 0),
                AssessmentOption(id: "aq2b", label: "Started but it needs work", score: 1),
                AssessmentOption(id: "aq2c", label: "Draft is complete", score: 2),
                AssessmentOption(id: "aq2d", label: "Polished and reviewed by others", score: 3),
            ]),
            AssessmentQuestion(id: "aq3", question: "How prepared are you financially for the transition?", category: .finance, options: [
                AssessmentOption(id: "aq3a", label: "Haven't thought about it", score: 0),
                AssessmentOption(id: "aq3b", label: "Aware of the gap but no plan", score: 1),
                AssessmentOption(id: "aq3c", label: "Budget created, building savings", score: 2),
                AssessmentOption(id: "aq3d", label: "Emergency fund ready, budget set", score: 3),
            ]),
            AssessmentQuestion(id: "aq4", question: "Do you know what health care options are available to you after service?", category: .health, options: [
                AssessmentOption(id: "aq4a", label: "No idea", score: 0),
                AssessmentOption(id: "aq4b", label: "Vaguely aware", score: 1),
                AssessmentOption(id: "aq4c", label: "Researched options", score: 2),
                AssessmentOption(id: "aq4d", label: "Enrolled or plan in place", score: 3),
            ]),
            AssessmentQuestion(id: "aq5", question: "How organized are your service and personal records?", category: .admin, options: [
                AssessmentOption(id: "aq5a", label: "Scattered or missing", score: 0),
                AssessmentOption(id: "aq5b", label: "Some gathered, gaps remain", score: 1),
                AssessmentOption(id: "aq5c", label: "Most records in hand", score: 2),
                AssessmentOption(id: "aq5d", label: "Everything organized and verified", score: 3),
            ]),
            AssessmentQuestion(id: "aq6", question: "Do you have a post-service housing plan?", category: .housing, options: [
                AssessmentOption(id: "aq6a", label: "No plan yet", score: 0),
                AssessmentOption(id: "aq6b", label: "Researching areas", score: 1),
                AssessmentOption(id: "aq6c", label: "Location chosen, searching", score: 2),
                AssessmentOption(id: "aq6d", label: "Housing secured", score: 3),
            ]),
            AssessmentQuestion(id: "aq7", question: "Have you explored education or training options?", category: .education, options: [
                AssessmentOption(id: "aq7a", label: "Not applicable or not started", score: 0),
                AssessmentOption(id: "aq7b", label: "Browsing options", score: 1),
                AssessmentOption(id: "aq7c", label: "Applied or enrolled", score: 2),
                AssessmentOption(id: "aq7d", label: "Enrolled and benefits confirmed", score: 3),
            ]),
            AssessmentQuestion(id: "aq8", question: "How is your family prepared for the transition?", category: .family, options: [
                AssessmentOption(id: "aq8a", label: "Haven't discussed it", score: 0),
                AssessmentOption(id: "aq8b", label: "Talked about it, no actions yet", score: 1),
                AssessmentOption(id: "aq8c", label: "Plan in place, working on it", score: 2),
                AssessmentOption(id: "aq8d", label: "Family is aligned and ready", score: 3),
            ]),
            AssessmentQuestion(id: "aq9", question: "Do you have a civilian support network or mentor?", category: .employment, options: [
                AssessmentOption(id: "aq9a", label: "No civilian connections", score: 0),
                AssessmentOption(id: "aq9b", label: "A few contacts", score: 1),
                AssessmentOption(id: "aq9c", label: "Active network growing", score: 2),
                AssessmentOption(id: "aq9d", label: "Strong network with mentors", score: 3),
            ]),
            AssessmentQuestion(id: "aq10", question: "How would you rate your emotional readiness for this change?", category: .health, options: [
                AssessmentOption(id: "aq10a", label: "Overwhelmed or avoiding it", score: 0),
                AssessmentOption(id: "aq10b", label: "Anxious but working through it", score: 1),
                AssessmentOption(id: "aq10c", label: "Cautiously optimistic", score: 2),
                AssessmentOption(id: "aq10d", label: "Confident and motivated", score: 3),
            ]),
        ]
    }
}
