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
    static let all: [MilitaryCareer] = army + navy + marines

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
        )
    ]
}
