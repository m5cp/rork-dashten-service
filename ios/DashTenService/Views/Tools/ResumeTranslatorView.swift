import SwiftUI

struct ResumeTranslatorView: View {
    @State private var selectedTab: ResumeTab = .translate
    @State private var selectedMOS: String = ""
    @State private var showResults: Bool = false
    @State private var jargonSearch: String = ""
    @State private var jargonDirection: TranslationDirection = .milToCiv

    private let mosData: [MOSEntry] = [
        MOSEntry(code: "11B", title: "Infantryman", civilian: ["Security Manager", "Operations Supervisor", "Law Enforcement Officer", "Emergency Management Coordinator"], bullets: ["Led teams of 4-40 personnel in high-pressure environments", "Managed equipment valued at $2M+ with zero loss", "Trained and mentored junior team members on standard operating procedures", "Coordinated logistics for multi-day field operations"]),
        MOSEntry(code: "25B", title: "IT Specialist", civilian: ["IT Support Specialist", "Systems Administrator", "Network Technician", "Help Desk Analyst"], bullets: ["Maintained network infrastructure for 500+ users", "Troubleshot hardware/software issues reducing downtime by 30%", "Managed Active Directory accounts and security protocols", "Deployed and configured enterprise communication systems"]),
        MOSEntry(code: "68W", title: "Combat Medic", civilian: ["EMT / Paramedic", "Medical Assistant", "Patient Care Technician", "Health Services Coordinator"], bullets: ["Provided emergency medical care in austere environments", "Managed patient records and medication administration for 200+ personnel", "Trained 30+ personnel in first aid and emergency response", "Coordinated medical evacuations and triage operations"]),
        MOSEntry(code: "35F", title: "Intelligence Analyst", civilian: ["Business Intelligence Analyst", "Data Analyst", "Research Analyst", "Risk Assessment Specialist"], bullets: ["Analyzed complex datasets to produce actionable reports for senior leadership", "Briefed executives on findings affecting strategic planning", "Created visualizations and dashboards for data-driven decision making", "Maintained security clearance and handled sensitive information"]),
        MOSEntry(code: "42A", title: "Human Resources Specialist", civilian: ["HR Generalist", "Personnel Coordinator", "Payroll Administrator", "Benefits Specialist"], bullets: ["Managed personnel records for 500+ employees with 100% accuracy", "Processed payroll, benefits enrollment, and separations", "Counseled employees on career development and opportunities", "Maintained compliance with federal regulations and policies"]),
        MOSEntry(code: "91B", title: "Wheeled Vehicle Mechanic", civilian: ["Fleet Mechanic", "Automotive Technician", "Maintenance Supervisor", "Equipment Repair Specialist"], bullets: ["Diagnosed and repaired diesel and gasoline engines for 50+ vehicles", "Managed preventive maintenance schedules reducing breakdown rate by 40%", "Ordered and tracked $500K+ in parts inventory", "Supervised team of 5 mechanics across multiple maintenance bays"]),
        MOSEntry(code: "HM", title: "Hospital Corpsman (Navy)", civilian: ["Medical Assistant", "Phlebotomist", "Clinical Lab Technician", "Nursing Assistant"], bullets: ["Provided primary care and emergency treatment for 300+ patients", "Managed pharmacy operations including medication dispensing", "Maintained medical records in compliance with HIPAA", "Assisted physicians in minor surgical procedures"]),
        MOSEntry(code: "0311", title: "Rifleman (Marines)", civilian: ["Security Specialist", "Operations Coordinator", "Training Instructor", "Team Leader"], bullets: ["Led fire teams of 4-13 in complex operational environments", "Planned and executed training programs for 100+ personnel", "Managed mission-critical equipment accountability", "Demonstrated leadership under extreme pressure with zero incidents"]),
        MOSEntry(code: "3D0X2", title: "Cyber Systems Operations (AF)", civilian: ["Cybersecurity Analyst", "Systems Engineer", "Cloud Administrator", "IT Security Specialist"], bullets: ["Administered enterprise server infrastructure across multiple sites", "Implemented security protocols protecting networks serving 10,000+ users", "Managed backup, recovery, and disaster continuity operations", "Obtained and maintained security clearance for classified systems"]),
        MOSEntry(code: "LS", title: "Logistics Specialist (Navy)", civilian: ["Supply Chain Analyst", "Inventory Manager", "Procurement Specialist", "Warehouse Operations Manager"], bullets: ["Managed inventory of 5,000+ line items valued at $10M+", "Processed procurement requests and vendor coordination", "Optimized supply chain processes reducing waste by 25%", "Conducted audits ensuring 98%+ inventory accuracy"]),
    ]

