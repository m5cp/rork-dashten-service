import SwiftUI

struct RoadmapView: View {
	let storage: StorageService
	@State private var showAddItem: Bool = false
	@State private var newItemTitle: String = ""
	@State private var newItemPhase: TimelinePhase = .eighteenToTwentyFour
	@State private var newItemCategory: ReadinessCategory = .admin
	@State private var showCatchUpSheet: Bool = false
	@State private var celebratingPhase: TimelinePhase? = nil

	private func itemsForPhase(_ phase: TimelinePhase) -> [ChecklistItem] {
		storage.checklistItems.filter { $0.phase == phase }
	}

	private func completionForPhase(_ phase: TimelinePhase) -> Double {
		let items = itemsForPhase(phase)
		guard !items.isEmpty else { return 0 }
		return Double(items.filter(\.isCompleted).count) / Double(items.count)
	}

	private var isPostService: Bool {
		storage.profile.timeline == .separated
	}

	private var currentPhase: TimelinePhase? {
		if isPostService {
			guard let sepDate = storage.profile.separationDate else { return .firstThirty }
			let monthsSince = Calendar.current.dateComponents([.month], from: sepDate, to: Date()).month ?? 0
			if monthsSince < 1 { return .firstThirty }
			if monthsSince < 3 { return .firstNinety }
			if monthsSince < 12 { return .firstYear }
			return .yearTwoPlus
		}
		guard let sepDate = storage.profile.separationDate else { return nil }
		let months = Calendar.current.dateComponents([.month], from: Date(), to: sepDate).month ?? 0
		if months > 18 { return .eighteenToTwentyFour }
		if months > 12 { return .twelveMonths }
		if months > 6 { return .sixMonths }
		if months > 3 { return .ninetyDays }
		if months > 0 { return .thirtyDays }
		let monthsSince = Calendar.current.dateComponents([.month], from: sepDate, to: Date()).month ?? 0
		if monthsSince < 1 { return .firstThirty }
		if monthsSince < 3 { return .firstNinety }
		if monthsSince < 12 { return .firstYear }
		return .yearTwoPlus
	}

	private var visiblePhases: [TimelinePhase] {
		isPostService ? TimelinePhase.postServicePhases : TimelinePhase.preSeparationPhases
	}

	private func isPhaseCompleted(_ phase: TimelinePhase) -> Bool {
		guard let current = currentPhase else { return false }
		let allPhases = visiblePhases
		guard let currentIdx = allPhases.firstIndex(of: current),
			  let phaseIdx = allPhases.firstIndex(of: phase) else { return false }
		return phaseIdx < currentIdx
	}

	// Phases that are behind the user's current phase with incomplete tasks
	private var pastPhasesWithIncompleteTasks: [TimelinePhase] {
		visiblePhases.filter { phase in
			isPhaseCompleted(phase) && completionForPhase(phase) < 1.0
		}
	}

	var body: some View {
		NavigationStack {
			Group {
				if isPostService {
					PostServiceRoadmapView(storage: storage)
				} else {
					preSeparationBody
				}
			}
		}
	}

