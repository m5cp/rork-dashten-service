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

    init(code: String, title: String, branch: MilitaryServiceBranch, civilianTitles: [String], bulletPoints: [String], skills: [String]) {
        self.id = UUID()
        self.code = code
        self.title = title
        self.branch = branch
        self.civilianTitles = civilianTitles
        self.bulletPoints = bulletPoints
        self.skills = skills
    }
}

nonisolated enum MilitaryCareerData {
    static let all: [MilitaryCareer] = army

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
        )
    ]
}