    var body: some View {
        VStack(spacing: 0) {
            Picker("Mode", selection: $selectedTab) {
                Text("Translate Resume").tag(ResumeTab.translate)
                Text("Jargon Lookup").tag(ResumeTab.jargon)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 4)

            switch selectedTab {
            case .translate:
                translateTab
            case .jargon:
                jargonTab
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Resume Translator")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Translate Tab

    private var translateTab: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 8) {
                        Image(systemName: "doc.text.fill")
                            .foregroundStyle(.teal)
                        Text("Translate Your Experience")
                            .font(.subheadline.weight(.bold))
                    }
                    Text("Select your military job code to get civilian-friendly job titles and resume bullet points.")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.primary.opacity(0.8))
                }
                .padding(14)
                .background(.teal.opacity(0.06))
                .clipShape(.rect(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 12) {
                    Text("Select Your Role")
                        .font(.headline.weight(.bold))

                    ForEach(mosData, id: \.code) { entry in
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                selectedMOS = entry.code
                                showResults = true
                            }
                        } label: {
                            HStack(spacing: 12) {
                                Text(entry.code)
                                    .font(.caption.weight(.bold))
                                    .foregroundStyle(.white)
                                    .frame(width: 50, height: 32)
                                    .background(selectedMOS == entry.code ? AppTheme.forestGreen : .primary.opacity(0.3))
                                    .clipShape(.rect(cornerRadius: 6))

                                Text(entry.title)
                                    .font(.subheadline.weight(.bold))
                                    .foregroundStyle(.primary)

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.caption.weight(.bold))
                                    .foregroundStyle(.primary.opacity(0.4))
                            }
                            .padding(12)
                            .background(selectedMOS == entry.code ? AppTheme.forestGreen.opacity(0.06) : Color(.secondarySystemGroupedBackground))
                            .clipShape(.rect(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)
                    }
                }

                if showResults, let entry = mosData.first(where: { $0.code == selectedMOS }) {
                    translationResults(entry)
                }

                Text("These are starting points. Tailor every bullet to the specific job you're applying for.")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary.opacity(0.5))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
    }

    private func translationResults(_ entry: MOSEntry) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "arrow.triangle.swap")
                    .foregroundStyle(AppTheme.gold)
                Text("Civilian Translations")
                    .font(.headline.weight(.bold))
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("Suggested Civilian Job Titles")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(AppTheme.forestGreen)

                ForEach(entry.civilian, id: \.self) { title in
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundStyle(AppTheme.forestGreen)
                        Text(title)
                            .font(.subheadline.weight(.semibold))
                    }
                }
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 10) {
                Text("Resume Bullet Points")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.blue)

                ForEach(entry.bullets, id: \.self) { bullet in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.caption)
                            .foregroundStyle(.blue)
                            .padding(.top, 2)
                        Text(bullet)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.primary.opacity(0.8))
                    }
                }
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 12))
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }

    // MARK: - Jargon Tab

    private var filteredJargon: [JargonEntry] {
        let entries = jargonDirection == .milToCiv ? CivilianJargonTranslatorView.milToCivEntries : CivilianJargonTranslatorView.civToMilEntries
        guard !jargonSearch.isEmpty else { return entries }
        return entries.filter {
            $0.term.localizedStandardContains(jargonSearch) ||
            $0.translation.localizedStandardContains(jargonSearch) ||
            $0.context.localizedStandardContains(jargonSearch)
        }
    }

    private var jargonTab: some View {
        VStack(spacing: 0) {
            Picker("Direction", selection: $jargonDirection) {
                Text("Military → Civilian").tag(TranslationDirection.milToCiv)
                Text("Civilian → Military").tag(TranslationDirection.civToMil)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 16)
            .padding(.top, 8)

            List {
                if filteredJargon.isEmpty {
                    ContentUnavailableView("No matches", systemImage: "magnifyingglass", description: Text("Try a different search term"))
                } else {
                    ForEach(filteredJargon) { entry in
                        JargonRow(entry: entry, direction: jargonDirection)
                    }
                }
            }
            .listStyle(.insetGrouped)
        }
    }
}

private nonisolated enum ResumeTab: String, Sendable {
    case translate
    case jargon
}

private nonisolated struct MOSEntry: Sendable {
    let code: String
    let title: String
    let civilian: [String]
    let bullets: [String]
}