	private var preSeparationBody: some View {
		ScrollView {
			VStack(spacing: 20) {

				// Catch-up banner for late joiners
				if !pastPhasesWithIncompleteTasks.isEmpty {
					catchUpBanner
				}

				// Phase cards
				ForEach(Array(visiblePhases.enumerated()), id: \.element.id) { index, phase in
					let isCurrent = phase == currentPhase
					let isPast = isPhaseCompleted(phase)
					let completion = completionForPhase(phase)

					NavigationLink(value: phase) {
						PhaseCard(
							phase: phase,
							completion: completion,
							isCurrent: isCurrent,
							isPast: isPast,
							completedCount: itemsForPhase(phase).filter(\.isCompleted).count,
							totalCount: itemsForPhase(phase).count,
							isCelebrating: celebratingPhase == phase
						)
					}
					.buttonStyle(.plain)
					.onChange(of: completion) { _, newVal in
						if newVal >= 1.0 {
							withAnimation(.spring(response: 0.5)) {
								celebratingPhase = phase
							}
							DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
								withAnimation { celebratingPhase = nil }
							}
						}
					}
				}

				Text("General information only · Not affiliated with any government agency")
					.font(.caption2)
					.foregroundStyle(.secondary)
					.multilineTextAlignment(.center)
					.frame(maxWidth: .infinity)
					.padding(.top, 8)
			}
			.readableContentWidth()
			.padding(.horizontal, 16)
			.padding(.bottom, 60)
		}
		.background(Color(.systemGroupedBackground))
		.navigationTitle("Roadmap")
		.navigationBarTitleDisplayMode(.large)
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				Button {
					showAddItem = true
				} label: {
					Image(systemName: "plus.circle.fill")
						.foregroundStyle(AppTheme.forestGreen)
				}
				.accessibilityLabel("Add roadmap item")
			}
		}
		.sheet(isPresented: $showAddItem) { addItemSheet }
		.sheet(isPresented: $showCatchUpSheet) { catchUpSheet }
		.navigationDestination(for: TimelinePhase.self) { phase in
			PhaseDetailView(storage: storage, phase: phase)
		}
	}

	// MARK: - Catch-Up Banner

	private var catchUpBanner: some View {
		Button { showCatchUpSheet = true } label: {
			HStack(spacing: 12) {
				Image(systemName: "bolt.circle.fill")
					.font(.title3.weight(.bold))
					.foregroundStyle(.white)
					.frame(width: 40, height: 40)
					.background(AppTheme.gold)
					.clipShape(Circle())
				VStack(alignment: .leading, spacing: 3) {
					Text("You have tasks from earlier phases")
						.font(.subheadline.weight(.bold))
						.foregroundStyle(.primary)
					Text("Tap to mark completed phases as done")
						.font(.caption.weight(.semibold))
						.foregroundStyle(.secondary)
				}
				Spacer()
				Image(systemName: "chevron.right")
					.font(.caption.weight(.bold))
					.foregroundStyle(.secondary)
			}
			.padding(14)
			.background(AppTheme.gold.opacity(0.08))
			.overlay(RoundedRectangle(cornerRadius: 14).stroke(AppTheme.gold.opacity(0.3), lineWidth: 1))
			.clipShape(.rect(cornerRadius: 14))
			.contentShape(Rectangle())
		}
		.buttonStyle(.plain)
	}

	// MARK: - Catch-Up Sheet

	private var catchUpSheet: some View {
		NavigationStack {
			ScrollView {
				VStack(alignment: .leading, spacing: 16) {
					Text("These phases are behind your current timeline. If you have already completed these tasks, mark them done to keep your Readiness Score accurate.")
						.font(.subheadline)
						.foregroundStyle(.secondary)
						.padding(.horizontal, 16)
						.fixedSize(horizontal: false, vertical: true)

					ForEach(pastPhasesWithIncompleteTasks) { phase in
						let items = itemsForPhase(phase).filter { !$0.isCompleted }
						VStack(alignment: .leading, spacing: 10) {
							HStack(spacing: 10) {
								Image(systemName: phase.icon)
									.font(.body.weight(.semibold))
									.foregroundStyle(AppTheme.forestGreen)
									.frame(width: 32, height: 32)
									.background(AppTheme.forestGreen.opacity(0.12))
									.clipShape(.rect(cornerRadius: 8))
								VStack(alignment: .leading, spacing: 2) {
									Text(phase.displayName)
										.font(.subheadline.weight(.bold))
									Text("\(items.count) incomplete tasks")
										.font(.caption.weight(.semibold))
										.foregroundStyle(.secondary)
								}
								Spacer()
								Button {
									withAnimation(.spring(response: 0.4)) {
										items.forEach { storage.toggleChecklistItem($0.id) }
									}
								} label: {
									Text("Mark All Done")
										.font(.caption.weight(.bold))
										.foregroundStyle(.white)
										.padding(.horizontal, 12)
										.padding(.vertical, 8)
										.background(AppTheme.forestGreen)
										.clipShape(Capsule())
								}
								.buttonStyle(.plain)
								.sensoryFeedback(.success, trigger: completionForPhase(phase))
							}
						}
						.padding(14)
						.background(Color(.secondarySystemGroupedBackground))
						.clipShape(.rect(cornerRadius: 14))
						.padding(.horizontal, 16)
					}
				}
				.padding(.top, 8)
				.padding(.bottom, 40)
			}
			.background(Color(.systemGroupedBackground))
			.navigationTitle("Catch Up")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .confirmationAction) {
					Button("Done") { showCatchUpSheet = false }
				}
			}
		}
	}

	// MARK: - Add Item Sheet

	private var addItemSheet: some View {
		NavigationStack {
			Form {
				Section("New Task") {
					TextField("Task title", text: $newItemTitle)
				}
				Section("Phase") {
					Picker("Timeline Phase", selection: $newItemPhase) {
						ForEach(TimelinePhase.allCases) { phase in
							Text(phase.rawValue).tag(phase)
						}
					}
				}
				Section("Category") {
					Picker("Category", selection: $newItemCategory) {
						ForEach(ReadinessCategory.allCases) { cat in
							Label(cat.rawValue, systemImage: cat.icon).tag(cat)
						}
					}
				}
			}
			.navigationTitle("Add Custom Task")
			.navigationBarTitleDisplayMode(.inline)
			.keyboardDoneToolbar()
			.toolbar {
				ToolbarItem(placement: .cancellationAction) {
					Button("Cancel") {
						showAddItem = false
						newItemTitle = ""
					}
				}
				ToolbarItem(placement: .confirmationAction) {
					Button("Add") {
						guard !newItemTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }
						storage.addCustomChecklistItem(
							title: newItemTitle.trimmingCharacters(in: .whitespaces),
							phase: newItemPhase,
							category: newItemCategory
						)
						newItemTitle = ""
						showAddItem = false
					}
					.disabled(newItemTitle.trimmingCharacters(in: .whitespaces).isEmpty)
				}
			}
		}
		.presentationDetents([.medium])
	}
}

