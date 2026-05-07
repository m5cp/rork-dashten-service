import Foundation

nonisolated struct BenefitActionHowTo: Sendable {
    let steps: [String]
    let link: HowToLink?
}

nonisolated struct HowToLink: Sendable {
    let title: String
    let url: String
}

enum BenefitActionHowToData {
    static func howTo(for actionId: String) -> BenefitActionHowTo? {
        map[actionId]
    }

    static let map: [String: BenefitActionHowTo] = [
        // MARK: - Health Care (b1)
        "ba1": BenefitActionHowTo(steps: [
            "Visit VA.gov and use the Health Benefits Explorer to confirm eligibility.",
            "Identify your priority group (1–8) — this determines copays and access.",
            "Note that combat veterans get 5 years of enhanced eligibility from separation.",
            "Save a screenshot or PDF of your eligibility summary for your records."
        ], link: HowToLink(title: "VA Health Benefits Explorer", url: "https://www.va.gov/health-care/eligibility/")),
        "ba2": BenefitActionHowTo(steps: [
            "Pull a copy of your DD-214 (Member-4 copy) — keep both digital and paper.",
            "Gather any current health insurance cards and dependent info.",
            "Collect your most recent service medical record summary if available.",
            "Save them in one folder labeled 'VA Health Enrollment'."
        ], link: nil),
        "ba3": BenefitActionHowTo(steps: [
            "Go to VA.gov and sign in with Login.gov or ID.me.",
            "Open the 'Apply for VA Health Care' page and start Form 10-10EZ.",
            "Fill in service dates, income, and dependents — save progress as you go.",
            "Submit and screenshot the confirmation number."
        ], link: HowToLink(title: "Apply for VA Health Care (10-10EZ)", url: "https://www.va.gov/health-care/apply/application/")),
        "ba4": BenefitActionHowTo(steps: [
            "Use the VA Facility Locator on VA.gov to find clinics near your future address.",
            "Filter by services you'll need (primary care, mental health, dental).",
            "Save the address, phone, and clinic hours to your phone.",
            "Call ahead to confirm they're accepting new patients."
        ], link: HowToLink(title: "VA Facility Locator", url: "https://www.va.gov/find-locations/")),
        "ba5": BenefitActionHowTo(steps: [
            "Once enrolled, call your assigned VA medical center to schedule.",
            "Ask for a 'new patient orientation' or 'first appointment' visit.",
            "Bring your DD-214, ID, and a list of current medications.",
            "Show up 20 minutes early for paperwork."
        ], link: nil),

        // MARK: - Disability (b2)
        "ba6": BenefitActionHowTo(steps: [
            "Make a list of every injury, condition, or symptom from your service — even small ones.",
            "Note dates, locations, and any sick-call or treatment events.",
            "Don't filter yourself — you can claim everything related to service.",
            "Keep this list as your master claim sheet."
        ], link: nil),
        "ba7": BenefitActionHowTo(steps: [
            "While still in, request your full STR (Service Treatment Records) from your medical clinic.",
            "After separation, use eVetRecs or NPRC to request copies.",
            "Get them in PDF form so you can attach to your VA claim.",
            "Verify all years of service are present."
        ], link: HowToLink(title: "Request Records (eVetRecs)", url: "https://www.archives.gov/veterans/military-service-records")),
        "ba8": BenefitActionHowTo(steps: [
            "Search the VA's accredited representative directory for a VSO (DAV, VFW, AL, etc.).",
            "Schedule a free consultation — VSOs do not charge for help.",
            "Bring your master claim list and STR.",
            "Sign Form 21-22 to authorize them to represent you."
        ], link: HowToLink(title: "Find a VSO", url: "https://www.va.gov/ogc/apps/accreditation/")),
        "ba9": BenefitActionHowTo(steps: [
            "On VA.gov, click 'File a Claim for Disability Compensation.'",
            "Start with an 'Intent to File' to lock in your effective date today.",
            "Submit Form 21-526EZ with your conditions and supporting evidence.",
            "Use the BDD program if you're 90–180 days from separation."
        ], link: HowToLink(title: "File VA Disability Claim", url: "https://www.va.gov/disability/how-to-file-claim/")),
        "ba10": BenefitActionHowTo(steps: [
            "Watch your mail and VA.gov messages for C&P exam letters.",
            "Show up to every exam — missed exams kill claims.",
            "Be honest about your worst day, not your best day.",
            "Take notes after each exam for your records."
        ], link: nil),

        // MARK: - Education (b3)
        "ba11": BenefitActionHowTo(steps: [
            "Compare Post-9/11 GI Bill (Ch 33), Montgomery (Ch 30), and VR&E (Ch 31).",
            "Use the GI Bill Comparison Tool on VA.gov to estimate benefits.",
            "Consider transferring benefits to a spouse/child if you're still in.",
            "Pick the chapter that maximizes your situation."
        ], link: HowToLink(title: "GI Bill Comparison Tool", url: "https://www.va.gov/education/gi-bill-comparison-tool/")),
        "ba12": BenefitActionHowTo(steps: [
            "On VA.gov, apply for education benefits using Form 22-1990.",
            "You'll receive your Certificate of Eligibility (COE) by mail in 2–4 weeks.",
            "Save digital and paper copies of the COE.",
            "Bring it to your school's VA certifying official."
        ], link: HowToLink(title: "Apply for Education Benefits", url: "https://www.va.gov/education/how-to-apply/")),
        "ba13": BenefitActionHowTo(steps: [
            "Use the GI Bill Comparison Tool to filter approved programs.",
            "Check Yellow Ribbon participation for private schools.",
            "Compare housing allowance (BAH) by ZIP code.",
            "Shortlist 3–5 programs and request info packets."
        ], link: HowToLink(title: "GI Bill Comparison Tool", url: "https://www.va.gov/education/gi-bill-comparison-tool/")),
        "ba14": BenefitActionHowTo(steps: [
            "Submit applications including transcripts and any required test scores.",
            "Mention your veteran status — many schools have dedicated support offices.",
            "Apply for FAFSA too, even with GI Bill, to unlock additional grants.",
            "Track deadlines in a spreadsheet."
        ], link: nil),
        "ba15": BenefitActionHowTo(steps: [
            "Once accepted, meet with the school's VA School Certifying Official (SCO).",
            "Submit your COE and class schedule for certification.",
            "Confirm housing allowance and book stipend payment dates.",
            "Set up direct deposit on VA.gov."
        ], link: nil),

        // MARK: - Career Reset / VR&E (b4)
        "ba16": BenefitActionHowTo(steps: [
            "Confirm you have at least a 10% service-connected disability rating.",
            "Check your discharge type (other than dishonorable required).",
            "Apply within 12 years of your rating notification.",
            "Don't assume you're not eligible — apply and let VA decide."
        ], link: HowToLink(title: "VR&E Eligibility", url: "https://www.va.gov/careers-employment/vocational-rehabilitation/")),
        "ba17": BenefitActionHowTo(steps: [
            "Apply online through VA.gov using Form 28-1900.",
            "Provide your DD-214, rating letter, and current resume.",
            "Submit and wait 2–4 weeks for counselor assignment.",
            "Watch for the appointment letter."
        ], link: HowToLink(title: "Apply for VR&E (28-1900)", url: "https://www.va.gov/careers-employment/vocational-rehabilitation/how-to-apply/")),
        "ba18": BenefitActionHowTo(steps: [
            "Once a counselor is assigned, schedule the orientation/eligibility meeting.",
            "Bring your DD-214, rating letter, and resume.",
            "Discuss your career goals and barriers.",
            "Leave with a written next-step plan."
        ], link: nil),
        "ba19": BenefitActionHowTo(steps: [
            "Write down 1–3 specific careers you want to pursue.",
            "Research salary, education needed, and local demand.",
            "Be ready to explain how your disability impacts past or future work.",
            "Bring questions about tuition, books, and subsistence allowance."
        ], link: nil),

        // MARK: - Employment / Resume (b5)
        "ba20": BenefitActionHowTo(steps: [
            "Pull your evaluations, awards, and JST for raw material.",
            "Translate every MOS task into civilian language — no acronyms.",
            "Quantify everything: people led, dollars managed, missions completed.",
            "Use the in-app Resume Translator to speed this up."
        ], link: nil),
        "ba21": BenefitActionHowTo(steps: [
            "Create a profile on a major professional networking site using your civilian-translated resume.",
            "Add a professional headshot — no uniform.",
            "Connect with 50+ veterans and recruiters in your target industry.",
            "Mark yourself as open to new opportunities (privately to recruiters)."
        ], link: nil),
        "ba22": BenefitActionHowTo(steps: [
            "Practice the STAR method (Situation, Task, Action, Result) on 10 common questions.",
            "Record yourself answering — watch and refine.",
            "Do at least 2 mock interviews with a veteran mentor.",
            "Prepare 3 thoughtful questions to ask the interviewer."
        ], link: nil),
        "ba23": BenefitActionHowTo(steps: [
            "Pick 10 target companies in your desired industry and location.",
            "Research their veteran hiring programs — most large employers have them.",
            "Identify 1–2 people at each company through professional networking sites.",
            "Set up news alerts so you stay current on each company."
        ], link: nil),
        "ba24": BenefitActionHowTo(steps: [
            "Find veteran hiring events, career fairs, and local TAP-hosted events in your area.",
            "Pre-register and review the employer list before going.",
            "Bring 20+ printed resumes and dress one level up.",
            "Follow up within 48 hours with a thank-you message."
        ], link: nil),

        // MARK: - Home Loan (b6)
        "ba25": BenefitActionHowTo(steps: [
            "Apply through VA.gov or have a lender pull it electronically.",
            "Submit Form 26-1880 with your DD-214 if applying directly.",
            "Most COEs are issued in minutes if records are clean.",
            "Save the COE PDF for your lender."
        ], link: HowToLink(title: "Request VA Home Loan COE", url: "https://www.va.gov/housing-assistance/home-loans/how-to-request-coe/")),
        "ba26": BenefitActionHowTo(steps: [
            "Get rate quotes from at least 3 VA-approved lenders.",
            "Compare APR, lender fees, and origination charges — not just the headline rate.",
            "Read reviews specifically from veteran borrowers.",
            "Avoid lenders that pressure you to act immediately."
        ], link: nil),
        "ba27": BenefitActionHowTo(steps: [
            "Pull your credit report and clean up any errors first.",
            "Provide W-2s, pay stubs, and bank statements to your chosen lender.",
            "Get a written pre-approval letter (not just pre-qualification).",
            "Lock the rate when you're ready to make offers."
        ], link: nil),
        "ba28": BenefitActionHowTo(steps: [
            "Check your funding fee % based on first-use vs. subsequent use.",
            "Veterans with a service-connected rating of 10%+ are exempt.",
            "Ask your lender if you qualify for a refund of a previously paid fee.",
            "Decide whether to roll the fee into the loan or pay upfront."
        ], link: HowToLink(title: "VA Funding Fee Info", url: "https://www.va.gov/housing-assistance/home-loans/funding-fee-and-closing-costs/")),

        // MARK: - Insurance / SGLI/VGLI (b7)
        "ba29": BenefitActionHowTo(steps: [
            "Calculate: SGLI ends 120 days after your separation date.",
            "Add it to your phone's calendar with a 30-day warning.",
            "VGLI is automatic only if you do nothing for 240 days — but health questions kick in.",
            "Apply within 240 days for guaranteed acceptance."
        ], link: HowToLink(title: "SGLI/VGLI Info", url: "https://www.benefits.va.gov/insurance/vgli.asp")),
        "ba30": BenefitActionHowTo(steps: [
            "Get VGLI premium quotes for your age bracket on the VA insurance site.",
            "Get 3 quotes from private term life insurers (e.g. 20-year level term).",
            "Compare apples-to-apples for the same coverage amount.",
            "Choose what fits — VGLI is convenient, private term is often cheaper for healthy people."
        ], link: nil),
        "ba31": BenefitActionHowTo(steps: [
            "Apply online through the VA's Office of Servicemembers' Group Life Insurance.",
            "Apply within 240 days of separation to skip health questions.",
            "Set up auto-pay so coverage doesn't lapse.",
            "Save your policy number."
        ], link: HowToLink(title: "Apply for VGLI", url: "https://www.benefits.va.gov/insurance/vgli.asp")),
        "ba32": BenefitActionHowTo(steps: [
            "List every account: SGLI/VGLI, TSP, IRA, 401(k), bank, life insurance.",
            "Confirm primary and contingent beneficiaries on each.",
            "Update after big life events (marriage, divorce, kids).",
            "Tell your beneficiaries what they're listed on."
        ], link: nil),

        // MARK: - Family / Dependents (b8)
        "ba33": BenefitActionHowTo(steps: [
            "Visit a DEERS office or use milConnect to verify dependent info.",
            "Add or update spouse, children, and any other dependents.",
            "Bring marriage certificates and birth certificates.",
            "DEERS errors block almost every other family benefit — fix immediately."
        ], link: HowToLink(title: "milConnect (DEERS)", url: "https://milconnect.dmdc.osd.mil/milconnect/")),
        "ba34": BenefitActionHowTo(steps: [
            "Research CHAMPVA if you have a 100% service-connected rating.",
            "Compare Tricare options if retiring.",
            "Check ACA Marketplace plans as a backup.",
            "Don't let coverage lapse during the transition."
        ], link: HowToLink(title: "CHAMPVA Info", url: "https://www.va.gov/health-care/family-caregiver-benefits/champva/")),
        "ba35": BenefitActionHowTo(steps: [
            "Check eligibility for Chapter 35 (DEA) for dependents of disabled veterans.",
            "Consider transferring Post-9/11 GI Bill benefits BEFORE separation.",
            "Look into the Fry Scholarship if applicable.",
            "Apply via VA.gov using Form 22-5490."
        ], link: HowToLink(title: "Dependent Education Benefits", url: "https://www.va.gov/education/survivor-dependent-benefits/")),
        "ba36": BenefitActionHowTo(steps: [
            "Review Survivor Benefit Plan (SBP) elections during retirement counseling.",
            "Understand the cost vs. benefit for your spouse.",
            "Research VA Dependency and Indemnity Compensation (DIC) eligibility.",
            "Document your decision in writing."
        ], link: nil),

        // MARK: - Finance (b9)
        "ba37": BenefitActionHowTo(steps: [
            "List all current military income (base pay, BAH, BAS, specials).",
            "Subtract everything that goes away after separation.",
            "Build a new monthly budget against expected civilian income.",
            "Use the in-app Income Gap Calculator to model the gap."
        ], link: nil),
        "ba38": BenefitActionHowTo(steps: [
            "Decide: leave in TSP, roll to IRA, or roll to a new employer plan.",
            "Avoid early withdrawal — it triggers tax + 10% penalty.",
            "Review your fund allocation against your timeline.",
            "Set up auto-contributions in your new account if rolling over."
        ], link: HowToLink(title: "TSP", url: "https://www.tsp.gov/")),
        "ba39": BenefitActionHowTo(steps: [
            "Multiply monthly expenses by 3–6 — that's the target.",
            "Open a high-yield savings account separate from checking.",
            "Automate transfers every payday — even $100/check adds up.",
            "Don't touch it unless it's a true emergency."
        ], link: nil),
        "ba40": BenefitActionHowTo(steps: [
            "Pull free reports from all 3 bureaus at AnnualCreditReport.com.",
            "Dispute any errors in writing with each bureau.",
            "Pay down high-interest balances first.",
            "Check again 90 days before any major loan application."
        ], link: HowToLink(title: "AnnualCreditReport", url: "https://www.annualcreditreport.com/")),
        "ba41": BenefitActionHowTo(steps: [
            "Open the in-app State & Territory Benefits Finder.",
            "Look up your destination state for income tax, property tax, and licensing.",
            "Some states fully exempt veteran retirement pay.",
            "Factor this into your relocation decision."
        ], link: nil),

        // MARK: - Records / Admin (b10)
        "ba42": BenefitActionHowTo(steps: [
            "At separation, request at least 5 certified copies of your DD-214.",
            "After separation, use eVetRecs to request additional copies.",
            "Store one in a fireproof safe and scan to encrypted cloud.",
            "Never send your only copy to anyone."
        ], link: HowToLink(title: "Request DD-214 (eVetRecs)", url: "https://www.archives.gov/veterans/military-service-records")),
        "ba43": BenefitActionHowTo(steps: [
            "Check every block on your DD-214 — name, dates, awards, character of service.",
            "Compare to your records BEFORE signing.",
            "If anything is wrong, request a DD-215 correction.",
            "Errors take months to fix — verify now."
        ], link: nil),
        "ba44": BenefitActionHowTo(steps: [
            "Scan DD-214, awards, evals, training certs, medical records.",
            "Save to an encrypted cloud storage service with 2FA enabled.",
            "Keep a backup on a USB drive in a safe.",
            "Name files clearly: 'LastName_DD214_2025.pdf'."
        ], link: nil),
        "ba45": BenefitActionHowTo(steps: [
            "Visit your military medical facility records office before separation.",
            "Request your COMPLETE STR — every paper, every appointment.",
            "Get the records on a CD or USB drive.",
            "After separation, use NPRC or eVetRecs."
        ], link: HowToLink(title: "Request Records (NPRC)", url: "https://www.archives.gov/veterans/military-service-records")),

        // MARK: - Community / Crisis (b11)
        "ba46": BenefitActionHowTo(steps: [
            "Save 988 in your phone, then press 1 for the Veterans Crisis Line.",
            "Text 838255 also reaches the Veterans Crisis Line.",
            "Share with your spouse and battle buddies.",
            "Don't wait for a crisis to memorize this."
        ], link: HowToLink(title: "Veterans Crisis Line", url: "https://www.veteranscrisisline.net/")),
        "ba47": BenefitActionHowTo(steps: [
            "Use the Vet Center locator on VA.gov to find your nearest center.",
            "Vet Centers offer free readjustment counseling — no enrollment needed.",
            "Combat veterans, MST survivors, and families are eligible.",
            "Schedule an intake call."
        ], link: HowToLink(title: "Vet Center Locator", url: "https://www.vetcenter.va.gov/")),
        "ba48": BenefitActionHowTo(steps: [
            "Search for VFW, American Legion, IAVA, Team RWB, Wounded Warrior Project chapters near you.",
            "Look up local nonprofit veteran service organizations.",
            "Read recent reviews — find one that fits your style.",
            "Save the contact info."
        ], link: nil),
        "ba49": BenefitActionHowTo(steps: [
            "Pick one organization from your research.",
            "Show up to ONE event in the next 30 days — even if it's awkward.",
            "Exchange contact info with at least one person.",
            "Follow up within a week."
        ], link: nil),
    ]
}
