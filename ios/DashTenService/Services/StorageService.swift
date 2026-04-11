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

    init() {
        let stored = StorageService.loadFromDisk()
        self.profile = stored.profile
        self.checklistItems = stored.checklist
        self.documents = stored.documents
        self.benefitCategories = stored.benefits
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

    func resetOnboarding() {
        profile = UserProfile()
        checklistItems = TransitionDataService.defaultChecklist()
        documents = TransitionDataService.defaultDocuments()
        benefitCategories = TransitionDataService.defaultBenefits()
    }

    private func save() {
        let container = StorageContainer(profile: profile, checklist: checklistItems, documents: documents, benefits: benefitCategories)
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
                benefits: TransitionDataService.defaultBenefits()
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
}