// MARK: - Phase Card (replaces TimelineRow)

struct PhaseCard: View {
	let phase: TimelinePhase
	let completion: Double
	let isCurrent: Bool
	let isPast: Bool
	let completedCount: Int
	let totalCount: Int
	let isCelebrating: Bool

	private var cardColor: Color {
		if isCurrent { return AppTheme.forestGreen }
		if isPast && completion >= 1.0 { return AppTheme.forestGreen.opacity(0.7) }
		if isPast { return .orange }
		return Color(.tertiarySystemGroupedBackground)
	}

	private var backgroundStyle: some ShapeStyle {
		if isCurrent {
			return AnyShapeStyle(LinearGradient(
				colors: [AppTheme.forestGreen, AppTheme.darkGreen],
				startPoint: .topLeading, endPoint: .bottomTrailing
			))
		}
		return AnyShapeStyle(Color(.secondarySystemGroupedBackground))
	}

	private var foregroundColor: Color {
		isCurrent ? .white : .primary
	}

	private var subtitleColor: Color {
		isCurrent ? .white.opacity(0.8) : .secondary
	}

	var body: some View {
		ZStack {
			// Card background
			RoundedRectangle(cornerRadius: 18)
				.fill(backgroundStyle)
				.shadow(color: isCurrent ? AppTheme.forestGreen.opacity(0.35) : .clear, radius: 12, y: 6)

			// Celebrate overlay
			if isCelebrating {
				RoundedRectangle(cornerRadius: 18)
					.fill(AppTheme.gold.opacity(0.15))
			}

			HStack(spacing: 16) {

				// Phase icon with ring
				ZStack {
					Circle()
						.stroke(isCurrent ? Color.white.opacity(0.3) : AppTheme.forestGreen.opacity(0.15), lineWidth: 3)
						.frame(width: 60, height: 60)

					// Progress ring
					Circle()
						.trim(from: 0, to: completion)
						.stroke(
							isCurrent ? Color.white : (completion >= 1.0 ? AppTheme.forestGreen : AppTheme.gold),
							style: StrokeStyle(lineWidth: 3, lineCap: .round)
						)
						.frame(width: 60, height: 60)
						.rotationEffect(.degrees(-90))
						.animation(.spring(response: 0.6), value: completion)

					if completion >= 1.0 && !isCurrent {
						Image(systemName: "checkmark")
							.font(.title3.weight(.bold))
							.foregroundStyle(AppTheme.forestGreen)
					} else {
						Image(systemName: phase.icon)
							.font(.title3.weight(.semibold))
							.foregroundStyle(isCurrent ? .white : AppTheme.forestGreen)
					}
				}

				// Text content
				VStack(alignment: .leading, spacing: 6) {
					HStack(spacing: 8) {
						Text(phase.rawValue)
							.font(.headline.weight(.bold))
							.foregroundStyle(foregroundColor)
							.lineLimit(1)

						if isCurrent {
							Text("YOU ARE HERE")
								.font(.system(size: 9, weight: .heavy))
								.foregroundStyle(AppTheme.forestGreen)
								.padding(.horizontal, 7)
								.padding(.vertical, 3)
								.background(Color.white)
								.clipShape(Capsule())
						}

						if isCelebrating {
							Text("✓ COMPLETE")
								.font(.system(size: 9, weight: .heavy))
								.foregroundStyle(.white)
								.padding(.horizontal, 7)
								.padding(.vertical, 3)
								.background(AppTheme.gold)
								.clipShape(Capsule())
						}
					}

					Text(phase.subtitle)
						.font(.caption.weight(.semibold))
						.foregroundStyle(subtitleColor)
						.lineLimit(1)

					HStack(spacing: 10) {
						// Mini task progress
						HStack(spacing: 4) {
							Image(systemName: "checkmark.circle.fill")
								.font(.caption2)
								.foregroundStyle(isCurrent ? .white.opacity(0.7) : AppTheme.forestGreen)
							Text("\(completedCount)/\(totalCount) tasks")
								.font(.caption2.weight(.bold))
								.foregroundStyle(isCurrent ? .white.opacity(0.7) : .secondary)
						}
					}
				}

				Spacer()

				Image(systemName: "chevron.right")
					.font(.caption.weight(.bold))
					.foregroundStyle(isCurrent ? AnyShapeStyle(Color.white.opacity(0.5)) : AnyShapeStyle(.tertiary))
			}
			.padding(18)
		}
		.frame(minHeight: 100)
		.scaleEffect(isCelebrating ? 1.02 : 1.0)
		.animation(.spring(response: 0.4), value: isCelebrating)
		.contentShape(Rectangle())
	}
}

