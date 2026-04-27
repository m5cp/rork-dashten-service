import SwiftUI

struct CivilianJargonTranslatorView: View {
    @State private var searchText: String = ""
    @State private var selectedDirection: TranslationDirection = .milToCiv

    private var filteredEntries: [JargonEntry] {
        let entries = selectedDirection == .milToCiv ? Self.milToCivEntries : Self.civToMilEntries
        guard !searchText.isEmpty else { return entries }
        return entries.filter {
            $0.term.localizedStandardContains(searchText) ||
            $0.translation.localizedStandardContains(searchText) ||
            $0.context.localizedStandardContains(searchText)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            Picker("Direction", selection: $selectedDirection) {
                Text("Military → Civilian").tag(TranslationDirection.milToCiv)
                Text("Civilian → Military").tag(TranslationDirection.civToMil)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 16)
            .padding(.top, 8)

            List {
                if filteredEntries.isEmpty {
                    ContentUnavailableView("No matches", systemImage: "magnifyingglass", description: Text("Try a different search term"))
                } else {
                    ForEach(filteredEntries) { entry in
                        JargonRow(entry: entry, direction: selectedDirection)
                    }
                }
            }
            .listStyle(.insetGrouped)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Jargon Translator")
        .navigationBarTitleDisplayMode(.inline)
    }

    static let milToCivEntries: [JargonEntry] = [
        JargonEntry(term: "AOR", translation: "Area of Responsibility", context: "Use 'scope of work' or 'territory' in civilian roles"),
        JargonEntry(term: "BLUF", translation: "Bottom Line Up Front", context: "Say 'executive summary' or 'key takeaway' in business settings"),
        JargonEntry(term: "COA", translation: "Course of Action", context: "Use 'strategy,' 'plan,' or 'approach'"),
        JargonEntry(term: "Commander's Intent", translation: "Strategic Vision", context: "Say 'leadership vision' or 'project goals'"),
        JargonEntry(term: "CONOP", translation: "Concept of Operations", context: "Use 'project plan' or 'operational blueprint'"),
        JargonEntry(term: "Deployment", translation: "Extended Assignment", context: "Say 'overseas assignment' or 'field rotation'"),
        JargonEntry(term: "DFAC", translation: "Dining Facility", context: "Say 'cafeteria' or 'break room'"),
        JargonEntry(term: "ETS", translation: "End of Service", context: "Say 'contract end date' or 'separation date'"),
        JargonEntry(term: "FOB", translation: "Forward Operating Base", context: "Say 'field office' or 'satellite location'"),
        JargonEntry(term: "FRAGO", translation: "Change Order", context: "Use 'amended plan' or 'updated directive'"),
        JargonEntry(term: "Good to go", translation: "Approved / Ready", context: "Say 'confirmed,' 'approved,' or 'ready to proceed'"),
        JargonEntry(term: "Head count", translation: "Staff Count", context: "Say 'headcount,' 'team size,' or 'personnel count'"),
        JargonEntry(term: "Intel", translation: "Intelligence / Data", context: "Use 'market research,' 'data,' or 'competitive analysis'"),
        JargonEntry(term: "IPR", translation: "In-Progress Review", context: "Say 'status update,' 'check-in,' or 'progress meeting'"),
        JargonEntry(term: "KIA/WIA", translation: "Casualties", context: "Avoid in civilian contexts — use 'incident' or 'loss'"),
        JargonEntry(term: "LES", translation: "Pay Stub", context: "Say 'pay statement' or 'earnings summary'"),
        JargonEntry(term: "MOS/AFSC/Rating", translation: "Job Title / Specialty", context: "Translate to civilian job title equivalent"),
        JargonEntry(term: "NCO", translation: "Mid-Level Manager", context: "Say 'team lead,' 'supervisor,' or 'manager'"),
        JargonEntry(term: "NCOIC", translation: "Shift Supervisor", context: "Use 'team lead' or 'floor manager'"),
        JargonEntry(term: "OIC", translation: "Project Lead", context: "Say 'director,' 'department head,' or 'team lead'"),
        JargonEntry(term: "OPORD", translation: "Operations Order", context: "Use 'project brief' or 'action plan'"),
        JargonEntry(term: "PCS", translation: "Relocation", context: "Say 'corporate relocation' or 'transfer'"),
        JargonEntry(term: "PT", translation: "Physical Training", context: "Say 'fitness,' 'exercise,' or 'wellness program'"),
        JargonEntry(term: "Rack", translation: "Bed / Bunk", context: "Not commonly used — just say 'bed'"),
        JargonEntry(term: "Roger", translation: "Understood", context: "Say 'got it,' 'understood,' or 'confirmed'"),
        JargonEntry(term: "S1/G1/J1", translation: "HR Department", context: "Say 'Human Resources' or 'People Operations'"),
        JargonEntry(term: "S3/G3/J3", translation: "Operations", context: "Say 'Operations Department' or 'Ops'"),
        JargonEntry(term: "S4/G4/J4", translation: "Logistics / Supply Chain", context: "Say 'Supply Chain' or 'Procurement'"),
        JargonEntry(term: "SITREP", translation: "Status Report", context: "Use 'status update,' 'progress report,' or 'briefing'"),
        JargonEntry(term: "SOP", translation: "Standard Procedure", context: "Say 'company policy,' 'playbook,' or 'guidelines'"),
        JargonEntry(term: "TAD/TDY", translation: "Business Trip", context: "Say 'travel assignment' or 'business travel'"),
        JargonEntry(term: "Tracking", translation: "Following / Monitoring", context: "Say 'noted,' 'following up,' or 'monitoring'"),
        JargonEntry(term: "XO", translation: "Deputy / COO", context: "Say 'second-in-command,' 'deputy director,' or 'VP'"),
    ]

    static let civToMilEntries: [JargonEntry] = [
        JargonEntry(term: "Stakeholder", translation: "Commander / Higher", context: "Person with authority over your project"),
        JargonEntry(term: "Deliverable", translation: "End Product / Output", context: "The final result expected from a task"),
        JargonEntry(term: "KPI", translation: "Key Performance Indicator", context: "Metrics used to measure success — like readiness scores"),
        JargonEntry(term: "ROI", translation: "Return on Investment", context: "Was the cost worth the result? Think resource allocation"),
        JargonEntry(term: "Synergy", translation: "Teamwork / Coordination", context: "Working together for a combined effect"),
        JargonEntry(term: "Bandwidth", translation: "Capacity / Availability", context: "'I don't have bandwidth' = 'I'm at max capacity'"),
        JargonEntry(term: "Circle back", translation: "Follow up", context: "Revisit a topic later"),
        JargonEntry(term: "Deep dive", translation: "Detailed analysis", context: "A thorough examination of a topic"),
        JargonEntry(term: "Onboarding", translation: "In-processing", context: "New employee orientation and setup"),
        JargonEntry(term: "Offboarding", translation: "Out-processing", context: "Employee departure procedures"),
        JargonEntry(term: "PTO", translation: "Paid Time Off", context: "Leave / Liberty equivalent — you earn and use it"),
        JargonEntry(term: "OKR", translation: "Objectives & Key Results", context: "Goal-setting framework — like mission objectives"),
        JargonEntry(term: "Agile", translation: "Iterative Planning", context: "Work in short sprints, adjust as you go"),
        JargonEntry(term: "Sprint", translation: "Short Work Cycle", context: "1-2 week focused work period in Agile"),
        JargonEntry(term: "Standup", translation: "Daily Briefing", context: "Quick daily team meeting — usually 15 min"),
        JargonEntry(term: "Pipeline", translation: "Workflow / Queue", context: "Sequence of tasks or prospects in progress"),
        JargonEntry(term: "Leverage", translation: "Utilize / Employ", context: "'Leverage your skills' = 'Use your strengths'"),
        JargonEntry(term: "Pivot", translation: "Change Direction", context: "Shift strategy based on new information"),
        JargonEntry(term: "Scale", translation: "Grow / Expand", context: "Increase operations or capacity"),
        JargonEntry(term: "Buy-in", translation: "Support / Approval", context: "Getting agreement from leadership or team"),
        JargonEntry(term: "Action item", translation: "Task / To-Do", context: "Specific task assigned during a meeting"),
        JargonEntry(term: "Ecosystem", translation: "Network / Environment", context: "The broader system your work operates in"),
        JargonEntry(term: "Touch base", translation: "Quick Check-In", context: "Brief follow-up conversation"),
        JargonEntry(term: "Value-add", translation: "Extra Benefit", context: "Something additional you bring to the table"),
    ]
}

nonisolated enum TranslationDirection: String, Sendable {
    case milToCiv = "milToCiv"
    case civToMil = "civToMil"
}

nonisolated struct JargonEntry: Identifiable, Sendable {
    let id = UUID()
    let term: String
    let translation: String
    let context: String
}

struct JargonRow: View {
    let entry: JargonEntry
    let direction: TranslationDirection

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                Text(entry.term)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(AppTheme.forestGreen)
                Image(systemName: "arrow.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.tertiary)
                Text(entry.translation)
                    .font(.subheadline.weight(.bold))
            }
            Text(entry.context)
                .font(.caption.weight(.medium))
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}
