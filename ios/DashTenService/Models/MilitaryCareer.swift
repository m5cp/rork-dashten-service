import Foundation

nonisolated enum MilitaryServiceBranch: String, CaseIterable, Sendable, Hashable {
    case army = "Army"
    case navy = "Navy"
    case marines = "Marines"
    case airForce = "Air Force"
    case coastGuard = "Coast Guard"
    case spaceForce = "Space Force"
}

nonisolated struct MilitaryCareer: Identifiable, Hashable, Sendable {
    let id: UUID
    let code: String
    let title: String
    let branch: MilitaryServiceBranch
    let civilianTitles: [String]
    let bulletPoints: [String]
    let skills: [String]
    let isOfficer: Bool

    init(code: String, title: String, branch: MilitaryServiceBranch, civilianTitles: [String], bulletPoints: [String], skills: [String], isOfficer: Bool = false) {
        self.id = UUID()
        self.code = code
        self.title = title
        self.branch = branch
        self.civilianTitles = civilianTitles
        self.bulletPoints = bulletPoints
        self.skills = skills
        self.isOfficer = isOfficer
    }
}

nonisolated enum MilitaryCareerData {
    static let all: [MilitaryCareer] = army + navy + marines + airForce + coastGuard + spaceForce

    static let army: [MilitaryCareer] = [
        MilitaryCareer(
            code: "11B", title: "Infantryman", branch: .army,
            civilianTitles: ["Law Enforcement Officer", "Security Manager", "Operations Coordinator"],
            bulletPoints: [
                "Led and coordinated small unit operations across multiple high-risk environments",
                "Trained and mentored teams of 9–40 personnel in tactical procedures and safety protocols",
                "Maintained 100% accountability of equipment valued at over $500K",
                "Executed mission planning and after-action review processes for continuous improvement"
            ],
            skills: ["Team Leadership", "Risk Assessment", "Crisis Response", "Physical Fitness Training", "Small Arms Proficiency"]
        ),
        MilitaryCareer(
            code: "11C", title: "Indirect Fire Infantryman", branch: .army,
            civilianTitles: ["Artillery Systems Analyst", "Ballistics Technician", "Operations Planner"],
            bulletPoints: [
                "Operated and maintained 60mm/81mm/120mm mortar systems with precision",
                "Calculated firing data and adjusted fire in support of ground operations",
                "Coordinated with forward observers to deliver accurate indirect fire support",
                "Maintained detailed operational logs and maintenance records"
            ],
            skills: ["Data Calculation", "Systems Operation", "Coordination", "Technical Precision", "Team Communication"]
        ),
        MilitaryCareer(
            code: "12B", title: "Combat Engineer", branch: .army,
            civilianTitles: ["Construction Project Manager", "Civil Engineer", "Site Safety Officer"],
            bulletPoints: [
                "Designed and constructed field fortifications, bridges, and obstacles in combat environments",
                "Conducted route clearance operations and obstacle breaching under operational conditions",
                "Supervised construction projects with teams up to 20 personnel",
                "Maintained safety compliance across all construction and demolition activities"
            ],
            skills: ["Construction Management", "Safety Compliance", "Project Planning", "Equipment Operation", "Problem Solving"]
        ),
        MilitaryCareer(
            code: "13B", title: "Cannon Crewmember", branch: .army,
            civilianTitles: ["Heavy Equipment Operator", "Logistics Coordinator", "Manufacturing Technician"],
            bulletPoints: [
                "Operated and maintained M198/M777 howitzer systems in fast-paced environments",
                "Executed fire missions with precision across short- and long-range artillery operations",
                "Performed routine and preventive maintenance on complex mechanical systems",
                "Coordinated logistics and ammunition supply in high-tempo operations"
            ],
            skills: ["Heavy Equipment Operation", "Precision Mechanics", "Logistics Coordination", "Team Synchronization", "Safety Protocols"]
        ),
        MilitaryCareer(
            code: "13F", title: "Fire Support Specialist", branch: .army,
            civilianTitles: ["Data Analyst", "Communications Coordinator", "Operations Manager"],
            bulletPoints: [
                "Coordinated and directed fire support from artillery, aircraft, and naval gunfire",
                "Analyzed terrain and situation reports to recommend optimal fire support solutions",
                "Operated advanced communication systems and digital fire control networks",
                "Provided real-time battlefield intelligence to commanders"
            ],
            skills: ["Data Analysis", "Communications", "Decision Making Under Pressure", "Geospatial Awareness", "Leadership"]
        ),
        MilitaryCareer(
            code: "19D", title: "Cavalry Scout", branch: .army,
            civilianTitles: ["Intelligence Analyst", "Security Consultant", "Field Operations Manager"],
            bulletPoints: [
                "Conducted reconnaissance missions to gather and report critical intelligence",
                "Operated wheeled and tracked vehicles across varied terrain in all weather conditions",
                "Identified and reported enemy positions, strengths, and movements",
                "Led small unit tactics and coordinated with higher command for mission success"
            ],
            skills: ["Reconnaissance", "Intelligence Gathering", "Vehicle Operation", "Situational Awareness", "Leadership"]
        ),
        MilitaryCareer(
            code: "19K", title: "M1 Armor Crewman", branch: .army,
            civilianTitles: ["Heavy Equipment Operator", "Mechanical Systems Technician", "Operations Specialist"],
            bulletPoints: [
                "Operated the M1A2 Abrams main battle tank in training and combat operations",
                "Performed complex maintenance and troubleshooting on armored vehicle systems",
                "Coordinated with crew to execute precision gunnery and tactical maneuvers",
                "Maintained vehicle systems to 100% readiness under field conditions"
            ],
            skills: ["Complex Systems Operation", "Mechanical Maintenance", "Team Coordination", "Technical Troubleshooting", "Precision Execution"]
        ),
        MilitaryCareer(
            code: "17C", title: "Cyber Operations Specialist", branch: .army,
            civilianTitles: ["Cybersecurity Analyst", "Penetration Tester", "Network Security Engineer"],
            bulletPoints: [
                "Conducted offensive and defensive cyber operations against simulated and real-world adversaries",
                "Identified system vulnerabilities and implemented countermeasures to protect critical infrastructure",
                "Analyzed network traffic and performed threat hunting across enterprise environments",
                "Developed and documented standard operating procedures for cyber incident response"
            ],
            skills: ["Cybersecurity", "Network Analysis", "Threat Intelligence", "Penetration Testing", "Incident Response"]
        ),
        MilitaryCareer(
            code: "25B", title: "IT Specialist", branch: .army,
            civilianTitles: ["IT Support Specialist", "Systems Administrator", "Network Technician"],
            bulletPoints: [
                "Managed and maintained network infrastructure supporting 500+ users across multiple locations",
                "Configured and deployed servers, workstations, and communication systems",
                "Troubleshot hardware and software issues with 95%+ first-call resolution rate",
                "Ensured cybersecurity compliance across all networked systems and endpoints"
            ],
            skills: ["Network Administration", "Help Desk Support", "Systems Configuration", "Cybersecurity Compliance", "Technical Troubleshooting"]
        ),
        MilitaryCareer(
            code: "25U", title: "Signal Support Systems Specialist", branch: .army,
            civilianTitles: ["Network Technician", "Telecommunications Specialist", "IT Field Technician"],
            bulletPoints: [
                "Installed and maintained tactical communication systems and radio networks",
                "Provided technical support to commanders and staff for all signal operations",
                "Trained unit personnel on communication equipment use and troubleshooting",
                "Maintained 100% operational readiness of assigned signal equipment"
            ],
            skills: ["Telecommunications", "Radio Operations", "Field Maintenance", "Technical Training", "Network Troubleshooting"]
        ),
        MilitaryCareer(
            code: "35F", title: "Intelligence Analyst", branch: .army,
            civilianTitles: ["Intelligence Analyst", "Data Analyst", "Threat Assessment Specialist"],
            bulletPoints: [
                "Analyzed multi-source intelligence to produce actionable assessments for command decision-making",
                "Prepared and briefed threat assessments and intelligence products to senior leadership",
                "Maintained and updated geospatial databases and intelligence tracking systems",
                "Collaborated with joint and interagency partners to share critical threat information"
            ],
            skills: ["Data Analysis", "Critical Thinking", "Report Writing", "Geospatial Intelligence", "Briefing & Presentation"]
        ),
        MilitaryCareer(
            code: "35L", title: "Counterintelligence Agent", branch: .army,
            civilianTitles: ["FBI/Homeland Security Agent", "Corporate Investigator", "Security Intelligence Specialist"],
            bulletPoints: [
                "Conducted counterintelligence investigations to identify insider threats and foreign intelligence activity",
                "Interviewed and debriefed personnel to collect and analyze human intelligence",
                "Prepared detailed case files, investigative reports, and legal documentation",
                "Coordinated with federal law enforcement and intelligence agencies on joint operations"
            ],
            skills: ["Investigative Research", "Interviewing", "Report Writing", "Critical Analysis", "Security Protocols"]
        ),
        MilitaryCareer(
            code: "37F", title: "Psychological Operations Specialist", branch: .army,
            civilianTitles: ["Communications Strategist", "Marketing Analyst", "Public Affairs Specialist"],
            bulletPoints: [
                "Developed and executed influence campaigns targeting foreign audiences across multiple media channels",
                "Analyzed target audience behavioral patterns to craft effective messaging strategies",
                "Produced and distributed information products including radio broadcasts, print media, and digital content",
                "Advised commanders on the psychological impact of military operations"
            ],
            skills: ["Strategic Communications", "Audience Analysis", "Content Creation", "Campaign Planning", "Cross-Cultural Communication"]
        ),
        MilitaryCareer(
            code: "27D", title: "Paralegal Specialist", branch: .army,
            civilianTitles: ["Paralegal", "Legal Assistant", "Compliance Specialist"],
            bulletPoints: [
                "Researched and prepared legal documents including briefs, motions, and memoranda",
                "Assisted in military justice proceedings including courts-martial and administrative hearings",
                "Maintained legal case files and evidence in compliance with regulations",
                "Advised commanders on administrative law and personnel actions"
            ],
            skills: ["Legal Research", "Document Preparation", "Compliance", "Attention to Detail", "Case Management"]
        ),
        MilitaryCareer(
            code: "31B", title: "Military Police", branch: .army,
            civilianTitles: ["Law Enforcement Officer", "Security Manager", "Criminal Investigator"],
            bulletPoints: [
                "Enforced federal and military law in garrison and deployed environments",
                "Conducted criminal investigations, interviews, and evidence collection",
                "Managed detainee operations and maintained law and order",
                "Collaborated with civilian law enforcement agencies on joint operations"
            ],
            skills: ["Law Enforcement", "Criminal Investigation", "Crisis De-escalation", "Report Writing", "Community Relations"]
        ),
        MilitaryCareer(
            code: "42A", title: "Human Resources Specialist", branch: .army,
            civilianTitles: ["HR Generalist", "People Operations Coordinator", "Benefits Administrator"],
            bulletPoints: [
                "Managed personnel records and HR transactions for units of 200–3,000 soldiers",
                "Processed evaluations, awards, promotions, and separation actions with accuracy and timeliness",
                "Advised commanders and soldiers on personnel policies, benefits, and career management",
                "Utilized HR information systems to maintain accurate, real-time personnel data"
            ],
            skills: ["Human Resources Management", "Benefits Administration", "HRIS Systems", "Policy Compliance", "Employee Relations"]
        ),
        MilitaryCareer(
            code: "68W", title: "Combat Medic Specialist", branch: .army,
            civilianTitles: ["Emergency Medical Technician", "Medical Assistant", "Healthcare Coordinator"],
            bulletPoints: [
                "Provided emergency medical treatment to injured personnel in combat and training environments",
                "Managed patient care from point of injury through evacuation to higher-level medical facilities",
                "Trained unit personnel in first aid and Tactical Combat Casualty Care (TCCC)",
                "Maintained medical supply accountability and ensured readiness of medical equipment"
            ],
            skills: ["Emergency Medical Care", "Patient Assessment", "Medical Documentation", "Training & Education", "Healthcare Coordination"]
        ),
        MilitaryCareer(
            code: "68A", title: "Biomedical Equipment Specialist", branch: .army,
            civilianTitles: ["Biomedical Equipment Technician (BMET)", "Medical Device Repair Specialist", "Healthcare Technology Manager"],
            bulletPoints: [
                "Installed, calibrated, and maintained complex medical equipment including imaging and life support systems",
                "Performed preventive maintenance and safety inspections per manufacturer and regulatory standards",
                "Troubleshot equipment failures and coordinated repairs to minimize downtime",
                "Maintained comprehensive maintenance records and equipment inventory"
            ],
            skills: ["Medical Equipment Maintenance", "Electrical/Electronics Repair", "Biomedical Safety", "Record Keeping", "Technical Troubleshooting"]
        ),
        MilitaryCareer(
            code: "68D", title: "Operating Room Specialist", branch: .army,
            civilianTitles: ["Surgical Technologist", "OR Technician", "Sterile Processing Technician"],
            bulletPoints: [
                "Assisted surgeons during general, orthopedic, and trauma surgical procedures",
                "Prepared sterile surgical fields and managed instruments throughout operative cases",
                "Maintained and sterilized surgical instruments in compliance with infection control protocols",
                "Supported surgical teams under high-pressure, time-critical conditions"
            ],
            skills: ["Surgical Assisting", "Sterile Technique", "Instrument Management", "Teamwork Under Pressure", "Infection Control"]
        ),
        MilitaryCareer(
            code: "68E", title: "Dental Specialist", branch: .army,
            civilianTitles: ["Dental Assistant", "Dental Hygienist", "Dental Office Manager"],
            bulletPoints: [
                "Assisted dentists in preventive care, restorative, and oral surgery procedures",
                "Operated digital X-ray equipment and maintained dental records",
                "Performed patient screenings and dental hygiene education for unit personnel",
                "Managed dental supply inventory and sterilization procedures"
            ],
            skills: ["Dental Assisting", "Radiography", "Patient Education", "Inventory Management", "Infection Control"]
        ),
        MilitaryCareer(
            code: "68X", title: "Mental Health Specialist", branch: .army,
            civilianTitles: ["Behavioral Health Technician", "Mental Health Counselor", "Case Manager"],
            bulletPoints: [
                "Provided behavioral health screening, assessment, and counseling support under licensed supervision",
                "Managed caseloads of 50+ patients including crisis intervention and follow-up care",
                "Facilitated psychoeducation groups on stress management, resilience, and substance use prevention",
                "Coordinated with multidisciplinary teams to deliver comprehensive mental health services"
            ],
            skills: ["Behavioral Health Support", "Crisis Intervention", "Case Management", "Group Facilitation", "Clinical Documentation"]
        ),
        MilitaryCareer(
            code: "74D", title: "Chemical Operations Specialist", branch: .army,
            civilianTitles: ["Hazardous Materials Technician", "Environmental Health & Safety Officer", "Industrial Hygienist"],
            bulletPoints: [
                "Conducted CBRN reconnaissance and decontamination operations in simulated and real-world environments",
                "Trained unit personnel on detection, protection, and decontamination of chemical/biological/radiological/nuclear hazards",
                "Performed hazard assessments and environmental sampling in support of field operations",
                "Maintained detection equipment and ensured readiness of all assigned CBRN assets"
            ],
            skills: ["Hazmat Operations", "CBRN Detection", "Safety Training", "Environmental Sampling", "Emergency Response"]
        ),
        MilitaryCareer(
            code: "88M", title: "Motor Transport Operator", branch: .army,
            civilianTitles: ["Commercial Driver (CDL)", "Logistics Coordinator", "Fleet Operations Manager"],
            bulletPoints: [
                "Operated wheeled vehicles from 5-ton trucks to 18-wheelers in garrison and combat convoy operations",
                "Managed cargo load planning, weight distribution, and transport documentation for multi-stop missions",
                "Maintained vehicle operational readiness including preventive maintenance checks and services",
                "Led convoy operations in austere and hostile environments, ensuring personnel and cargo safety"
            ],
            skills: ["Commercial Driving (CDL)", "Logistics Planning", "Vehicle Maintenance", "Route Planning", "Safety Compliance"]
        ),
        MilitaryCareer(
            code: "88H", title: "Cargo Specialist", branch: .army,
            civilianTitles: ["Logistics Specialist", "Warehouse Manager", "Supply Chain Coordinator"],
            bulletPoints: [
                "Supervised the receipt, storage, and distribution of military cargo and sensitive materials",
                "Operated forklifts and material handling equipment to manage high-volume cargo operations",
                "Maintained shipping and receiving documentation in compliance with Department of Defense regulations",
                "Coordinated with transportation units to prioritize and expedite critical cargo movement"
            ],
            skills: ["Cargo Management", "Forklift Operation", "Inventory Control", "Supply Chain Logistics", "Documentation"]
        ),
        MilitaryCareer(
            code: "92A", title: "Automated Logistical Specialist", branch: .army,
            civilianTitles: ["Supply Chain Analyst", "Warehouse Supervisor", "Inventory Control Manager"],
            bulletPoints: [
                "Managed property accountability for equipment and supplies valued at over $2M",
                "Operated Army logistics systems to process requisitions, receipts, and issue transactions",
                "Conducted inventories and reconciled discrepancies across multiple accounts",
                "Supervised warehouse operations including receiving, storage, and issue of supplies"
            ],
            skills: ["Inventory Management", "Logistics Software", "Property Accountability", "Warehouse Operations", "Supply Chain Management"]
        ),
        MilitaryCareer(
            code: "92F", title: "Petroleum Supply Specialist", branch: .army,
            civilianTitles: ["Fuel Operations Manager", "Petroleum Distribution Specialist", "Hazmat Logistics Coordinator"],
            bulletPoints: [
                "Managed bulk petroleum storage and distribution systems supporting 1,000+ vehicles",
                "Operated and maintained fuel storage tanks, pumping systems, and refueling equipment",
                "Maintained strict hazardous material handling and spill prevention procedures",
                "Controlled fuel inventory and reconciled records to ensure zero discrepancies"
            ],
            skills: ["Petroleum Operations", "Hazmat Handling", "Inventory Control", "Equipment Maintenance", "Safety Compliance"]
        ),
        MilitaryCareer(
            code: "92G", title: "Food Service Specialist", branch: .army,
            civilianTitles: ["Executive Chef", "Food Service Manager", "Restaurant Operations Manager"],
            bulletPoints: [
                "Prepared and served meals for units of 50–2,000 personnel using field and garrison kitchen equipment",
                "Supervised kitchen operations including food safety compliance, inventory management, and equipment maintenance",
                "Managed food service budgets and ordering to minimize waste and maintain quality",
                "Trained junior personnel in cooking techniques, sanitation, and kitchen operations"
            ],
            skills: ["Food Production", "Kitchen Management", "Food Safety/ServSafe", "Budget Management", "Team Supervision"]
        ),
        MilitaryCareer(
            code: "92Y", title: "Unit Supply Specialist", branch: .army,
            civilianTitles: ["Supply Chain Specialist", "Inventory Manager", "Procurement Coordinator"],
            bulletPoints: [
                "Managed unit supply room operations, maintaining accountability for 300+ line items of equipment",
                "Processed requests for equipment, clothing, and supplies using Army logistics systems",
                "Conducted property inventories and reconciled records with 99%+ accuracy",
                "Coordinated equipment maintenance, repairs, and hand receipts across the organization"
            ],
            skills: ["Supply Management", "Inventory Control", "Logistics Systems", "Property Accountability", "Organizational Skills"]
        ),
        // ─── ARMY OFFICERS ───
        MilitaryCareer(
            code: "11A", title: "Infantry Officer", branch: .army,
            civilianTitles: ["Operations Director", "Law Enforcement Commander", "Program Manager"],
            bulletPoints: [
                "Commanded an infantry company of 130+ soldiers, directing all training, operations, and personnel actions",
                "Led complex multi-echelon operations in austere environments, achieving mission success with zero fatalities",
                "Managed a $2.4M equipment budget and maintained 95%+ operational readiness",
                "Developed and executed training programs that increased unit proficiency scores by 30%"
            ],
            skills: ["Executive Leadership", "Operations Management", "Budget Management", "Strategic Planning", "Team Development"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "13A", title: "Field Artillery Officer", branch: .army,
            civilianTitles: ["Operations Manager", "Systems Integration Manager", "Project Director"],
            bulletPoints: [
                "Commanded a 90-person field artillery battery operating $15M in precision weapons systems",
                "Synchronized fires with maneuver, aviation, and joint assets during combined arms operations",
                "Led technical integration of digital fire control systems improving mission response time by 40%",
                "Mentored and developed 8 junior officers and 12 NCOs in professional and technical competencies"
            ],
            skills: ["Systems Integration", "Operations Leadership", "Technical Program Management", "Cross-Functional Coordination", "Personnel Development"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "15A", title: "Aviation Officer (Rotary Wing)", branch: .army,
            civilianTitles: ["Commercial Helicopter Pilot", "Aviation Operations Manager", "Flight Safety Officer"],
            bulletPoints: [
                "Commanded an aviation company operating 15 UH-60 Black Hawk aircraft and 180 personnel",
                "Accumulated 1,200+ flight hours across combat, training, and humanitarian operations",
                "Led flight safety programs achieving zero Class A/B mishaps over a 3-year command period",
                "Managed $40M in aircraft and aviation ground support equipment with zero loss"
            ],
            skills: ["Rotary Wing Aviation", "Aviation Safety", "Fleet Management", "Program Management", "Leadership"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "18A", title: "Special Forces Officer", branch: .army,
            civilianTitles: ["Senior Operations Director", "Defense Contractor — SOF", "Security & Intelligence Executive"],
            bulletPoints: [
                "Commanded a 12-man Special Forces ODA conducting foreign internal defense, direct action, and HUMINT operations across 3 countries",
                "Built and led indigenous security forces up to battalion size (800+ personnel) from scratch",
                "Managed interagency relationships with CIA, DIA, and State Department in complex, politically sensitive environments",
                "Developed and executed campaign plans spanning 18–36 months with strategic-level impact"
            ],
            skills: ["Special Operations Leadership", "Interagency Coordination", "Strategic Planning", "Foreign Partner Development", "Crisis Management"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "25A", title: "Signal Officer", branch: .army,
            civilianTitles: ["Chief Information Officer", "IT Director", "Network Engineering Manager"],
            bulletPoints: [
                "Directed enterprise network operations supporting 5,000+ users across a multi-site organization",
                "Led digital transformation projects integrating cloud, cybersecurity, and mobile communication platforms",
                "Managed a $12M IT infrastructure budget and a team of 60 signal soldiers and contractors",
                "Developed cybersecurity policies and incident response plans adopted across the division"
            ],
            skills: ["IT Leadership", "Network Architecture", "Cybersecurity Strategy", "Digital Transformation", "Budget Management"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "27A", title: "Judge Advocate General (JAG) Officer", branch: .army,
            civilianTitles: ["Attorney", "Corporate Counsel", "Compliance Officer"],
            bulletPoints: [
                "Provided legal counsel to commanders on military justice, administrative law, and international law of armed conflict",
                "Prosecuted and defended courts-martial across felony-level criminal cases",
                "Advised on contracting, fiscal law, and acquisition compliance for programs valued at $50M+",
                "Developed legal training programs for 2,000+ soldiers on ethics, UCMJ, and legal rights"
            ],
            skills: ["Legal Counsel", "Criminal Litigation", "Compliance", "Contracting Law", "Executive Advising"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "35D", title: "All Source Intelligence Officer", branch: .army,
            civilianTitles: ["Intelligence Director", "Research & Analysis Director", "Senior Threat Analyst"],
            bulletPoints: [
                "Directed a 40-person intelligence section producing all-source products for brigade-level operations",
                "Provided daily intelligence briefings to senior commanders on adversary capabilities and intentions",
                "Integrated HUMINT, SIGINT, IMINT, and cyber intelligence into actionable operational assessments",
                "Managed classified databases and intelligence sharing relationships with interagency partners"
            ],
            skills: ["Intelligence Leadership", "All-Source Analysis", "Briefing Executive Leadership", "Interagency Coordination", "Strategic Assessments"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "36A", title: "Financial Management Officer", branch: .army,
            civilianTitles: ["Chief Financial Officer", "Finance Director", "Government Contracting Officer"],
            bulletPoints: [
                "Managed a $180M operational budget including pay, contracts, and contingency funding",
                "Directed financial operations for a 5,000-person organization across 3 countries",
                "Implemented audit-ready financial controls reducing discrepancies by 85%",
                "Advised commanders on fiscal law, appropriations, and fund execution strategy"
            ],
            skills: ["Financial Management", "Budget Execution", "Fiscal Law", "Audit Compliance", "Executive Advising"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "38A", title: "Civil Affairs Officer", branch: .army,
            civilianTitles: ["International Development Manager", "Government Affairs Director", "NGO Country Director"],
            bulletPoints: [
                "Led civil-military operations restoring governance and infrastructure in post-conflict environments",
                "Managed $5M in humanitarian assistance projects across water, healthcare, education, and economic sectors",
                "Built relationships with host nation government officials, international organizations, and NGOs",
                "Directed assessments of civil vulnerabilities and recommended courses of action to senior commanders"
            ],
            skills: ["International Development", "Project Management", "Government Relations", "Cross-Cultural Leadership", "Stakeholder Engagement"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "42B", title: "Human Resources Officer", branch: .army,
            civilianTitles: ["Chief People Officer", "HR Director", "Talent Management Director"],
            bulletPoints: [
                "Directed human resources operations for an organization of 10,000+ soldiers across 12 installations",
                "Led talent management programs including officer/NCO evaluations, promotions, and succession planning",
                "Managed casualty operations, survivor benefits processing, and family support programs",
                "Developed HR policy and advised senior commanders on personnel readiness and manning requirements"
            ],
            skills: ["HR Leadership", "Talent Management", "Policy Development", "Workforce Planning", "Executive Advisory"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "56A", title: "Chaplain", branch: .army,
            civilianTitles: ["Hospital Chaplain", "Nonprofit Executive Director", "Counseling Program Director"],
            bulletPoints: [
                "Provided religious, spiritual, and pastoral care to a diverse population of 3,000+ soldiers and families",
                "Advised commanders on morale, unit climate, and ethical leadership",
                "Managed a religious support team and coordinated programs across multiple faiths",
                "Developed and led resilience programs that measurably improved unit mental health outcomes"
            ],
            skills: ["Pastoral Counseling", "Program Leadership", "Community Building", "Executive Advisory", "Crisis Support"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "65D", title: "Physician Assistant", branch: .army,
            civilianTitles: ["Physician Assistant", "Clinical Operations Manager", "Medical Director"],
            bulletPoints: [
                "Provided primary and emergency medical care as independent duty provider for units with no physician",
                "Managed clinical operations for a healthcare facility serving 2,000+ patients annually",
                "Led a medical team of 12 providers across multiple specialties in combat and garrison environments",
                "Developed clinical protocols that reduced emergency room visits by 25%"
            ],
            skills: ["Clinical Medicine", "Emergency Care", "Healthcare Management", "Team Leadership", "Protocol Development"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "70A", title: "Medical Service Corps Officer (Healthcare Administration)", branch: .army,
            civilianTitles: ["Hospital Administrator", "Healthcare Operations Director", "Health Systems Manager"],
            bulletPoints: [
                "Administered a military treatment facility delivering care to 15,000+ beneficiaries",
                "Managed a $22M healthcare budget and a staff of 200 medical professionals",
                "Led Joint Commission readiness programs achieving successful accreditation with zero deficiencies",
                "Implemented EHR transition reducing documentation errors by 40%"
            ],
            skills: ["Healthcare Administration", "Budget Management", "Regulatory Compliance", "EHR Systems", "Operations Leadership"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "74A", title: "Chemical Officer", branch: .army,
            civilianTitles: ["Environmental Health & Safety Director", "Hazmat Program Manager", "Emergency Management Director"],
            bulletPoints: [
                "Directed CBRN defense operations and developed response plans for mass casualty incidents",
                "Led decontamination exercises for units of 5,000+ personnel achieving 100% readiness",
                "Advised commanders on chemical, biological, radiological, and nuclear threat environments",
                "Managed hazardous materials compliance programs across a large installation"
            ],
            skills: ["CBRN Operations", "Emergency Management", "Hazmat Compliance", "Risk Assessment", "Program Management"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "91A", title: "Ordnance Officer", branch: .army,
            civilianTitles: ["Logistics Director", "Supply Chain Executive", "Maintenance Operations Director"],
            bulletPoints: [
                "Directed maintenance and supply operations sustaining $500M in equipment across a brigade-sized unit",
                "Managed a team of 300 maintenance technicians and logistics specialists",
                "Achieved 90%+ equipment readiness rates in high-tempo operational environments",
                "Led lean process improvement initiatives reducing maintenance turnaround time by 35%"
            ],
            skills: ["Logistics Leadership", "Supply Chain Management", "Maintenance Operations", "Budget Management", "Process Improvement"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "92A-O", title: "Quartermaster Officer (Logistics)", branch: .army,
            civilianTitles: ["VP of Supply Chain", "Director of Logistics", "Operations Executive"],
            bulletPoints: [
                "Managed integrated logistics operations including supply, transportation, and field services for 10,000-person force",
                "Directed $80M in Class I–IX supply operations across multi-echelon distribution networks",
                "Led fuel, water, and subsistence operations sustaining combat operations for 90+ days",
                "Developed logistics synchronization matrices adopted as division standard operating procedures"
            ],
            skills: ["Supply Chain Leadership", "Distribution Management", "Operations Planning", "Budget Management", "Process Development"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "91B", title: "Wheeled Vehicle Mechanic", branch: .army,
            civilianTitles: ["Fleet Mechanic", "Diesel Technician", "Automotive Service Manager"],
            bulletPoints: [
                "Performed maintenance and repair on light and heavy wheeled vehicles including HMMWVs, LMTVs, and HETs",
                "Diagnosed mechanical, electrical, and hydraulic faults using technical manuals and diagnostic equipment",
                "Supervised vehicle maintenance operations for fleets of 20–100 vehicles",
                "Maintained maintenance records and tracked vehicle readiness to meet operational requirements"
            ],
            skills: ["Diesel Mechanics", "Fleet Maintenance", "Fault Diagnosis", "Technical Documentation", "Preventive Maintenance"]
        ),
        MilitaryCareer(
            code: "91D", title: "Power Generation Equipment Repairer", branch: .army,
            civilianTitles: ["Generator Mechanic", "Electrician", "Facilities Maintenance Technician"],
            bulletPoints: [
                "Maintained and repaired tactical and commercial generators from 5kW to 100kW capacity",
                "Diagnosed and repaired electrical, mechanical, and fuel system faults across multiple generator models",
                "Ensured continuous power supply for critical command, medical, and communication facilities",
                "Trained operators on generator safety, startup, shutdown, and preventive maintenance procedures"
            ],
            skills: ["Electrical Systems", "Generator Maintenance", "Power Systems", "Fault Diagnosis", "Safety Compliance"]
        ),
        MilitaryCareer(
            code: "91H", title: "Track Vehicle Repairer", branch: .army,
            civilianTitles: ["Heavy Equipment Mechanic", "Track Vehicle Technician", "Industrial Machinery Mechanic"],
            bulletPoints: [
                "Performed maintenance and repairs on M1 Abrams tanks, Bradley Fighting Vehicles, and other tracked platforms",
                "Diagnosed and repaired complex mechanical, hydraulic, and electronic systems using technical manuals",
                "Conducted field-level maintenance under time-critical operational conditions",
                "Managed maintenance schedules and parts requisition to maintain fleet readiness"
            ],
            skills: ["Track Vehicle Maintenance", "Hydraulic Systems", "Electronic Diagnostics", "Technical Manual Use", "Heavy Equipment Repair"]
        ),
        MilitaryCareer(
            code: "89D", title: "Explosive Ordnance Disposal Specialist", branch: .army,
            civilianTitles: ["EOD Technician", "Hazmat Specialist", "Bomb Disposal Technician"],
            bulletPoints: [
                "Identified, rendered safe, and disposed of improvised explosive devices, mines, and unexploded ordnance",
                "Utilized robotic systems and remote tools to investigate and neutralize explosive threats",
                "Provided subject matter expertise to law enforcement on explosive hazard identification",
                "Maintained zero-defect performance standards in high-risk, time-critical operations"
            ],
            skills: ["EOD Operations", "Risk Assessment", "Robotics Operation", "Technical Procedures", "High-Pressure Decision Making"]
        ),
        MilitaryCareer(
            code: "18B", title: "Special Forces Weapons Sergeant", branch: .army,
            civilianTitles: ["Weapons Instructor", "Law Enforcement Trainer", "Defense Contractor — Firearms"],
            bulletPoints: [
                "Trained and advised foreign military forces on individual and crew-served weapons systems",
                "Planned and executed direct action, foreign internal defense, and special reconnaissance missions",
                "Maintained proficiency on 40+ foreign and domestic weapons platforms",
                "Led small team operations in austere, denied environments with minimal supervision"
            ],
            skills: ["Weapons Expertise", "Foreign Military Training", "Mission Planning", "Special Operations", "Cross-Cultural Leadership"]
        ),
        MilitaryCareer(
            code: "18D", title: "Special Forces Medical Sergeant", branch: .army,
            civilianTitles: ["Physician Assistant", "Paramedic", "Emergency Medicine Technician"],
            bulletPoints: [
                "Provided advanced trauma care and primary healthcare to SF team members and indigenous forces in remote environments",
                "Performed surgical procedures and managed complex medical cases far from conventional medical support",
                "Trained partner-nation forces in combat medicine and field sanitation",
                "Maintained medical readiness and supplies for 12-man team in austere locations"
            ],
            skills: ["Advanced Trauma Care", "Surgical Assistance", "Patient Management", "Medical Training", "Remote Medical Operations"]
        ),
        MilitaryCareer(
            code: "18E", title: "Special Forces Communications Sergeant", branch: .army,
            civilianTitles: ["Communications Engineer", "Network Architect", "Telecommunications Specialist"],
            bulletPoints: [
                "Designed and maintained HF/UHF/VHF communication networks for global special operations missions",
                "Built and operated satellite communication systems in austere, denied environments",
                "Encrypted and managed data networks in compliance with NSA/COMSEC standards",
                "Trained partner forces on communications equipment installation and operation"
            ],
            skills: ["Satellite Communications", "Network Engineering", "COMSEC", "Technical Training", "System Design"]
        ),
        MilitaryCareer(
            code: "18C", title: "Special Forces Engineer Sergeant", branch: .army,
            civilianTitles: ["Construction Project Manager", "Demolitions Safety Specialist", "Civil Engineer — International"],
            bulletPoints: [
                "Planned and executed construction projects including bridges, airstrips, and fortifications in denied and austere environments",
                "Trained partner-nation forces in construction techniques, demolitions, and field engineering",
                "Conducted route clearance and obstacle breaching in support of direct action and unconventional warfare missions",
                "Managed $1.5M in engineer equipment and demolitions materials with zero loss or incident"
            ],
            skills: ["Construction Engineering", "Demolitions Safety", "Foreign Partner Training", "Project Management", "Field Engineering"]
        ),
        MilitaryCareer(
            code: "18F", title: "Special Forces Intelligence Sergeant", branch: .army,
            civilianTitles: ["Intelligence Analyst", "HUMINT Collector", "Senior Threat Analyst"],
            bulletPoints: [
                "Collected and analyzed all-source intelligence in support of Special Forces direct action and unconventional warfare operations",
                "Developed intelligence products and target packages for ODA-level missions across 3 theaters",
                "Managed relationships with human intelligence sources and foreign liaison partners",
                "Integrated HUMINT, SIGINT, and imagery intelligence to produce actionable assessments for team and higher command"
            ],
            skills: ["HUMINT Collection", "All-Source Analysis", "Targeting", "Source Management", "Intelligence Reporting"]
        ),
        MilitaryCareer(
            code: "18Z", title: "Special Forces Senior NCO / Team Sergeant", branch: .army,
            civilianTitles: ["Senior Operations Manager", "Defense Contractor — SOF Program", "Security & Intelligence Executive"],
            bulletPoints: [
                "Served as Team Sergeant of a 12-man ODA, responsible for all training, operations, and personnel across 15+ deployments",
                "Planned and led direct action, foreign internal defense, unconventional warfare, and HUMINT operations globally",
                "Built, trained, and advised indigenous security forces up to battalion size (500–800 personnel) from scratch",
                "Managed interagency relationships and coordinated operations with CIA, DIA, and State Department in politically sensitive environments"
            ],
            skills: ["Senior Special Operations Leadership", "Strategic Planning", "Foreign Partner Development", "Interagency Coordination", "Executive Program Management"]
        ),
        MilitaryCareer(
            code: "79R", title: "Recruiting & Retention NCO", branch: .army,
            civilianTitles: ["Corporate Recruiter", "Talent Acquisition Specialist", "Sales Representative"],
            bulletPoints: [
                "Recruited and processed 50–100 qualified applicants per year through a competitive selection process",
                "Developed and maintained a prospect pipeline using CRM tools and community outreach programs",
                "Consistently exceeded mission goals by 110–130% through relationship-based selling",
                "Managed a geographic territory and built partnerships with high schools, colleges, and community organizations"
            ],
            skills: ["Recruiting", "Sales", "CRM Tools", "Pipeline Management", "Community Outreach"]
        ),
        MilitaryCareer(
            code: "38B", title: "Civil Affairs Specialist", branch: .army,
            civilianTitles: ["International Development Coordinator", "Government Affairs Specialist", "NGO Program Manager"],
            bulletPoints: [
                "Coordinated civil-military operations to rebuild infrastructure and restore government services in post-conflict environments",
                "Liaised with local government officials, NGOs, and civilian populations to assess and address community needs",
                "Developed and managed projects including water, sanitation, schools, and medical facilities",
                "Produced civil information products and briefed commanders on civil considerations"
            ],
            skills: ["Project Management", "Cross-Cultural Communication", "Government Liaison", "Community Assessment", "Report Writing"]
        ),
        MilitaryCareer(
            code: "56M", title: "Religious Affairs Specialist", branch: .army,
            civilianTitles: ["Program Coordinator", "Counseling Support Specialist", "Nonprofit Operations Manager"],
            bulletPoints: [
                "Supported chaplains in delivering religious, spiritual, and pastoral care to units of 200–3,000 soldiers",
                "Coordinated religious programs, events, and counseling services in garrison and deployed environments",
                "Maintained strict confidentiality in sensitive counseling and pastoral care situations",
                "Managed religious program budgets and logistics including equipment and travel"
            ],
            skills: ["Program Coordination", "Counseling Support", "Event Planning", "Confidentiality", "Budget Management"]
        ),
        MilitaryCareer(
            code: "12A", title: "Engineer Officer", branch: .army,
            civilianTitles: ["Civil Engineer", "Construction Program Manager", "Infrastructure Director"],
            bulletPoints: [
                "Commanded an engineer company of 120 soldiers executing construction, mobility, and counter-mobility operations",
                "Managed $8M in construction and demolition projects across forward-deployed environments",
                "Led route clearance and obstacle breaching operations in direct support of maneuver brigades",
                "Developed engineer support plans for large-scale combat operations adopted at brigade level"
            ],
            skills: ["Construction Management", "Project Engineering", "Operations Planning", "Budget Management", "Team Leadership"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "14A", title: "Air Defense Artillery Officer", branch: .army,
            civilianTitles: ["Systems Integration Manager", "Aerospace Defense Program Manager", "Operations Director"],
            bulletPoints: [
                "Commanded a Patriot or SHORAD battery defending critical assets from air and missile threats",
                "Directed integration of air defense systems with joint air operations centers and theater fire control networks",
                "Managed $50M+ in air defense equipment with zero mission-critical failures during operational deployments",
                "Developed air defense employment plans for major exercises and real-world contingency operations"
            ],
            skills: ["Systems Integration", "Joint Operations", "Program Management", "Technical Leadership", "Threat Assessment"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "19A", title: "Armor Officer", branch: .army,
            civilianTitles: ["Operations Director", "Logistics & Fleet Manager", "Security Executive"],
            bulletPoints: [
                "Commanded an armor company of 60 soldiers and 14 M1A2 Abrams tanks valued at $60M+",
                "Planned and executed combined arms maneuver operations integrating tanks, infantry, artillery, and aviation",
                "Maintained 92% fleet readiness rate across complex mechanical and electronic systems",
                "Led gunnery programs achieving highest qualification scores in the brigade two consecutive years"
            ],
            skills: ["Combined Arms Leadership", "Fleet Management", "Operations Planning", "Technical Program Management", "Team Development"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "29A", title: "Electronic Warfare Officer", branch: .army,
            civilianTitles: ["Electronic Warfare Engineer", "RF Systems Analyst", "Signals Intelligence Manager"],
            bulletPoints: [
                "Directed electronic warfare operations integrating jamming, spectrum management, and signals intelligence",
                "Advised brigade commanders on electromagnetic spectrum exploitation and protection",
                "Managed electronic warfare support teams and coordinated with joint EW agencies",
                "Developed EW synchronization matrices and targeting products for brigade-level operations"
            ],
            skills: ["Electronic Warfare", "RF/Spectrum Management", "Signals Intelligence", "Joint Operations", "Technical Analysis"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "30A", title: "Information Operations Officer", branch: .army,
            civilianTitles: ["Information Strategy Director", "Communications Operations Manager", "Influence Campaign Manager"],
            bulletPoints: [
                "Planned and synchronized information operations across cyber, MISO, EW, and public affairs capabilities",
                "Advised commanding generals on information environment assessment and influence strategy",
                "Developed IO campaign plans supporting corps and division operations in multiple theaters",
                "Coordinated interagency information operations with State Department and intelligence community partners"
            ],
            skills: ["Information Operations", "Strategic Communications", "Interagency Coordination", "Campaign Planning", "Executive Advisory"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "31A", title: "Military Police Officer", branch: .army,
            civilianTitles: ["Chief of Police", "Director of Security", "Law Enforcement Executive"],
            bulletPoints: [
                "Commanded a military police company of 120 soldiers providing law enforcement, detainee operations, and force protection",
                "Directed criminal investigation operations and partnered with CID, FBI, and civilian law enforcement agencies",
                "Managed installation security programs protecting assets and personnel on a major Army post",
                "Led detainee operations and ensured full compliance with Geneva Conventions and DoD directives"
            ],
            skills: ["Law Enforcement Leadership", "Criminal Investigation", "Security Management", "Policy Compliance", "Interagency Coordination"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "37A", title: "Psychological Operations Officer", branch: .army,
            civilianTitles: ["Communications Strategy Director", "Marketing Director", "Influence & Advertising Executive"],
            bulletPoints: [
                "Planned and executed multi-channel influence campaigns targeting foreign audiences in 3 countries",
                "Directed a 40-person PSYOP company producing radio, print, digital, and face-to-face influence products",
                "Advised joint force commanders on target audience analysis and information environment assessments",
                "Coordinated influence operations with State Department, CIA, and interagency partners"
            ],
            skills: ["Strategic Communications", "Campaign Planning", "Target Audience Analysis", "Content Production", "Interagency Coordination"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "40A", title: "Space Operations Officer", branch: .army,
            civilianTitles: ["Satellite Program Manager", "Space Systems Analyst", "Defense Space Consultant"],
            bulletPoints: [
                "Integrated space capabilities including satellite communications, GPS, and space domain awareness into ground operations",
                "Advised division and corps commanders on space support and adversary space threats",
                "Coordinated with US Space Command, Space Force, and NRO on joint space operations",
                "Developed space support annex for large-scale combat operations planning"
            ],
            skills: ["Space Operations", "Satellite Communications", "Joint Operations", "Strategic Planning", "Technical Advisory"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "41A", title: "Foreign Area Officer", branch: .army,
            civilianTitles: ["International Affairs Director", "Country Director — NGO/State Dept", "Global Risk Analyst"],
            bulletPoints: [
                "Served as regional expert and senior advisor on political-military affairs for a combatant command",
                "Built and maintained relationships with foreign military and government officials across 5+ countries",
                "Produced regional assessments and policy recommendations adopted at the theater commander level",
                "Conducted security cooperation programs training and equipping partner-nation military forces"
            ],
            skills: ["International Relations", "Political-Military Affairs", "Foreign Language Proficiency", "Diplomatic Engagement", "Regional Expertise"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "46A", title: "Public Affairs Officer", branch: .army,
            civilianTitles: ["VP of Communications", "Corporate Communications Director", "Public Relations Executive"],
            bulletPoints: [
                "Directed strategic communications for Army commands of 5,000–20,000 soldiers",
                "Advised commanding generals on media strategy, crisis communications, and reputational risk",
                "Managed media relations during high-profile operations including 100+ press embed coordination",
                "Developed social media and digital communication strategies that grew command audience by 300%"
            ],
            skills: ["Strategic Communications", "Executive Advisory", "Media Relations", "Crisis Communications", "Digital Strategy"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "49A", title: "Operations Research / Systems Analyst (ORSA)", branch: .army,
            civilianTitles: ["Data Scientist", "Operations Research Analyst", "Strategy & Analytics Director"],
            bulletPoints: [
                "Applied statistical modeling and operations research methods to optimize combat readiness and resource allocation",
                "Built decision-support tools and dashboards used by senior commanders for operational planning",
                "Analyzed large datasets to identify patterns and recommend evidence-based policy changes",
                "Led quantitative analysis teams supporting Pentagon-level strategy and force structure decisions"
            ],
            skills: ["Data Analysis", "Statistical Modeling", "Decision Support", "Operations Research", "Executive Briefing"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "51A", title: "Acquisitions Officer", branch: .army,
            civilianTitles: ["Program Manager", "Defense Acquisitions Director", "Government Contracts Executive"],
            bulletPoints: [
                "Managed defense acquisition programs from milestone A through fielding for systems valued at $500M–$2B",
                "Led source selection boards evaluating major defense contractor proposals",
                "Coordinated with Congress, OSD, and defense industry on program cost, schedule, and performance",
                "Implemented Agile and DevSecOps acquisition practices reducing delivery timelines by 35%"
            ],
            skills: ["Defense Acquisitions", "Program Management", "Contract Management", "Stakeholder Engagement", "Government Procurement"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "53A", title: "Information Systems Management Officer", branch: .army,
            civilianTitles: ["Chief Information Officer", "IT Director", "Enterprise Architect"],
            bulletPoints: [
                "Directed Army enterprise IT systems modernization programs valued at $100M+",
                "Led a 75-person IT organization managing network infrastructure for 10,000+ users",
                "Drove cloud migration and cybersecurity enhancement initiatives across a major Army command",
                "Developed IT governance frameworks and enterprise architecture standards adopted Army-wide"
            ],
            skills: ["IT Leadership", "Enterprise Architecture", "Cloud Migration", "Cybersecurity Strategy", "Program Management"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "57A", title: "Simulation Operations Officer", branch: .army,
            civilianTitles: ["Training Systems Program Manager", "Simulation Engineer", "Learning & Development Director"],
            bulletPoints: [
                "Managed combat training simulations and instrumented exercise systems for major Army exercises",
                "Directed a simulation center operating $20M in live, virtual, and constructive training systems",
                "Developed training scenarios and exercise design for brigade and division-level combat training center rotations",
                "Collaborated with TRADOC and defense contractors to modernize Army simulation capabilities"
            ],
            skills: ["Training Systems Management", "Simulation & Modeling", "Exercise Design", "Program Management", "Instructional Design"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "59A", title: "Strategic Plans & Policy Officer", branch: .army,
            civilianTitles: ["Strategic Planning Director", "Policy Advisor", "Management Consultant"],
            bulletPoints: [
                "Developed and staffed strategic plans and policy documents at Army, Joint, and interagency levels",
                "Advised four-star commanders and senior civilians on strategy, force structure, and resource allocation",
                "Led strategic planning teams producing campaign plans and theater security cooperation strategies",
                "Represented the Army in interagency and coalition strategy forums with 15+ partner nations"
            ],
            skills: ["Strategic Planning", "Policy Development", "Executive Advisory", "Interagency Coordination", "Coalition Building"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "88A", title: "Transportation Officer", branch: .army,
            civilianTitles: ["VP of Transportation", "Logistics Operations Director", "Supply Chain Executive"],
            bulletPoints: [
                "Directed multi-modal transportation operations moving troops, equipment, and supplies across theater",
                "Managed a 300-person transportation battalion operating trucks, watercraft, and air cargo operations",
                "Coordinated with host-nation transportation providers and commercial carriers on strategic lift requirements",
                "Developed transportation synchronization plans supporting corps-level combat operations"
            ],
            skills: ["Transportation Management", "Multi-Modal Logistics", "Supply Chain Operations", "Budget Management", "Large Team Leadership"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "61A", title: "Medical Corps Officer (Physician)", branch: .army,
            civilianTitles: ["Physician", "Medical Director", "Healthcare Executive"],
            bulletPoints: [
                "Provided primary care, emergency medicine, and preventive healthcare for units of 500–5,000 soldiers",
                "Directed medical operations for a 200-bed combat support hospital in deployed environments",
                "Led a 60-person medical team delivering care across internal medicine, surgery, and mental health",
                "Developed medical readiness programs achieving 98% deployable status for assigned populations"
            ],
            skills: ["Clinical Medicine", "Healthcare Leadership", "Emergency Medicine", "Medical Operations", "Team Management"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "64A", title: "Veterinary Corps Officer", branch: .army,
            civilianTitles: ["Veterinarian", "Food Safety Director", "Public Health Officer"],
            bulletPoints: [
                "Provided veterinary care for military working dogs and other government-owned animals in garrison and deployed settings",
                "Directed food safety and quality assurance programs for dining facilities serving 5,000+ personnel daily",
                "Led zoonotic disease surveillance and public health programs protecting soldiers in austere environments",
                "Managed veterinary treatment facility operations and a team of veterinary technicians"
            ],
            skills: ["Veterinary Medicine", "Food Safety", "Public Health", "Laboratory Management", "Team Leadership"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "66A", title: "Army Nurse Corps Officer", branch: .army,
            civilianTitles: ["Registered Nurse", "Nursing Director", "Clinical Operations Manager"],
            bulletPoints: [
                "Delivered critical care and emergency nursing in combat support hospitals and forward surgical teams",
                "Led a nursing department of 30 nurses across ICU, emergency, and general medical-surgical wards",
                "Managed patient throughput and clinical quality for a treatment facility processing 200+ patients monthly",
                "Developed nursing protocols and training programs improving clinical outcomes and staff proficiency"
            ],
            skills: ["Critical Care Nursing", "Clinical Leadership", "Patient Management", "Quality Improvement", "Staff Development"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "67A", title: "Medical Service Corps Officer (Operations)", branch: .army,
            civilianTitles: ["Hospital Administrator", "Healthcare Operations Manager", "Health Systems Director"],
            bulletPoints: [
                "Directed medical logistics, health information management, and medical operations for a division",
                "Managed medical supply chain operations ensuring uninterrupted pharmaceutical and equipment availability",
                "Led healthcare administration for a military treatment facility serving 20,000+ beneficiaries",
                "Coordinated aeromedical evacuation operations transporting 500+ patients in a single deployment"
            ],
            skills: ["Healthcare Administration", "Medical Logistics", "Operations Management", "Patient Flow", "Budget Management"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "71A", title: "Medical Specialist Corps Officer (PT/OT/Dietitian)", branch: .army,
            civilianTitles: ["Physical Therapist", "Occupational Therapist", "Clinical Director"],
            bulletPoints: [
                "Provided physical therapy and rehabilitation services preventing and treating musculoskeletal injuries in high-demand populations",
                "Directed a rehabilitation department serving 150+ patients weekly across a large military installation",
                "Developed injury prevention programs reducing soldier profile rates by 20%",
                "Led a multidisciplinary team of PTs, OTs, and dietitians delivering comprehensive wellness services"
            ],
            skills: ["Physical/Occupational Therapy", "Rehabilitation", "Injury Prevention", "Clinical Program Management", "Interdisciplinary Care"],
            isOfficer: true
        )
    ]

    static let navy: [MilitaryCareer] = [
        MilitaryCareer(
            code: "BM", title: "Boatswain's Mate", branch: .navy,
            civilianTitles: ["Harbor Operations Manager", "Marine Deck Officer", "Port Operations Supervisor"],
            bulletPoints: [
                "Managed deck seamanship operations including mooring, anchoring, and underway replenishment",
                "Supervised deck crew of 10–25 sailors in maintenance and operational tasks",
                "Operated small boats and directed navigation in restricted waterways",
                "Maintained all deck equipment, lifesaving gear, and damage control systems"
            ],
            skills: ["Maritime Operations", "Team Supervision", "Navigation", "Equipment Maintenance", "Safety Management"]
        ),
        MilitaryCareer(
            code: "AC", title: "Air Traffic Controller", branch: .navy,
            civilianTitles: ["FAA Air Traffic Controller", "Airport Operations Specialist", "Aviation Coordinator"],
            bulletPoints: [
                "Controlled aircraft movements in controlled airspace with zero safety incidents over 1,000+ flight hours managed",
                "Coordinated sequencing and separation of military and civilian aircraft in high-traffic environments",
                "Operated radar, communication, and navigation aids to ensure safe and efficient traffic flow",
                "Trained junior controllers and evaluated their performance on certification checklists"
            ],
            skills: ["Air Traffic Control", "Radar Operations", "Communication", "High-Stakes Decision Making", "Aviation Safety"]
        ),
        MilitaryCareer(
            code: "CS", title: "Culinary Specialist", branch: .navy,
            civilianTitles: ["Executive Chef", "Food Service Manager", "Catering Operations Manager"],
            bulletPoints: [
                "Prepared and served meals for crews of 50–5,000 personnel aboard ships and shore stations",
                "Managed galley operations including menu planning, inventory management, and food safety compliance",
                "Supervised kitchen staff and maintained a sanitary, compliant food service environment",
                "Reduced food waste by 20% through improved portion control and inventory tracking"
            ],
            skills: ["Food Service Management", "Menu Planning", "Inventory Control", "Food Safety/ServSafe", "Team Leadership"]
        ),
        MilitaryCareer(
            code: "CT", title: "Cryptologic Technician", branch: .navy,
            civilianTitles: ["Cybersecurity Analyst", "Signals Intelligence Analyst", "Information Security Specialist"],
            bulletPoints: [
                "Collected and analyzed signals intelligence to support national and theater-level operations",
                "Operated classified communication and cryptographic systems under strict security protocols",
                "Produced intelligence reports and briefed findings to operational commanders",
                "Maintained COMSEC materials and ensured classified systems operated within NSA standards"
            ],
            skills: ["Signals Intelligence", "Cryptographic Operations", "Data Analysis", "Security Clearance Management", "Technical Reporting"]
        ),
        MilitaryCareer(
            code: "EM", title: "Electrician's Mate", branch: .navy,
            civilianTitles: ["Electrical Engineer", "Power Systems Technician", "Facilities Electrician"],
            bulletPoints: [
                "Operated and maintained shipboard electrical distribution systems including switchboards and generators",
                "Diagnosed and repaired electrical faults across AC/DC power systems on naval vessels",
                "Supervised electrical safety programs and ensured compliance with Navy electrical standards",
                "Conducted training on electrical safety and system operations for junior sailors"
            ],
            skills: ["Electrical Systems", "Power Distribution", "Fault Diagnosis", "Safety Compliance", "Team Training"]
        ),
        MilitaryCareer(
            code: "ET", title: "Electronics Technician", branch: .navy,
            civilianTitles: ["Electronics Engineer", "Avionics Technician", "Communications Systems Technician"],
            bulletPoints: [
                "Maintained and repaired shipboard radar, sonar, and communications electronic systems",
                "Performed diagnostic testing and calibration on complex electronic equipment",
                "Managed electronic parts inventory and coordinated with supply for timely equipment repair",
                "Trained junior technicians on maintenance procedures and troubleshooting techniques"
            ],
            skills: ["Electronics Repair", "Radar/Sonar Systems", "Calibration", "Technical Documentation", "Training & Mentorship"]
        ),
        MilitaryCareer(
            code: "HM", title: "Hospital Corpsman", branch: .navy,
            civilianTitles: ["Emergency Medical Technician", "Medical Assistant", "Surgical Technologist"],
            bulletPoints: [
                "Provided comprehensive medical care to Navy and Marine Corps personnel in shipboard, field, and clinical settings",
                "Assisted physicians and nurses in surgical procedures, emergency response, and inpatient care",
                "Trained Marines in combat first aid and Tactical Combat Casualty Care (TCCC)",
                "Maintained medical supply accountability and managed immunization records for 500+ personnel"
            ],
            skills: ["Emergency Medical Care", "Surgical Assistance", "Clinical Documentation", "Medical Training", "Patient Assessment"]
        ),
        MilitaryCareer(
            code: "IS", title: "Intelligence Specialist", branch: .navy,
            civilianTitles: ["Intelligence Analyst", "Geospatial Analyst", "Threat Assessment Specialist"],
            bulletPoints: [
                "Produced all-source intelligence products including threat assessments and target packages for naval operations",
                "Operated classified intelligence databases and imagery analysis systems",
                "Briefed operational commanders on current intelligence and emerging threats",
                "Collaborated with national-level agencies and joint intelligence teams"
            ],
            skills: ["Intelligence Analysis", "Imagery Analysis", "Report Writing", "Database Management", "Briefing & Presentation"]
        ),
        MilitaryCareer(
            code: "IT", title: "Information Systems Technician", branch: .navy,
            civilianTitles: ["Network Administrator", "IT Systems Specialist", "Cybersecurity Technician"],
            bulletPoints: [
                "Administered shipboard and shore-based computer networks supporting 500–2,000 users",
                "Maintained servers, routers, switches, and cybersecurity infrastructure to 99%+ uptime",
                "Enforced DoD cybersecurity compliance across all networked systems and user accounts",
                "Provided technical support and user training for military information systems"
            ],
            skills: ["Network Administration", "Cybersecurity", "Systems Administration", "Help Desk Support", "IT Compliance"]
        ),
        MilitaryCareer(
            code: "MA", title: "Master-at-Arms", branch: .navy,
            civilianTitles: ["Law Enforcement Officer", "Security Manager", "Loss Prevention Specialist"],
            bulletPoints: [
                "Enforced military law and maintained order on naval installations and vessels",
                "Conducted criminal investigations, collected evidence, and prepared case files",
                "Managed access control, installation security, and anti-terrorism force protection programs",
                "Operated K-9 programs and trained in crime scene processing"
            ],
            skills: ["Law Enforcement", "Criminal Investigation", "Security Management", "Force Protection", "Report Writing"]
        ),
        MilitaryCareer(
            code: "MC", title: "Mass Communication Specialist", branch: .navy,
            civilianTitles: ["Public Relations Specialist", "Journalist", "Digital Media Manager"],
            bulletPoints: [
                "Produced written, photo, and video content for internal and public audiences across multiple media platforms",
                "Covered military operations and human interest stories for Navy news outlets and national media",
                "Managed social media accounts and digital communications for commands of 1,000+ personnel",
                "Coordinated media embeds and public affairs operations during major exercises and deployments"
            ],
            skills: ["Journalism", "Photography/Videography", "Social Media Management", "Public Relations", "Content Production"]
        ),
        MilitaryCareer(
            code: "OS", title: "Operations Specialist", branch: .navy,
            civilianTitles: ["Operations Coordinator", "Air Traffic Specialist", "Maritime Logistics Manager"],
            bulletPoints: [
                "Operated radar, electronic warfare, and navigation systems in the Combat Information Center",
                "Tracked surface, subsurface, and air contacts and maintained the tactical picture for commanding officers",
                "Coordinated communication between ships, aircraft, and shore installations during complex operations",
                "Trained and evaluated junior OS personnel in combat system operation and watchstanding"
            ],
            skills: ["Radar Operations", "Tactical Communications", "Situational Awareness", "Operations Planning", "Team Training"]
        ),
        MilitaryCareer(
            code: "QM", title: "Quartermaster", branch: .navy,
            civilianTitles: ["Navigation Officer", "Maritime Logistics Specialist", "Vessel Operations Manager"],
            bulletPoints: [
                "Maintained celestial, electronic, and visual navigation for naval vessels in open ocean and restricted waters",
                "Prepared voyage plans and coordinated chart corrections using official hydrographic publications",
                "Maintained bridge navigation watch and supervised junior quartermasters",
                "Ensured all nautical charts and publications were current and compliant with navigational standards"
            ],
            skills: ["Navigation", "Maritime Charts", "Watchstanding", "Logistics Planning", "Technical Documentation"]
        ),
        MilitaryCareer(
            code: "SO", title: "Special Warfare Operator (Navy SEAL)", branch: .navy,
            civilianTitles: ["Federal Agent", "Defense Contractor — SOF", "Security & Intelligence Consultant"],
            bulletPoints: [
                "Planned and executed direct action, special reconnaissance, and unconventional warfare missions globally",
                "Led small teams in high-risk operations under extreme physical and psychological pressure",
                "Maintained expert proficiency in combat diving, military freefall, and advanced weapons systems",
                "Trained foreign special operations forces in maritime and land-based counterterrorism tactics"
            ],
            skills: ["Special Operations Leadership", "Mission Planning", "Physical & Mental Resilience", "Weapons Expertise", "Foreign Partner Training"]
        ),
        MilitaryCareer(
            code: "YN", title: "Yeoman", branch: .navy,
            civilianTitles: ["Administrative Assistant", "Office Manager", "Human Resources Coordinator"],
            bulletPoints: [
                "Managed personnel records, correspondence, and administrative functions for commands of 100–1,000 personnel",
                "Processed official naval correspondence, evaluations, awards, and personnel actions",
                "Prepared and briefed administrative reports to senior officers and department heads",
                "Maintained compliance with Navy administrative regulations and privacy act requirements"
            ],
            skills: ["Administrative Management", "Personnel Records", "Correspondence Writing", "Policy Compliance", "Office Operations"]
        ),
        // ─── NAVY OFFICERS ───
        MilitaryCareer(
            code: "1110", title: "Surface Warfare Officer", branch: .navy,
            civilianTitles: ["Ship Captain / Maritime Executive", "Operations Director", "Logistics & Transportation Manager"],
            bulletPoints: [
                "Commanded or served as department head aboard naval vessels with crews of 25–350 personnel",
                "Directed bridge watch operations, navigation, and ship handling in restricted waters and open ocean",
                "Managed a $15M department budget and oversaw maintenance of complex shipboard systems",
                "Led damage control training achieving zero sailor casualties in multiple emergency casualty events"
            ],
            skills: ["Maritime Leadership", "Operations Management", "Navigation", "Emergency Response", "Budget Management"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "1130", title: "Submarine Warfare Officer", branch: .navy,
            civilianTitles: ["Nuclear Plant Operations Manager", "Engineering Director", "National Security Consultant"],
            bulletPoints: [
                "Qualified as submarine officer of the deck, directing submerged and surface operations",
                "Led nuclear propulsion plant operations maintaining zero reactor safety incidents over 4 years",
                "Managed classified intelligence collection and special operations missions",
                "Supervised 8 division officers and 60 sailors in ship's engineering and navigation departments"
            ],
            skills: ["Nuclear Operations", "Engineering Leadership", "Classified Programs", "Technical Management", "Risk Management"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "1310", title: "Naval Aviator", branch: .navy,
            civilianTitles: ["Airline Pilot", "Aviation Safety Manager", "Flight Operations Director"],
            bulletPoints: [
                "Accumulated 2,000+ flight hours in tactical jet aircraft including carrier operations",
                "Led a 12-pilot strike fighter squadron through two combat deployments",
                "Managed aviation safety program achieving zero Class A mishaps over a 36-month period",
                "Instructed and evaluated junior pilots in advanced strike tactics and carrier qualification"
            ],
            skills: ["Fixed-Wing Aviation", "Aviation Safety", "Flight Instruction", "Operations Leadership", "Program Management"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "2100", title: "Naval Aviation Maintenance Officer", branch: .navy,
            civilianTitles: ["MRO Director", "Aviation Maintenance Manager", "Quality Assurance Director"],
            bulletPoints: [
                "Directed maintenance operations for a 12-aircraft squadron maintaining 85%+ mission-capable rate",
                "Managed a maintenance department of 120 technicians across 6 work centers",
                "Implemented quality assurance program reducing repeat maintenance discrepancies by 50%",
                "Managed $60M in aircraft, support equipment, and parts inventory"
            ],
            skills: ["Aviation Maintenance Leadership", "Quality Assurance", "Fleet Management", "Team Leadership", "Budget Management"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "2900", title: "Supply Corps Officer", branch: .navy,
            civilianTitles: ["VP of Supply Chain", "Procurement Director", "Logistics Operations Executive"],
            bulletPoints: [
                "Managed naval supply operations supporting ships and squadrons with 500–5,000 personnel",
                "Directed $100M+ in procurement, inventory management, and financial operations",
                "Led food service, retail, and fleet issue operations aboard aircraft carrier with 5,000-person crew",
                "Developed supply chain optimization initiatives saving $2M annually in procurement costs"
            ],
            skills: ["Supply Chain Management", "Procurement", "Financial Management", "Retail Operations", "Strategic Sourcing"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "2200", title: "Civil Engineer Corps Officer", branch: .navy,
            civilianTitles: ["Civil Engineer", "Construction Project Manager", "Facilities Director"],
            bulletPoints: [
                "Managed construction and facilities maintenance projects valued at $50M+ on Navy installations",
                "Led a 200-person Naval Mobile Construction Battalion (Seabee) in combat and humanitarian construction",
                "Directed environmental compliance and sustainability programs across a major naval installation",
                "Oversaw simultaneous execution of 20+ construction projects on time and within budget"
            ],
            skills: ["Civil Engineering", "Construction Management", "Facilities Management", "Environmental Compliance", "Program Management"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "2500", title: "Information Warfare Officer", branch: .navy,
            civilianTitles: ["Cybersecurity Director", "Information Operations Manager", "Intelligence Director"],
            bulletPoints: [
                "Directed information warfare operations integrating cyber, intelligence, and electronic warfare capabilities",
                "Led a 50-person intelligence and information operations department afloat and ashore",
                "Developed information warfare campaign plans adopted at fleet level",
                "Managed classified programs and interagency intelligence sharing relationships"
            ],
            skills: ["Information Operations", "Cybersecurity Leadership", "Intelligence Integration", "Strategic Planning", "Classified Program Management"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "2300", title: "JAG Corps Officer", branch: .navy,
            civilianTitles: ["Attorney", "Corporate Counsel", "Compliance & Ethics Officer"],
            bulletPoints: [
                "Prosecuted and defended courts-martial including sexual assault, fraud, and drug-related felony cases",
                "Advised commanding officers on military justice, administrative separations, and legal readiness",
                "Managed a legal assistance program serving 3,000+ sailors and family members annually",
                "Provided international law and law of armed conflict training to deploying units"
            ],
            skills: ["Military Law", "Criminal Litigation", "Compliance", "Legal Advising", "Client Services"],
            isOfficer: true
        )
    ]

    static let marines: [MilitaryCareer] = [
        MilitaryCareer(
            code: "0311", title: "Rifleman", branch: .marines,
            civilianTitles: ["Law Enforcement Officer", "Security Specialist", "Emergency Response Technician"],
            bulletPoints: [
                "Executed infantry operations including direct action, raids, and patrolling in complex environments",
                "Maintained expert proficiency with M16A4, M4, M27 IAR, and crew-served weapons",
                "Led fire team of 4 Marines in training and combat operations",
                "Performed physical fitness training and maintained personal and equipment readiness at all times"
            ],
            skills: ["Team Leadership", "Tactical Operations", "Weapons Proficiency", "Physical Fitness", "Mission Planning"]
        ),
        MilitaryCareer(
            code: "0321", title: "Reconnaissance Marine", branch: .marines,
            civilianTitles: ["Intelligence Analyst", "Security Consultant", "Federal Agent"],
            bulletPoints: [
                "Conducted deep reconnaissance operations behind enemy lines to gather and report critical intelligence",
                "Performed combat diving, military freefall, and direct action missions with Special Operations forces",
                "Planned and executed small-unit operations with minimal supervision in denied environments",
                "Trained partner forces in reconnaissance and direct action tactics"
            ],
            skills: ["Reconnaissance", "Intelligence Collection", "Small Unit Leadership", "Combat Diving/HALO", "High-Pressure Operations"]
        ),
        MilitaryCareer(
            code: "0411", title: "Maintenance Management Specialist", branch: .marines,
            civilianTitles: ["Fleet Manager", "Maintenance Planner", "Operations Analyst"],
            bulletPoints: [
                "Managed maintenance data collection and analysis for unit equipment fleets valued at $50M+",
                "Tracked maintenance schedules, equipment readiness rates, and parts requisition",
                "Advised commanders on equipment availability and readiness trends",
                "Maintained accuracy of maintenance management information systems (MIMMS)"
            ],
            skills: ["Fleet Management", "Data Analysis", "Operations Planning", "Logistics Software", "Report Writing"]
        ),
        MilitaryCareer(
            code: "0621", title: "Field Radio Operator", branch: .marines,
            civilianTitles: ["Communications Technician", "Radio Frequency Specialist", "Network Field Technician"],
            bulletPoints: [
                "Operated and maintained tactical HF/VHF/UHF radio systems in support of ground operations",
                "Established and maintained communication networks under time-critical and austere conditions",
                "Ensured COMSEC compliance and maintained communication equipment to 100% readiness",
                "Trained junior Marines on radio procedures, antenna assembly, and communication security"
            ],
            skills: ["Radio Communications", "COMSEC", "Field Maintenance", "Communications Planning", "Technical Training"]
        ),
        MilitaryCareer(
            code: "0651", title: "Cyber Network Operator", branch: .marines,
            civilianTitles: ["Network Administrator", "Cybersecurity Analyst", "IT Security Specialist"],
            bulletPoints: [
                "Administered and defended Marine Corps computer networks from cyber threats",
                "Performed network monitoring, vulnerability scanning, and incident response",
                "Configured routers, switches, and firewalls to maintain secure network operations",
                "Produced cyber incident reports and coordinated remediation actions with security teams"
            ],
            skills: ["Network Administration", "Cybersecurity", "Incident Response", "Network Monitoring", "Technical Reporting"]
        ),
        MilitaryCareer(
            code: "1371", title: "Combat Engineer", branch: .marines,
            civilianTitles: ["Construction Project Manager", "Civil Engineer", "Demolitions Safety Officer"],
            bulletPoints: [
                "Conducted breaching, mine clearing, and obstacle reduction operations in support of infantry missions",
                "Built and repaired roads, bridges, fighting positions, and field fortifications",
                "Operated combat engineering equipment including bulldozers, excavators, and mine-clearing systems",
                "Maintained demolition and explosive safety compliance during all construction operations"
            ],
            skills: ["Construction Management", "Demolitions Safety", "Heavy Equipment Operation", "Combat Engineering", "Project Execution"]
        ),
        MilitaryCareer(
            code: "3043", title: "Supply Administration and Operations", branch: .marines,
            civilianTitles: ["Supply Chain Manager", "Logistics Analyst", "Procurement Specialist"],
            bulletPoints: [
                "Managed supply chain operations for units of 200–5,000 Marines including requisition, receipt, and distribution",
                "Operated Marine Corps logistics systems to manage inventory valued at $10M+",
                "Coordinated with transportation and maintenance sections for integrated logistics support",
                "Produced supply status reports and briefed commanders on readiness-impacting shortfalls"
            ],
            skills: ["Supply Chain Management", "Logistics Systems", "Inventory Control", "Procurement", "Report Writing"]
        ),
        MilitaryCareer(
            code: "3521", title: "Motor Vehicle Mechanic", branch: .marines,
            civilianTitles: ["Fleet Mechanic", "Automotive Technician", "Diesel Engine Specialist"],
            bulletPoints: [
                "Maintained and repaired tactical wheeled vehicles including HMMWVs, MRAPs, and 7-ton trucks",
                "Diagnosed mechanical, electrical, and hydraulic faults using diagnostic tools and technical manuals",
                "Supervised vehicle maintenance operations for fleets of 15–50 vehicles",
                "Ensured vehicle readiness met operational requirements through proactive preventive maintenance"
            ],
            skills: ["Automotive/Diesel Mechanics", "Fleet Maintenance", "Electrical Diagnostics", "Technical Documentation", "Team Supervision"]
        ),
        MilitaryCareer(
            code: "4341", title: "Combat Correspondent", branch: .marines,
            civilianTitles: ["Journalist", "Public Affairs Officer", "Digital Content Manager"],
            bulletPoints: [
                "Reported, photographed, and filmed military operations for internal and media distribution",
                "Produced news articles, press releases, and multimedia content for USMC public affairs",
                "Managed media relations and coordinated press embeds during major operations and exercises",
                "Maintained social media platforms and digital newsroom for commands of 1,000+ Marines"
            ],
            skills: ["Journalism", "Photography/Videography", "Media Relations", "Social Media Management", "Content Writing"]
        ),
        MilitaryCareer(
            code: "5811", title: "Military Police", branch: .marines,
            civilianTitles: ["Law Enforcement Officer", "Security Manager", "Criminal Investigator"],
            bulletPoints: [
                "Enforced laws, regulations, and orders to maintain discipline across Marine Corps installations",
                "Investigated criminal incidents, collected evidence, and prepared formal investigative reports",
                "Managed detention operations and processed detainees in compliance with law of armed conflict",
                "Provided force protection and physical security for critical facilities and personnel"
            ],
            skills: ["Law Enforcement", "Criminal Investigation", "Force Protection", "Report Writing", "De-escalation"]
        ),
        MilitaryCareer(
            code: "6212", title: "Helicopter Mechanic", branch: .marines,
            civilianTitles: ["Aviation Mechanic (A&P)", "Helicopter Maintenance Technician", "Aerospace Ground Equipment Technician"],
            bulletPoints: [
                "Performed organizational-level maintenance on CH-53, AH-1Z, and UH-1Y rotary wing aircraft",
                "Conducted pre- and post-flight inspections and troubleshot mechanical and avionics discrepancies",
                "Documented maintenance actions in NALCOMIS aviation maintenance information systems",
                "Maintained aircraft airworthiness in compliance with NATOPS and MIL-SPEC standards"
            ],
            skills: ["Aviation Maintenance", "Rotary Wing Systems", "Avionics Troubleshooting", "Technical Documentation", "Safety Compliance"]
        ),
        // ─── MARINE CORPS OFFICERS ───
        MilitaryCareer(
            code: "0302", title: "Infantry Officer", branch: .marines,
            civilianTitles: ["Operations Director", "Law Enforcement Commander", "Security Executive"],
            bulletPoints: [
                "Commanded a Marine infantry company of 180+ Marines through combat deployments and sustained training",
                "Planned and executed amphibious, air assault, and ground offensive operations in complex environments",
                "Managed a $3.5M equipment budget with zero loss or reportable deficiency",
                "Developed and executed training plans improving unit combat readiness scores by 25%"
            ],
            skills: ["Operations Leadership", "Strategic Planning", "Budget Management", "Team Development", "Crisis Decision Making"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "0202", title: "Intelligence Officer", branch: .marines,
            civilianTitles: ["Intelligence Director", "Risk & Threat Analyst", "Research Director"],
            bulletPoints: [
                "Directed all-source intelligence operations for a Marine regiment of 3,500 personnel",
                "Produced intelligence assessments and targeting products supporting combat operations across multiple theaters",
                "Managed classified information programs and security protocols for sensitive operations",
                "Built and led a 25-person intelligence section integrating HUMINT, SIGINT, and imagery capabilities"
            ],
            skills: ["Intelligence Leadership", "All-Source Analysis", "Targeting", "Classified Program Management", "Team Leadership"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "0402", title: "Logistics Officer", branch: .marines,
            civilianTitles: ["VP of Logistics", "Supply Chain Director", "Operations Executive"],
            bulletPoints: [
                "Directed integrated logistics operations sustaining a Marine regiment of 3,500 across three countries",
                "Managed $120M in equipment, supply, and transportation assets with zero reportable loss",
                "Led 200-person combat logistics battalion in direct support of ground combat operations",
                "Developed logistics synchronization plans that reduced supply delays by 45%"
            ],
            skills: ["Logistics Leadership", "Supply Chain Management", "Transportation Management", "Budget Management", "Operations Planning"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "0602", title: "Communications Officer", branch: .marines,
            civilianTitles: ["IT Director", "Network Operations Manager", "Telecommunications Executive"],
            bulletPoints: [
                "Directed communications network operations supporting 5,000+ Marines across a dispersed battlespace",
                "Managed a $8M communications equipment budget and a 60-person communications platoon",
                "Led integration of satellite, radio, and data network systems for distributed maritime operations",
                "Developed communication standard operating procedures adopted at Marine Expeditionary Force level"
            ],
            skills: ["Network Operations", "IT Management", "Communications Planning", "Budget Management", "Team Leadership"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "4302", title: "Public Affairs Officer", branch: .marines,
            civilianTitles: ["VP of Communications", "Public Relations Director", "Media Relations Executive"],
            bulletPoints: [
                "Directed strategic communications for a Marine division of 20,000 personnel",
                "Managed media relations during high-profile operations, coordinating 50+ press embeds and media events",
                "Developed and executed social media strategy growing official channels by 200%",
                "Advised the commanding general on communication strategy and reputational risk"
            ],
            skills: ["Strategic Communications", "Executive Advisory", "Media Relations", "Crisis Communications", "Brand Management"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "5803", title: "Military Police Officer", branch: .marines,
            civilianTitles: ["Chief of Police", "Director of Security", "Law Enforcement Executive"],
            bulletPoints: [
                "Commanded a military police company of 120 Marines providing law enforcement and force protection",
                "Directed criminal investigation operations and collaborated with NCIS and civilian law enforcement agencies",
                "Managed installation security and anti-terrorism force protection programs for a major Marine base",
                "Led detainee operations and ensured compliance with law of armed conflict and DoD directives"
            ],
            skills: ["Law Enforcement Leadership", "Criminal Investigation", "Security Management", "Policy Compliance", "Community Relations"],
            isOfficer: true
        )
    ]

    static let airForce: [MilitaryCareer] = [
        MilitaryCareer(
            code: "1C1X1", title: "Air Traffic Controller", branch: .airForce,
            civilianTitles: ["FAA Air Traffic Controller", "Airport Operations Specialist", "Aviation Safety Officer"],
            bulletPoints: [
                "Controlled sequencing and separation of military and civilian aircraft in radar and non-radar environments",
                "Managed up to 30 aircraft simultaneously in high-traffic terminal and en-route airspace",
                "Issued IFR/VFR clearances and coordinated airspace with adjacent facilities",
                "Trained and evaluated student controllers on position certifications"
            ],
            skills: ["Air Traffic Control", "Aviation Safety", "Radar Operations", "High-Stakes Decision Making", "Communication"]
        ),
        MilitaryCareer(
            code: "1C2X1", title: "Combat Controller", branch: .airForce,
            civilianTitles: ["FAA Air Traffic Controller", "Federal Agent", "Emergency Operations Coordinator"],
            bulletPoints: [
                "Embedded with special operations forces to establish assault zones and control close air support",
                "Directed airstrikes and coordinated fires for ground forces in direct contact with enemy",
                "Maintained FAA air traffic control certification while serving as a combat-qualified special operator",
                "Conducted military freefall, combat diving, and direct action missions behind enemy lines"
            ],
            skills: ["Air Traffic Control", "Special Operations", "Close Air Support", "Mission Planning", "Leadership Under Pressure"]
        ),
        MilitaryCareer(
            code: "1C4X1", title: "Tactical Air Control Party", branch: .airForce,
            civilianTitles: ["Operations Coordinator", "Aviation Liaison", "Emergency Communications Specialist"],
            bulletPoints: [
                "Directed close air support, air interdiction, and armed reconnaissance for ground forces",
                "Coordinated airspace deconfliction and fire support integration in complex, dynamic environments",
                "Provided real-time targeting data and battle damage assessment to aircrews and commanders",
                "Trained Army and joint force partners on requesting and controlling tactical air support"
            ],
            skills: ["Close Air Support", "Fire Support Coordination", "Airspace Management", "Tactical Communications", "Joint Operations"]
        ),
        MilitaryCareer(
            code: "1N0X1", title: "All Source Intelligence Analyst", branch: .airForce,
            civilianTitles: ["Intelligence Analyst", "Research Analyst", "Threat Assessment Specialist"],
            bulletPoints: [
                "Fused HUMINT, SIGINT, IMINT, and open-source intelligence to produce all-source analytical products",
                "Briefed senior commanders on adversary capabilities, intentions, and courses of action",
                "Developed and maintained intelligence databases to track emerging threats",
                "Collaborated with national intelligence community to support operational planning"
            ],
            skills: ["All-Source Analysis", "Intelligence Fusion", "Report Writing", "Database Management", "Briefing & Presentation"]
        ),
        MilitaryCareer(
            code: "1N1X1", title: "Geospatial Intelligence", branch: .airForce,
            civilianTitles: ["Geospatial Analyst", "Remote Sensing Specialist", "GIS Analyst"],
            bulletPoints: [
                "Produced geospatial intelligence products from satellite and aerial imagery for operational planning",
                "Operated GIS software and imagery analysis tools to support intelligence and targeting requirements",
                "Provided terrain analysis, infrastructure mapping, and change detection products to commanders",
                "Collaborated with national geospatial agencies on time-sensitive intelligence requirements"
            ],
            skills: ["GIS Analysis", "Imagery Analysis", "Remote Sensing", "Geospatial Products", "Technical Reporting"]
        ),
        MilitaryCareer(
            code: "1N3X1", title: "Cryptologic Language Analyst", branch: .airForce,
            civilianTitles: ["Translator/Interpreter", "Intelligence Analyst", "Linguistic Specialist"],
            bulletPoints: [
                "Translated and analyzed foreign language signals intelligence to produce time-sensitive reports",
                "Provided real-time linguistic support during joint and special operations missions",
                "Identified cultural context and subtext to enhance intelligence reporting accuracy",
                "Maintained proficiency in target language through continuous training and assessment"
            ],
            skills: ["Foreign Language Proficiency", "Translation & Interpretation", "Intelligence Analysis", "Cultural Expertise", "Reporting"]
        ),
        MilitaryCareer(
            code: "1W0X1", title: "Weather Specialist", branch: .airForce,
            civilianTitles: ["Meteorologist", "Environmental Analyst", "Aviation Weather Specialist"],
            bulletPoints: [
                "Prepared and delivered weather forecasts in support of flight operations, ground maneuvers, and special operations",
                "Operated and maintained surface weather observation and radiosonde systems",
                "Provided severe weather warnings and tactical weather support to commanders",
                "Collaborated with National Weather Service and joint meteorological teams on regional forecasts"
            ],
            skills: ["Meteorology", "Aviation Weather", "Environmental Analysis", "Data Interpretation", "Technical Reporting"]
        ),
        MilitaryCareer(
            code: "2A3X3", title: "Tactical Aircraft Maintenance", branch: .airForce,
            civilianTitles: ["Aircraft Mechanic (A&P)", "Aerospace Maintenance Technician", "Aviation Quality Inspector"],
            bulletPoints: [
                "Performed phase, isochronal, and on-equipment maintenance on F-16/F-35/A-10 tactical aircraft",
                "Troubleshot and repaired airframe, engine, and hydraulic systems using technical orders",
                "Documented maintenance actions in the Integrated Maintenance Data System (IMDS)",
                "Ensured aircraft met mission-capable standards through rigorous pre- and post-flight inspections"
            ],
            skills: ["Aircraft Maintenance", "Hydraulics/Pneumatics", "Technical Order Compliance", "Aviation Safety", "Fault Diagnosis"]
        ),
        MilitaryCareer(
            code: "2A6X1", title: "Aerospace Propulsion", branch: .airForce,
            civilianTitles: ["Jet Engine Mechanic", "Aerospace Propulsion Technician", "Aviation Maintenance Engineer"],
            bulletPoints: [
                "Performed engine removal, installation, inspection, and repair on turbofan and turboprop engines",
                "Diagnosed and repaired compressor, combustion, and turbine section faults",
                "Operated engine test cell equipment and documented all engine performance data",
                "Maintained zero-defect standards in high-consequence propulsion maintenance operations"
            ],
            skills: ["Jet Engine Maintenance", "Engine Diagnostics", "Test Cell Operations", "Technical Documentation", "Safety Compliance"]
        ),
        MilitaryCareer(
            code: "2F0X1", title: "Fuels", branch: .airForce,
            civilianTitles: ["Petroleum Operations Manager", "Fuels Distribution Specialist", "Environmental Compliance Officer"],
            bulletPoints: [
                "Managed bulk fuel storage and distribution systems supporting 50+ aircraft and 500+ vehicles",
                "Operated R-11 and R-12 aircraft refueling vehicles and ground fuel equipment",
                "Maintained quality control and environmental compliance for fuel operations",
                "Supervised fuels operations teams and ensured safe handling of Class III hazardous materials"
            ],
            skills: ["Petroleum Operations", "Hazmat Handling", "Fuel Quality Control", "Environmental Compliance", "Team Supervision"]
        ),
        MilitaryCareer(
            code: "3D0X2", title: "Cyber Systems Operations", branch: .airForce,
            civilianTitles: ["Cybersecurity Operations Analyst", "Network Defense Specialist", "SOC Analyst"],
            bulletPoints: [
                "Operated and defended Air Force networks against cyber threats and intrusions",
                "Monitored security information and event management (SIEM) tools for anomalous activity",
                "Performed vulnerability assessments and coordinated remediation with system owners",
                "Contributed to incident response operations and produced post-incident reports"
            ],
            skills: ["Cybersecurity Operations", "Network Defense", "SIEM Tools", "Vulnerability Assessment", "Incident Response"]
        ),
        MilitaryCareer(
            code: "3E7X1", title: "Fire Protection", branch: .airForce,
            civilianTitles: ["Firefighter/EMT", "Fire Protection Specialist", "Emergency Services Manager"],
            bulletPoints: [
                "Responded to aircraft, structural, and hazardous materials emergencies on Air Force installations",
                "Operated aerial firefighting apparatus and rescue equipment in time-critical situations",
                "Conducted fire prevention inspections and developed fire safety plans for facilities",
                "Trained personnel in fire suppression, evacuation procedures, and emergency response"
            ],
            skills: ["Firefighting", "Emergency Medical Response", "Aircraft Rescue", "Hazmat Operations", "Safety Training"]
        ),
        MilitaryCareer(
            code: "3E8X1", title: "Explosive Ordnance Disposal", branch: .airForce,
            civilianTitles: ["EOD Technician", "Hazmat Specialist", "Bomb Disposal Technician"],
            bulletPoints: [
                "Rendered safe and disposed of conventional, nuclear, biological, and chemical explosive hazards",
                "Supported law enforcement agencies and deployed alongside special operations forces",
                "Operated robotic systems and specialized tools to investigate and neutralize IEDs",
                "Provided subject matter expertise in explosive hazard identification and threat assessment"
            ],
            skills: ["EOD Operations", "Risk Management", "Robotics Operation", "Hazmat Response", "Decision Making Under Pressure"]
        ),
        MilitaryCareer(
            code: "3N0X1", title: "Public Affairs", branch: .airForce,
            civilianTitles: ["Public Relations Manager", "Communications Director", "Journalist"],
            bulletPoints: [
                "Developed and executed strategic communication plans for commands of 1,000–10,000 personnel",
                "Managed media relations including press conferences, interviews, and crisis communications",
                "Produced written, photo, and broadcast content for internal and public audiences",
                "Advised senior commanders on communication strategy and reputational risk management"
            ],
            skills: ["Strategic Communications", "Media Relations", "Content Production", "Crisis Communications", "Executive Advisory"]
        ),
        MilitaryCareer(
            code: "3P0X1", title: "Security Forces", branch: .airForce,
            civilianTitles: ["Law Enforcement Officer", "Security Manager", "Force Protection Specialist"],
            bulletPoints: [
                "Enforced law and order on Air Force installations protecting assets valued at billions of dollars",
                "Managed nuclear security operations and high-security area access control",
                "Conducted criminal investigations and processed crime scenes in collaboration with OSI",
                "Led Quick Reaction Force and anti-terrorism force protection operations"
            ],
            skills: ["Law Enforcement", "Force Protection", "Nuclear Security", "Criminal Investigation", "Emergency Response"]
        ),
        MilitaryCareer(
            code: "4N0X1", title: "Aerospace Medical Service", branch: .airForce,
            civilianTitles: ["Emergency Medical Technician", "Medical Assistant", "Flight Medic"],
            bulletPoints: [
                "Provided emergency and primary medical care to aircrew and personnel at Air Force installations",
                "Performed aeromedical evacuation missions transporting critical patients via military aircraft",
                "Assisted physicians in clinical and urgent care settings across multiple specialties",
                "Maintained medical readiness for rapid deployment in support of special operations and contingency missions"
            ],
            skills: ["Emergency Medical Care", "Aeromedical Evacuation", "Clinical Assistance", "Patient Assessment", "Medical Readiness"]
        ),
        MilitaryCareer(
            code: "6C0X1", title: "Contracting", branch: .airForce,
            civilianTitles: ["Contract Specialist", "Procurement Officer", "Government Acquisitions Manager"],
            bulletPoints: [
                "Awarded and administered government contracts valued from $5K to $100M+ in support of Air Force missions",
                "Ensured compliance with Federal Acquisition Regulation and DoD acquisition directives",
                "Negotiated contract terms, pricing, and performance requirements with commercial vendors",
                "Provided acquisition advisory services to program managers and commanders"
            ],
            skills: ["Government Contracting", "Procurement", "Federal Acquisition Regulation", "Negotiation", "Contract Administration"]
        ),
        // ─── AIR FORCE OFFICERS ───
        MilitaryCareer(
            code: "11X", title: "Pilot (Fighter/Bomber/Mobility)", branch: .airForce,
            civilianTitles: ["Commercial Airline Pilot", "Aviation Safety Director", "Flight Operations Manager"],
            bulletPoints: [
                "Accumulated 2,500+ flight hours in high-performance military aircraft including combat sorties",
                "Led a 20-pilot squadron through operational deployments maintaining zero safety mishaps",
                "Qualified as instructor pilot, evaluating and training 30+ student pilots to mission-ready status",
                "Managed $200M aviation program including flight scheduling, maintenance coordination, and mission planning"
            ],
            skills: ["Fixed-Wing Aviation", "Flight Instruction", "Aviation Safety", "Program Management", "Team Leadership"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "12X", title: "Combat Systems Officer", branch: .airForce,
            civilianTitles: ["Aviation Systems Analyst", "Defense Systems Engineer", "Avionics Program Manager"],
            bulletPoints: [
                "Operated advanced weapons, navigation, and sensor systems aboard B-52, B-1, B-2, and E-3 aircraft",
                "Led targeting and electronic warfare operations supporting theater-level combat campaigns",
                "Managed avionics systems integration programs and recommended upgrades based on operational feedback",
                "Trained and evaluated student CSOs in mission systems operation and crew coordination"
            ],
            skills: ["Avionics Systems", "Electronic Warfare", "Targeting", "Systems Integration", "Flight Crew Leadership"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "13S", title: "Space Operations Officer", branch: .airForce,
            civilianTitles: ["Satellite Program Manager", "Space Systems Engineer", "Defense Contractor — Space"],
            bulletPoints: [
                "Directed satellite command and control operations for strategic space assets 24/7/365",
                "Managed space situational awareness and conjunction analysis for a constellation of 20+ satellites",
                "Led a 40-person space operations squadron achieving 99.9% mission uptime",
                "Collaborated with NRO, NGA, and commercial space providers on joint operations and data sharing"
            ],
            skills: ["Space Systems Management", "Satellite Operations", "Program Management", "Interagency Coordination", "Operations Leadership"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "14N", title: "Intelligence Officer", branch: .airForce,
            civilianTitles: ["Intelligence Director", "Senior Analyst", "National Security Consultant"],
            bulletPoints: [
                "Directed intelligence operations for an air wing supporting 100+ aircraft and 3,000 personnel",
                "Produced all-source intelligence assessments directly informing combatant command targeting decisions",
                "Managed a 30-person intelligence flight across imagery, signals, and all-source disciplines",
                "Briefed senior DoD leaders and interagency partners on adversary air and missile threats"
            ],
            skills: ["Intelligence Leadership", "All-Source Analysis", "Executive Briefing", "Targeting", "Interagency Coordination"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "17D", title: "Cyberspace Operations Officer", branch: .airForce,
            civilianTitles: ["Chief Information Security Officer", "Cybersecurity Director", "Cyber Operations Manager"],
            bulletPoints: [
                "Led Air Force cyber operations defending networks and critical infrastructure against nation-state threats",
                "Directed a 50-person cyber operations team executing offensive and defensive cyber missions",
                "Developed cyber campaign plans in coordination with US Cyber Command and NSA",
                "Managed $15M in cybersecurity infrastructure and tools across multiple classification levels"
            ],
            skills: ["Cybersecurity Leadership", "Offensive/Defensive Cyber", "Program Management", "Interagency Operations", "Team Leadership"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "21A", title: "Aircraft Maintenance Officer", branch: .airForce,
            civilianTitles: ["MRO Director", "VP of Technical Operations", "Aviation Maintenance Executive"],
            bulletPoints: [
                "Directed maintenance operations for a 24-aircraft wing maintaining 90%+ mission-capable rates",
                "Managed a maintenance group of 600 technicians across 8 aircraft systems specialties",
                "Led $80M depot-level maintenance programs on time and under budget",
                "Implemented LEAN maintenance practices reducing aircraft turnaround time by 30%"
            ],
            skills: ["Aviation Maintenance Leadership", "LEAN/Process Improvement", "Fleet Management", "Budget Management", "Large Team Leadership"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "31P", title: "Security Forces Officer", branch: .airForce,
            civilianTitles: ["Director of Security", "Police Chief", "Corporate Security Executive"],
            bulletPoints: [
                "Commanded a security forces squadron of 300 personnel protecting $2B+ in Air Force assets",
                "Directed nuclear security operations and anti-terrorism force protection programs",
                "Led law enforcement operations and collaborated with FBI and civilian agencies on joint investigations",
                "Developed installation security plans and emergency response protocols adopted base-wide"
            ],
            skills: ["Security Leadership", "Force Protection", "Nuclear Security", "Law Enforcement Management", "Emergency Planning"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "38F", title: "Force Support Officer", branch: .airForce,
            civilianTitles: ["HR Director", "Chief People Officer", "Talent & Workforce Manager"],
            bulletPoints: [
                "Directed human resources, manpower, and personnel programs for an Air Force wing of 5,000+",
                "Led force support squadron delivering services including fitness, lodging, food service, and mortuary affairs",
                "Managed $10M in morale, welfare, and recreation programs and retail operations",
                "Advised wing commander on workforce planning, retention, and quality-of-life initiatives"
            ],
            skills: ["HR Leadership", "Workforce Planning", "Retail & Services Management", "Budget Management", "Executive Advisory"],
            isOfficer: true
        )
    ]

    static let coastGuard: [MilitaryCareer] = [
        MilitaryCareer(
            code: "BM", title: "Boatswain's Mate", branch: .coastGuard,
            civilianTitles: ["Harbor Pilot", "Marine Operations Manager", "Port Safety Officer"],
            bulletPoints: [
                "Operated small boats and cutters in search and rescue, law enforcement, and port security operations",
                "Conducted maritime law enforcement boardings to enforce federal laws and international agreements",
                "Maintained deck equipment, navigation gear, and safety systems on Coast Guard assets",
                "Trained junior personnel in seamanship, navigation, and maritime law enforcement procedures"
            ],
            skills: ["Maritime Operations", "Search & Rescue", "Law Enforcement", "Navigation", "Team Leadership"]
        ),
        MilitaryCareer(
            code: "HS", title: "Health Services Technician", branch: .coastGuard,
            civilianTitles: ["Emergency Medical Technician", "Medical Assistant", "Physician Assistant"],
            bulletPoints: [
                "Provided independent duty medical care as sole healthcare provider for cutters with no physician onboard",
                "Managed medical emergencies at sea and coordinated medevac operations with Coast Guard aviation",
                "Conducted physical exams, sick call, and preventive health screenings for ship personnel",
                "Maintained medical records, supply accountability, and immunization compliance for assigned crews"
            ],
            skills: ["Emergency Medical Care", "Independent Duty Medicine", "Medevac Coordination", "Clinical Documentation", "Patient Management"]
        ),
        MilitaryCareer(
            code: "IT", title: "Information Systems Technician", branch: .coastGuard,
            civilianTitles: ["Network Administrator", "IT Specialist", "Cybersecurity Analyst"],
            bulletPoints: [
                "Managed Coast Guard network infrastructure supporting communications and operational systems",
                "Maintained satellite communication, radio, and data systems aboard cutters and shore stations",
                "Enforced cybersecurity compliance across classified and unclassified systems",
                "Provided tier-1 through tier-3 technical support for 50–500 end users"
            ],
            skills: ["Network Administration", "Satellite Communications", "Cybersecurity", "IT Support", "Technical Troubleshooting"]
        ),
        MilitaryCareer(
            code: "ME", title: "Maritime Enforcement Specialist", branch: .coastGuard,
            civilianTitles: ["Federal Law Enforcement Officer", "Customs & Border Agent", "Homeland Security Specialist"],
            bulletPoints: [
                "Conducted maritime law enforcement boardings on domestic and foreign vessels",
                "Enforced federal drug, immigration, and fisheries laws in U.S. and international waters",
                "Led tactical boarding teams as use-of-force certified officer",
                "Collaborated with DEA, CBP, and foreign law enforcement agencies on joint interdiction operations"
            ],
            skills: ["Federal Law Enforcement", "Maritime Boarding", "Use of Force", "Drug Interdiction", "Interagency Coordination"]
        ),
        MilitaryCareer(
            code: "MK", title: "Machinery Technician", branch: .coastGuard,
            civilianTitles: ["Marine Engineer", "Diesel Mechanic", "Industrial Machinery Technician"],
            bulletPoints: [
                "Operated and maintained propulsion, electrical, and damage control systems on Coast Guard cutters",
                "Diagnosed and repaired diesel engines, hydraulic systems, and pumping equipment",
                "Conducted preventive maintenance and ensured engineering plant readiness for all underway operations",
                "Trained crew in engineering casualty control and damage control procedures"
            ],
            skills: ["Marine Engineering", "Diesel Engine Maintenance", "Hydraulic Systems", "Damage Control", "Preventive Maintenance"]
        ),
        MilitaryCareer(
            code: "MST", title: "Marine Science Technician", branch: .coastGuard,
            civilianTitles: ["Environmental Compliance Officer", "Hazmat Inspector", "Port Safety Specialist"],
            bulletPoints: [
                "Investigated marine casualties, pollution incidents, and vessel safety violations",
                "Conducted port safety exams and environmental compliance inspections on commercial vessels",
                "Managed oil spill response operations and coordinated cleanup with federal and industry partners",
                "Enforced MARPOL, Clean Water Act, and international maritime environmental regulations"
            ],
            skills: ["Environmental Compliance", "Marine Casualty Investigation", "Pollution Response", "Regulatory Enforcement", "Report Writing"]
        ),
        // ─── COAST GUARD OFFICERS ───
        MilitaryCareer(
            code: "OPS", title: "Operations Officer", branch: .coastGuard,
            civilianTitles: ["Port Operations Director", "Maritime Safety Manager", "Logistics Operations Executive"],
            bulletPoints: [
                "Directed cutter operations including search and rescue, law enforcement, and port security missions",
                "Managed operational planning and resource allocation for a Marine Safety unit covering 500 miles of coastline",
                "Led interagency coordination with CBP, DEA, and local law enforcement on maritime law enforcement operations",
                "Commanded cutter with crew of 75, responsible for vessel readiness, personnel, and mission execution"
            ],
            skills: ["Maritime Operations", "Interagency Coordination", "Search & Rescue Leadership", "Crew Management", "Emergency Planning"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "AVOPS", title: "Aviation Officer", branch: .coastGuard,
            civilianTitles: ["Commercial Pilot", "Aviation Safety Officer", "Flight Operations Manager"],
            bulletPoints: [
                "Accumulated 2,000+ flight hours in C-130, MH-60, and MH-65 aircraft on SAR and law enforcement missions",
                "Led aviation unit delivering search and rescue response with average on-scene time under 30 minutes",
                "Managed flight safety program achieving zero Class A/B mishaps over a 4-year period",
                "Coordinated multi-agency air operations with Navy, Air Force, and civilian aviation authorities"
            ],
            skills: ["Multi-Engine Aviation", "Search & Rescue", "Aviation Safety", "Interagency Coordination", "Operations Leadership"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "LLAW", title: "Maritime Law Enforcement Officer", branch: .coastGuard,
            civilianTitles: ["Federal Agent", "Customs & Border Officer", "Homeland Security Director"],
            bulletPoints: [
                "Led maritime law enforcement operations seizing $500M+ in illicit narcotics over a 6-year career",
                "Commanded boarding teams conducting 200+ high-risk law enforcement boardings on domestic and foreign vessels",
                "Developed and delivered maritime law enforcement training to partner-nation coast guards in 8 countries",
                "Collaborated with DEA, FBI, Homeland Security, and international partners on joint interdiction campaigns"
            ],
            skills: ["Federal Law Enforcement", "Narcotics Interdiction", "International Partnerships", "Tactical Leadership", "Training & Development"],
            isOfficer: true
        )
    ]

    static let spaceForce: [MilitaryCareer] = [
        MilitaryCareer(
            code: "1C6X1", title: "Space Systems Operations", branch: .spaceForce,
            civilianTitles: ["Satellite Systems Operator", "Space Operations Engineer", "Mission Control Specialist"],
            bulletPoints: [
                "Operated and maintained satellite command and control systems for strategic and tactical space assets",
                "Monitored satellite health, attitude control, and payload operations in 24/7 shift environment",
                "Detected and responded to satellite anomalies to maintain mission continuity",
                "Coordinated with interagency partners on space situational awareness and conjunction analysis"
            ],
            skills: ["Satellite Operations", "Space Systems", "Mission Control", "Anomaly Resolution", "24/7 Operations"]
        ),
        MilitaryCareer(
            code: "1D7X1", title: "Cyberspace Defense", branch: .spaceForce,
            civilianTitles: ["Cybersecurity Analyst", "Network Defense Specialist", "Information Security Engineer"],
            bulletPoints: [
                "Defended Space Force networks and space systems from cyber intrusions and adversarial exploitation",
                "Conducted continuous monitoring, threat hunting, and incident response for critical space assets",
                "Performed vulnerability assessments and implemented hardening measures on mission systems",
                "Produced cyber threat intelligence reports and coordinated with US Cyber Command on joint operations"
            ],
            skills: ["Cyber Defense", "Threat Hunting", "Incident Response", "Vulnerability Management", "Threat Intelligence"]
        ),
        MilitaryCareer(
            code: "1N0X1", title: "All Source Intelligence (Space)", branch: .spaceForce,
            civilianTitles: ["Space Intelligence Analyst", "National Security Analyst", "Geospatial Intelligence Specialist"],
            bulletPoints: [
                "Analyzed adversary space capabilities and produced intelligence assessments for Space Force commanders",
                "Tracked foreign satellite programs and assessed threats to U.S. space assets",
                "Fused multi-source intelligence to support space situational awareness operations",
                "Briefed senior leaders on adversary space order of battle and operational implications"
            ],
            skills: ["Space Intelligence", "All-Source Analysis", "Threat Assessment", "Briefing & Presentation", "Research"]
        ),
        // ─── SPACE FORCE OFFICERS ───
        MilitaryCareer(
            code: "13S-O", title: "Space Operations Officer (USSF)", branch: .spaceForce,
            civilianTitles: ["Satellite Program Manager", "Space Systems Director", "Defense Technology Executive"],
            bulletPoints: [
                "Led space operations squadron of 40 Guardians managing command and control of strategic satellite constellations",
                "Directed space domain awareness operations tracking 500+ resident space objects daily",
                "Managed $30M satellite operations program maintaining 99.9% mission availability",
                "Advised combatant commanders on space support, space control, and space force application"
            ],
            skills: ["Space Operations Leadership", "Satellite Management", "Program Management", "Executive Advisory", "Strategic Planning"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "17D-O", title: "Cyber Officer (USSF)", branch: .spaceForce,
            civilianTitles: ["CISO", "Cyber Program Director", "Information Security Executive"],
            bulletPoints: [
                "Directed cyber defense operations protecting Space Force satellite and ground control networks",
                "Led offensive cyber planning in coordination with US Cyber Command for space-related infrastructure",
                "Managed a $12M cybersecurity program and a 30-person cyber operations team",
                "Developed zero-trust architecture implementation roadmap adopted across Space Force installations"
            ],
            skills: ["Cybersecurity Leadership", "Zero Trust Architecture", "Offensive Cyber", "Program Management", "Team Leadership"],
            isOfficer: true
        ),
        MilitaryCareer(
            code: "63A", title: "Acquisition Officer (Space Systems)", branch: .spaceForce,
            civilianTitles: ["Program Manager — Space", "Defense Acquisitions Director", "Technology Program Executive"],
            bulletPoints: [
                "Managed acquisition programs for next-generation satellite communication systems valued at $1.2B",
                "Led source selection teams evaluating contractor proposals and awarding major defense contracts",
                "Coordinated with contractors, DoD stakeholders, and Congress on program budget and schedule",
                "Implemented Agile acquisition practices reducing program milestone delays by 40%"
            ],
            skills: ["Defense Acquisitions", "Program Management", "Contract Management", "Stakeholder Coordination", "Agile Methods"],
            isOfficer: true
        )
    ]
}