// MARK: - TimelineRow (compatibility wrapper used by PostServiceRoadmapView)

struct TimelineRow: View {
	let phase: TimelinePhase
	let completion: Double
	let itemCount: Int
	let completedCount: Int
	let isCurrent: Bool
	let isPast: Bool
	let isLast: Bool

	var body: some View {
		PhaseCard(
			phase: phase,
			completion: completion,
			isCurrent: isCurrent,
			isPast: isPast,
			completedCount: completedCount,
			totalCount: itemCount,
			isCelebrating: false
		)
		.padding(.bottom, isLast ? 0 : 10)
	}
}

// MARK: - PhaseDetailView (unchanged)

struct PhaseDetailView: View {
	let storage: StorageService
	let phase: TimelinePhase

	private var items: [ChecklistItem] {
		storage.checklistItems.filter { $0.phase == phase }
	}

	private var groupedByCategory: [(ReadinessCategory, [ChecklistItem])] {
		let grouped = Dictionary(grouping: items, by: \.readinessCategory)
		return ReadinessCategory.allCases.compactMap { cat in
			guard let items = grouped[cat], !items.isEmpty else { return nil }
			return (cat, items)
		}
	}

	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 20) {
				phaseHero

				ForEach(groupedByCategory, id: \.0) { category, categoryItems in
					VStack(alignment: .leading, spacing: 10) {
						Label(category.rawValue, systemImage: category.icon)
							.font(.subheadline.weight(.bold))
							.foregroundStyle(AppTheme.forestGreen)

						VStack(spacing: 10) {
							ForEach(categoryItems) { item in
								TaskHowToCard(item: item, storage: storage)
							}
						}
					}
				}
			}
			.padding(.horizontal, 16)
			.padding(.bottom, 40)
		}
		.background(Color(.systemGroupedBackground))
		.navigationBarTitleDisplayMode(.inline)
	}

	private var phaseHero: some View {
		VStack(alignment: .leading, spacing: 12) {
			HStack(spacing: 14) {
				Image(systemName: phase.icon)
					.font(.title2.weight(.bold))
					.foregroundStyle(.white)
					.frame(width: 52, height: 52)
					.background(
						LinearGradient(
							colors: [AppTheme.forestGreen, AppTheme.darkGreen],
							startPoint: .topLeading,
							endPoint: .bottomTrailing
						)
					)
					.clipShape(.rect(cornerRadius: 14))
				VStack(alignment: .leading, spacing: 3) {
					Text(phase.rawValue)
						.font(.title3.weight(.bold))
					Text(phase.subtitle)
						.font(.caption.weight(.bold))
						.foregroundStyle(AppTheme.forestGreen)
				}
				Spacer()
			}

			let completed = items.filter(\.isCompleted).count
			HStack(spacing: 8) {
				ProgressView(value: items.isEmpty ? 0 : Double(completed) / Double(items.count))
					.tint(AppTheme.forestGreen)
				Text("\(completed)/\(items.count)")
					.font(.caption.weight(.bold))
					.foregroundStyle(.secondary)
			}
		}
		.padding(16)
		.background(AppTheme.forestGreen.opacity(0.06))
		.clipShape(.rect(cornerRadius: 16))
	}
}

// MARK: - TaskHowToCard (unchanged)

struct TaskHowToCard: View {
	let item: ChecklistItem
	let storage: StorageService
	@State private var isExpanded: Bool = false

