import Foundation

@Observable
@MainActor
class StorageService {
    private let userDefaultsKey = "dashten_data"

    var profile: UserProfile {
        didSet { save() }
    }
    var checklistItems: [ChecklistItem] {
        didSet { save() }
    }
    var documents: [DocumentItem] {
        didSet { save() }
    }
    var benefitCategories: [BenefitCategory] {
        didSet { save() }
    }
    var mentors: [MentorContact] {
        didSet { save() }
    }
    var lastAssessment: AssessmentResult? {
        didSet { save() }
    }

    init() {
        let stored = StorageService.loadFromDisk()
        self.profile = stored.profile
        self.checklistItems = stored.checklist
        self.documents = stored.documents
        self.benefitCategories = stored.benefits
        self.mentors = stored.mentors
        self.lastAssessment = stored.lastAssessment
    }

    func toggleChecklistItem(_ id: String) {
        guard let index = checklistItems.firstIndex(where: { $0.id == id }) else { return }
        checklistItems[index].isCompleted.toggle()
    }

    func updateDocumentStatus(_ id: String, status: DocumentStatus) {
        guard let index = documents.firstIndex(where: { $0.id == id }) else { return }
        documents[index].status = status
        documents[index].dateUpdated = Date()
    }

    func toggleBenefitAction(categoryId: String, actionId: String) {
        guard let catIndex = benefitCategories.firstIndex(where: { $0.id == categoryId }),
              let actIndex = benefitCategories[catIndex].actionItems.firstIndex(where: { $0.id == actionId }) else { return }
        benefitCategories[catIndex].actionItems[actIndex].isCompleted.toggle()
    }

    func toggleBenefitSaved(_ categoryId: String) {
        guard let index = benefitCategories.firstIndex(where: { $0.id == categoryId }) else { return }
        benefitCategories[index].isSaved.toggle()
    }

    func markBenefitStarted(_ categoryId: String) {
        guard let index = benefitCategories.firstIndex(where: { $0.id == categoryId }) else { return }
        benefitCategories[index].isStarted = true
    }

    func addCustomChecklistItem(title: String, phase: TimelinePhase, category: ReadinessCategory) {
        let item = ChecklistItem(title: title, subtitle: "", phase: phase, readinessCategory: category, isCustom: true)
        checklistItems.append(item)
    }

    func removeChecklistItem(_ id: String) {
        checklistItems.removeAll { $0.id == id && $0.isCustom }
    }

    func addMentor(_ mentor: MentorContact) {
        mentors.append(mentor)
    }

    func removeMentor(_ id: String) {
        mentors.removeAll { $0.id == id }
    }

    func updateMentorLastContact(_ id: String) {
        guard let index = mentors.firstIndex(where: { $0.id == id }) else { return }
        mentors[index].lastContactDate = Date()
    }

    func saveAssessment(_ result: AssessmentResult) {
        lastAssessment = result
    }

    func resetOnboarding() {
        profile = UserProfile()
        checklistItems = TransitionDataService.defaultChecklist()
        documents = TransitionDataService.defaultDocuments()
        benefitCategories = TransitionDataService.defaultBenefits()
        mentors = []
        lastAssessment = nil
    }

    private func save() {
        let container = StorageContainer(profile: profile, checklist: checklistItems, documents: documents, benefits: benefitCategories, mentors: mentors, lastAssessment: lastAssessment)
        guard let data = try? JSONEncoder().encode(container) else { return }
        UserDefaults.standard.set(data, forKey: userDefaultsKey)
    }

    private static func loadFromDisk() -> StorageContainer {
        guard let data = UserDefaults.standard.data(forKey: "dashten_data"),
              let container = try? JSONDecoder().decode(StorageContainer.self, from: data) else {
            return StorageContainer(
                profile: UserProfile(),
                checklist: TransitionDataService.defaultChecklist(),
                documents: TransitionDataService.defaultDocuments(),
                benefits: TransitionDataService.defaultBenefits(),
                mentors: [],
                lastAssessment: nil
            )
        }
        return container
    }
}

private nonisolated struct StorageContainer: Codable, Sendable {
    let profile: UserProfile
    let checklist: [ChecklistItem]
    let documents: [DocumentItem]
    let benefits: [BenefitCategory]
    let mentors: [MentorContact]
    let lastAssessment: AssessmentResult?

    init(profile: UserProfile, checklist: [ChecklistItem], documents: [DocumentItem], benefits: [BenefitCategory], mentors: [MentorContact] = [], lastAssessment: AssessmentResult? = nil) {
        self.profile = profile
        self.checklist = checklist
        self.documents = documents
        self.benefits = benefits
        self.mentors = mentors
        self.lastAssessment = lastAssessment
    }
}
