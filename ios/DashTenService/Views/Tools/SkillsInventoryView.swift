import SwiftUI

struct SkillsInventoryView: View {
    @State private var selectedSkills: Set<String> = []
    @State private var showResults: Bool = false

    private let skillCategories: [SkillCategory] = [
        SkillCategory(name: "Leadership & Management", skills: [
            "Team leadership (small teams 4-10)",
            "Large unit leadership (50+)",
            "Training program development",
            "Performance evaluation",
            "Mentoring and coaching",
            "Crisis management",
            "Strategic planning",
        ]),
        SkillCategory(name: "Operations & Logistics", skills: [
            "Supply chain management",
            "Inventory management",
            "Project management",
            "Route planning and logistics",
            "Quality assurance",
            "Process improvement",
            "Budget management",
        ]),
        SkillCategory(name: "Technical", skills: [
            "IT systems administration",
            "Cybersecurity",
            "Network management",
            "Equipment maintenance",
            "Data analysis",
            "Communications systems",
            "Vehicle/fleet maintenance",
        ]),
        SkillCategory(name: "Medical & Health", skills: [
            "Emergency medical care",
            "Patient care",
            "Medical records management",
            "Pharmacy operations",
            "Health and safety compliance",
        ]),
        SkillCategory(name: "Communication & Intelligence", skills: [
            "Briefing senior leadership",
            "Report writing",
            "Intelligence analysis",
            "Cross-functional coordination",
            "Foreign language proficiency",
            "Public affairs / media relations",
        ]),
        SkillCategory(name: "Security & Compliance", skills: [
            "Physical security management",
            "Security clearance holder",
            "Regulatory compliance",
            "Risk assessment",
            "Emergency response planning",
            "Personnel vetting",
        ]),
    ]

    private var matchedCareers: [CareerMatch] {
        guard showResults else { return [] }
        var matches: [CareerMatch] = []

        let leadershipCount = selectedSkills.filter { skill in
            skillCategories.first(where: { $0.name == "Leadership & Management" })?.skills.contains(skill) ?? false
        }.count

        let techCount = selectedSkills.filter { skill in
            skillCategories.first(where: { $0.name == "Technical" })?.skills.contains(skill) ?? false
        }.count

        let opsCount = selectedSkills.filter { skill in
            skillCategories.first(where: { $0.name == "Operations & Logistics" })?.skills.contains(skill) ?? false
        }.count

        let medCount = selectedSkills.filter { skill in
            skillCategories.first(where: { $0.name == "Medical & Health" })?.skills.contains(skill) ?? false
        }.count

        let securityCount = selectedSkills.filter { skill in
            skillCategories.first(where: { $0.name == "Security & Compliance" })?.skills.contains(skill) ?? false
        }.count

        let commCount = selectedSkills.filter { skill in
            skillCategories.first(where: { $0.name == "Communication & Intelligence" })?.skills.contains(skill) ?? false
        }.count

        if leadershipCount >= 2 { matches.append(CareerMatch(field: "Management & Operations", roles: ["Operations Manager", "Program Manager", "Team Lead", "Training Director"], strength: leadershipCount)) }
        if techCount >= 2 { matches.append(CareerMatch(field: "Information Technology", roles: ["IT Manager", "Systems Administrator", "Cybersecurity Analyst", "Network Engineer"], strength: techCount)) }
        if opsCount >= 2 { matches.append(CareerMatch(field: "Supply Chain & Logistics", roles: ["Logistics Coordinator", "Supply Chain Analyst", "Warehouse Manager", "Procurement Specialist"], strength: opsCount)) }
        if medCount >= 2 { matches.append(CareerMatch(field: "Healthcare", roles: ["EMT / Paramedic", "Medical Assistant", "Health Services Manager", "Clinical Coordinator"], strength: medCount)) }
        if securityCount >= 2 { matches.append(CareerMatch(field: "Security & Risk", roles: ["Security Manager", "Compliance Officer", "Risk Analyst", "Emergency Management Director"], strength: securityCount)) }
        if commCount >= 2 { matches.append(CareerMatch(field: "Analysis & Communication", roles: ["Business Analyst", "Intelligence Analyst", "Technical Writer", "Public Relations Specialist"], strength: commCount)) }
        if leadershipCount >= 1 && opsCount >= 1 { matches.append(CareerMatch(field: "Government & Federal", roles: ["Federal Program Analyst", "Contract Specialist", "Government Project Manager", "Policy Analyst"], strength: leadershipCount + opsCount)) }

        return matches.sorted { $0.strength > $1.strength }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 8) {
                        Image(systemName: "list.clipboard.fill")
                            .foregroundStyle(.orange)
                        Text("Map Your Skills")
                            .font(.subheadline.weight(.bold))
                    }
                    Text("Select the skills you've developed during your service. We'll map them to civilian career fields where those skills are valued most.")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.primary.opacity(0.8))
                }
                .padding(14)
                .background(.orange.opacity(0.06))
                .clipShape(.rect(cornerRadius: 12))

                ForEach(skillCategories, id: \.name) { category in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(category.name)
                            .font(.subheadline.weight(.bold))

                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: 8)], spacing: 8) {
                            ForEach(category.skills, id: \.self) { skill in
                                Button {
                                    withAnimation(.spring(response: 0.2)) {
                                        if selectedSkills.contains(skill) {
                                            selectedSkills.remove(skill)
                                        } else {
                                            selectedSkills.insert(skill)
                                        }
                                    }
                                } label: {
                                    Text(skill)
                                        .font(.caption2.weight(.bold))
                                        .foregroundStyle(selectedSkills.contains(skill) ? .white : .primary)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 8)
                                        .frame(maxWidth: .infinity)
                                        .background(selectedSkills.contains(skill) ? AppTheme.forestGreen : Color(.secondarySystemGroupedBackground))
                                        .clipShape(.rect(cornerRadius: 8))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }

                Button {
                    withAnimation(.spring(response: 0.4)) { showResults = true }
                } label: {
                    Text("Find Matching Careers (\(selectedSkills.count) skills selected)")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(selectedSkills.count >= 2 ? AppTheme.forestGreen : .gray)
                        .clipShape(.rect(cornerRadius: 14))
                }
                .disabled(selectedSkills.count < 2)

                if showResults && !matchedCareers.isEmpty {
                    resultsSection
                }

                if showResults && matchedCareers.isEmpty && selectedSkills.count >= 2 {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Select more skills within the same category for stronger matches.")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.primary.opacity(0.7))
                    }
                    .padding(14)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(.rect(cornerRadius: 12))
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Skills Inventory")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var resultsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .foregroundStyle(AppTheme.gold)
                Text("Career Field Matches")
                    .font(.headline.weight(.bold))
            }

            ForEach(matchedCareers, id: \.field) { match in
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(match.field)
                            .font(.subheadline.weight(.bold))
                        Spacer()
                        Text("\(match.strength) skill matches")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(AppTheme.forestGreen)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(AppTheme.forestGreen.opacity(0.1))
                            .clipShape(Capsule())
                    }

                    ForEach(match.roles, id: \.self) { role in
                        HStack(spacing: 6) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.caption2)
                                .foregroundStyle(AppTheme.forestGreen)
                            Text(role)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.primary.opacity(0.8))
                        }
                    }
                }
                .padding(14)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(.rect(cornerRadius: 12))
            }
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}

private nonisolated struct SkillCategory: Sendable {
    let name: String
    let skills: [String]
}

private nonisolated struct CareerMatch: Sendable {
    let field: String
    let roles: [String]
    let strength: Int
}