	private var howTo: TaskHowTo? { TaskHowToData.howTo(for: item.id) }

	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			HStack(alignment: .center, spacing: 12) {
				VStack(alignment: .leading, spacing: 4) {
					Text(item.title)
						.font(.subheadline.weight(.bold))
						.strikethrough(item.isCompleted)
						.foregroundStyle(item.isCompleted ? .secondary : .primary)
						.multilineTextAlignment(.leading)
						.lineLimit(isExpanded ? nil : 2)
						.fixedSize(horizontal: false, vertical: true)
					if !item.subtitle.isEmpty {
						Text(item.subtitle)
							.font(.caption.weight(.medium))
							.foregroundStyle(.secondary)
							.multilineTextAlignment(.leading)
							.fixedSize(horizontal: false, vertical: true)
					}
				}
				.frame(maxWidth: .infinity, alignment: .leading)

				Toggle("Mark complete", isOn: Binding(
					get: { item.isCompleted },
					set: { _ in
						withAnimation(.spring(response: 0.3)) {
							storage.toggleChecklistItem(item.id)
						}
					}
				))
				.labelsHidden()
				.tint(AppTheme.forestGreen)
				.sensoryFeedback(.success, trigger: item.isCompleted)

				if howTo != nil {
					Button {
						withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
							isExpanded.toggle()
						}
					} label: {
						Image(systemName: "chevron.down")
							.font(.caption.weight(.bold))
							.foregroundStyle(.secondary)
							.rotationEffect(.degrees(isExpanded ? 180 : 0))
							.frame(width: 28, height: 28)
							.background(Color(.tertiarySystemGroupedBackground))
							.clipShape(Circle())
					}
					.buttonStyle(.plain)
				}
			}
			.padding(14)

			if isExpanded, let howTo {
				VStack(alignment: .leading, spacing: 10) {
					Divider()
					HStack(spacing: 6) {
						Image(systemName: "list.number")
							.font(.caption.weight(.bold))
							.foregroundStyle(AppTheme.forestGreen)
						Text("How to do this")
							.font(.caption.weight(.heavy))
							.foregroundStyle(AppTheme.forestGreen)
							.textCase(.uppercase)
					}
					VStack(alignment: .leading, spacing: 8) {
						ForEach(Array(howTo.steps.enumerated()), id: \.offset) { idx, step in
							HStack(alignment: .top, spacing: 10) {
								Text("\(idx + 1)")
									.font(.caption.weight(.heavy))
									.foregroundStyle(.white)
									.frame(width: 20, height: 20)
									.background(AppTheme.forestGreen)
									.clipShape(Circle())
								Text(step)
									.font(.caption.weight(.medium))
									.foregroundStyle(.primary.opacity(0.85))
									.fixedSize(horizontal: false, vertical: true)
							}
						}
					}
					if let tip = howTo.tip {
						HStack(alignment: .top, spacing: 8) {
							Image(systemName: "lightbulb.fill")
								.font(.caption2)
								.foregroundStyle(AppTheme.gold)
								.padding(.top, 2)
							Text(tip)
								.font(.caption.weight(.semibold))
								.foregroundStyle(.primary.opacity(0.85))
								.fixedSize(horizontal: false, vertical: true)
						}
						.padding(10)
						.frame(maxWidth: .infinity, alignment: .leading)
						.background(AppTheme.gold.opacity(0.08))
						.clipShape(.rect(cornerRadius: 10))
					}
					if let tool = howTo.tool {
						NavigationLink(value: tool.route) {
							HStack {
								Image(systemName: "wrench.and.screwdriver.fill")
								Text(tool.title)
								Spacer()
								Image(systemName: "chevron.right")
									.font(.caption2.weight(.bold))
							}
							.font(.caption.weight(.bold))
							.foregroundStyle(.white)
							.padding(12)
							.frame(maxWidth: .infinity)
							.background(AppTheme.forestGreen)
							.clipShape(.rect(cornerRadius: 10))
						}
						.buttonStyle(.plain)
					}
				}
				.padding(14)
				.transition(.opacity.combined(with: .move(edge: .top)))
			}
		}
		.background(Color(.secondarySystemGroupedBackground))
		.clipShape(.rect(cornerRadius: 12))
		.contextMenu {
			Button {
				withAnimation { storage.toggleChecklistItem(item.id) }
			} label: {
				Label(item.isCompleted ? "Mark Incomplete" : "Mark Complete",
					  systemImage: item.isCompleted ? "circle" : "checkmark.circle.fill")
			}
			if item.isCustom {
				Button(role: .destructive) {
					storage.removeChecklistItem(item.id)
				} label: {
					Label("Delete", systemImage: "trash")
				}
			}
		}
	}
}
