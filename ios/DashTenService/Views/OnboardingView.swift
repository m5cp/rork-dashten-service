import SwiftUI

struct OnboardingView: View {
    let storage: StorageService
    var store: StoreViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var currentPage: Int = 0
    @State private var selectedBranch: MilitaryBranch? = nil
    @State private var selectedTimeline: TransitionTimeline? = nil
    @State private var selectedGoals: Set<TransitionGoal> = []
    @State private var selectedPostServiceStatus: PostServiceStatus? = nil
    @State private var separationDate: Date = Calendar.current.date(byAdding: .month, value: 12, to: Date()) ?? Date()
    @State private var selectedPainPoints: Set<String> = []
    @State private var disclaimerAccepted: Bool = false
    @State private var showPaywall: Bool = false
    @State private var appeared: Bool = false
    @State private var showSkipConfirm: Bool = false

    private let totalPages = 6

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [AppTheme.darkGreen, Color(.systemBackground)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                if currentPage > 0 {
                    progressBar
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                        .transition(.opacity)
                }

                TabView(selection: $currentPage) {
                    welcomeScreen.tag(0)
                    branchScreen.tag(1)
                    timelineScreen.tag(2)
                    painPointsScreen.tag(3)
                    goalsScreen.tag(4)
                    disclaimerScreen.tag(5)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.spring(response: 0.45, dampingFraction: 0.85), value: currentPage)

                bottomBar
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
            }
        }
        .overlay(alignment: .topTrailing) {
            if currentPage > 0 && currentPage < totalPages - 1 {
                Button {
                    showSkipConfirm = true
                } label: {
                    Text("Skip")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.6))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .frame(minWidth: 44, minHeight: 44)
                }
                .padding(.top, 8)
                .padding(.trailing, 8)
                .confirmationDialog("Skip onboarding?", isPresented: $showSkipConfirm) {
                    Button("Skip to App") {
                        completeOnboarding()
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("You can update your preferences anytime in your profile.")
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.7)) { appeared = true }
        }
        .fullScreenCover(isPresented: $showPaywall) {
            PaywallView(store: store)
        }
    }

    // MARK: - Progress Bar

    private var progressBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.white.opacity(0.15))
                    .frame(height: 3)
                RoundedRectangle(cornerRadius: 2)
                    .fill(LinearGradient(
                        colors: [AppTheme.forestGreen, AppTheme.gold],
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .frame(
                        width: geo.size.width * (Double(currentPage) / Double(totalPages - 1)),
                        height: 3
                    )
                    .animation(.spring(response: 0.5), value: currentPage)
            }
        }
        .frame(height: 3)
    }

    // MARK: - Bottom Bar

    private var bottomBar: some View {
        HStack {
            if currentPage > 0 {
                Button {
                    withAnimation(.spring(response: 0.4)) { currentPage -= 1 }
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.caption.weight(.bold))
                        Text("Back")
                            .font(.subheadline.weight(.semibold))
                    }
                    .foregroundStyle(.white.opacity(0.7))
                    .frame(minWidth: 44, minHeight: 44)
                }
            }
            Spacer()
            Button {
                if canAdvance {
                    if currentPage < totalPages - 1 {
                        withAnimation(.spring(response: 0.4)) { currentPage += 1 }
                    } else {
                        completeOnboarding()
                    }
                }
            } label: {
                Text(ctaLabel)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 14)
                    .background(
                        canAdvance
                            ? LinearGradient(
                                colors: [AppTheme.forestGreen, AppTheme.darkGreen],
                                startPoint: .leading,
                                endPoint: .trailing)
                            : LinearGradient(
                                colors: [Color.gray.opacity(0.4), Color.gray.opacity(0.4)],
                                startPoint: .leading,
                                endPoint: .trailing)
                    )
                    .clipShape(Capsule())
            }
            .disabled(!canAdvance)
            .sensoryFeedback(.impact(weight: .medium), trigger: currentPage)
            .scaleEffect(canAdvance ? 1.0 : 0.95)
            .animation(.spring(response: 0.3), value: canAdvance)
        }
    }

    private var ctaLabel: String {
        switch currentPage {
        case 0: return "Let's Go"
        case totalPages - 1: return "Enter DashTen"
        default: return "Continue"
        }
    }

    private var canAdvance: Bool {
        switch currentPage {
        case 0: return true
        case 1: return selectedBranch != nil
        case 2: return selectedTimeline != nil && (selectedTimeline != .separated || selectedPostServiceStatus != nil)
        case 3: return true
        case 4: return !selectedGoals.isEmpty
        case 5: return disclaimerAccepted
        default: return false
        }
    }

    // MARK: - SCREEN 1: WELCOME

    private var welcomeScreen: some View {
        ScrollView {
            VStack(spacing: 0) {
                Spacer(minLength: 40)

                ZStack {
                    Circle()
                        .fill(AppTheme.forestGreen.opacity(0.25))
                        .frame(width: 140, height: 140)
                        .blur(radius: 20)
                        .scaleEffect(appeared ? 1.2 : 0.8)
                        .animation(
                            .easeInOut(duration: 2.5).repeatForever(autoreverses: true),
                            value: appeared
                        )

                    Circle()
                        .fill(LinearGradient(
                            colors: [AppTheme.forestGreen, AppTheme.darkGreen],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 100, height: 100)
                        .overlay(
                            Image(systemName: "map.fill")
                                .font(.system(size: 42, weight: .bold))
                                .foregroundStyle(.white)
                        )
                        .shadow(color: AppTheme.forestGreen.opacity(0.5), radius: 20, y: 8)
                }
                .scaleEffect(appeared ? 1 : 0.6)
                .opacity(appeared ? 1 : 0)
                .animation(.spring(response: 0.7, dampingFraction: 0.7), value: appeared)

                Spacer(minLength: 32)

                VStack(spacing: 16) {
                    Text("Your transition starts here.")
                        .font(.system(size: 36, weight: .heavy))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 20)
                        .animation(.spring(response: 0.6).delay(0.15), value: appeared)

                    Text("A personalized roadmap, the right tools, and a clear plan — so you walk out confident, not guessing.")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 8)
                        .fixedSize(horizontal: false, vertical: true)
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 20)
                        .animation(.spring(response: 0.6).delay(0.25), value: appeared)
                }

                Spacer(minLength: 40)

                VStack(spacing: 12) {
                    ForEach(Array(welcomeProps.enumerated()), id: \.0) { i, prop in
                        HStack(spacing: 14) {
                            Image(systemName: prop.0)
                                .font(.body.weight(.semibold))
                                .foregroundStyle(.white)
                                .frame(width: 32, height: 32)
                                .background(Color.white.opacity(0.15))
                                .clipShape(.rect(cornerRadius: 8))
                            Text(prop.1)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.white)
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer()
                        }
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 16)
                        .animation(
                            .spring(response: 0.5).delay(0.3 + Double(i) * 0.1),
                            value: appeared
                        )
                    }
                }
                .padding(20)
                .background(.white.opacity(0.12))
                .clipShape(.rect(cornerRadius: 16))

                Spacer(minLength: 24)
            }
            .padding(.horizontal, 24)
        }
    }

    private let welcomeProps: [(String, String)] = [
        ("map.fill", "A week-by-week roadmap built around your separation date"),
        ("shield.lefthalf.filled", "Know every benefit you earned before you walk out"),
        ("dollarsign.circle.fill", "Financial tools that show you exactly where you stand"),
    ]

    // MARK: - SCREEN 2: BRANCH

    private var branchScreen: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                screenHeader(
                    "Which branch did you serve?",
                    subtitle: "Your roadmap, resume translator, and tools adapt to match."
                )
                LazyVGrid(
                    columns: [GridItem(.flexible()), GridItem(.flexible())],
                    spacing: 12
                ) {
                    ForEach(MilitaryBranch.allCases) { branch in
                        branchOption(branch)
                    }
                }
                Spacer(minLength: 24)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
        }
    }

    private func branchOption(_ branch: MilitaryBranch) -> some View {
        let isSelected = selectedBranch == branch
        return Button {
            withAnimation(.spring(response: 0.3)) {
                selectedBranch = branch
            }
        } label: {
            VStack(spacing: 10) {
                Image(systemName: branch.icon)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(isSelected ? .white : AppTheme.forestGreen)
                    .frame(width: 52, height: 52)
                    .background(
                        isSelected
                            ? LinearGradient(
                                colors: [AppTheme.forestGreen, AppTheme.darkGreen],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing)
                            : LinearGradient(
                                colors: [AppTheme.forestGreen.opacity(0.12), AppTheme.forestGreen.opacity(0.08)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing)
                    )
                    .clipShape(.rect(cornerRadius: 14))
                    .shadow(
                        color: isSelected ? AppTheme.forestGreen.opacity(0.4) : .clear,
                        radius: 8, y: 4
                    )
                Text(branch.rawValue)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(isSelected ? .primary : .secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                isSelected
                    ? Color(.secondarySystemGroupedBackground)
                    : Color(.secondarySystemGroupedBackground).opacity(0.85)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? AppTheme.forestGreen : Color.clear, lineWidth: 1.5)
            )
            .clipShape(.rect(cornerRadius: 14))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.spring(response: 0.3), value: isSelected)
        .sensoryFeedback(.selection, trigger: isSelected)
    }

    // MARK: - SCREEN 3: TIMELINE

    private var timelineScreen: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                screenHeader(
                    "Where are you in your transition?",
                    subtitle: "Your roadmap meets you exactly where you are."
                )

                VStack(spacing: 10) {
                    ForEach(TransitionTimeline.allCases) { timeline in
                        timelineOption(timeline)
                    }
                }

                if selectedTimeline == .separated {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Are you separated or retired?")
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(.primary)
                        ForEach(PostServiceStatus.allCases) { status in
                            postServiceOption(status)
                        }
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                if let t = selectedTimeline, t != .separated {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Approximate separation date")
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(.primary)
                        DatePicker(
                            "",
                            selection: $separationDate,
                            in: Date()...,
                            displayedComponents: [.date]
                        )
                        .datePickerStyle(.graphical)
                        .tint(AppTheme.forestGreen)
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(.rect(cornerRadius: 14))
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                Spacer(minLength: 24)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .animation(.spring(response: 0.4), value: selectedTimeline)
        }
    }

    private func timelineOption(_ timeline: TransitionTimeline) -> some View {
        let isSelected = selectedTimeline == timeline
        return Button {
            withAnimation(.spring(response: 0.35)) {
                selectedTimeline = timeline
                if timeline != .separated { selectedPostServiceStatus = nil }
            }
        } label: {
            HStack(spacing: 14) {
                Image(systemName: timeline.icon)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(isSelected ? .white : AppTheme.forestGreen)
                    .frame(width: 36, height: 36)
                    .background(
                        isSelected
                            ? LinearGradient(
                                colors: [AppTheme.forestGreen, AppTheme.darkGreen],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing)
                            : LinearGradient(
                                colors: [AppTheme.forestGreen.opacity(0.12), AppTheme.forestGreen.opacity(0.12)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing)
                    )
                    .clipShape(.rect(cornerRadius: 10))
                VStack(alignment: .leading, spacing: 2) {
                    Text(timeline.rawValue)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.primary)
                    Text(timeline.description)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(isSelected ? AnyShapeStyle(AppTheme.forestGreen) : AnyShapeStyle(HierarchicalShapeStyle.tertiary))
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? AppTheme.forestGreen : Color.clear, lineWidth: 1.5)
            )
            .clipShape(.rect(cornerRadius: 14))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: isSelected)
    }

    private func postServiceOption(_ status: PostServiceStatus) -> some View {
        let isSelected = selectedPostServiceStatus == status
        return Button {
            withAnimation(.spring(response: 0.3)) {
                selectedPostServiceStatus = status
            }
        } label: {
            HStack(spacing: 14) {
                Image(systemName: status.icon)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(isSelected ? .white : AppTheme.forestGreen)
                    .frame(width: 36, height: 36)
                    .background(
                        isSelected
                            ? LinearGradient(
                                colors: [AppTheme.forestGreen, AppTheme.darkGreen],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing)
                            : LinearGradient(
                                colors: [AppTheme.forestGreen.opacity(0.12), AppTheme.forestGreen.opacity(0.12)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing)
                    )
                    .clipShape(.rect(cornerRadius: 10))
                VStack(alignment: .leading, spacing: 2) {
                    Text(status.rawValue)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.primary)
                    Text(status.subtitle)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(isSelected ? AnyShapeStyle(AppTheme.forestGreen) : AnyShapeStyle(HierarchicalShapeStyle.tertiary))
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? AppTheme.forestGreen : Color.clear, lineWidth: 1.5)
            )
            .clipShape(.rect(cornerRadius: 12))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: isSelected)
    }

    // MARK: - Shared

    private func screenHeader(_ title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 28, weight: .heavy))
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)
            Text(subtitle)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.white.opacity(0.75))
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: - Complete Onboarding

    private func completeOnboarding() {
        storage.profile.branch = selectedBranch
        storage.profile.timeline = selectedTimeline
        storage.profile.separationDate = selectedTimeline == .separated ? nil : separationDate
        if selectedTimeline == .separated, let status = selectedPostServiceStatus {
            storage.applyPostServiceStatus(status)
        }
        storage.profile.goals = Array(selectedGoals)
        storage.profile.hasAcceptedDisclaimer = true
        storage.profile.hasCompletedOnboarding = true
        dismiss()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showPaywall = true
        }
    }

    // MARK: - SCREEN 4: PAIN POINTS

    private var painPointsScreen: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                screenHeader(
                    "What concerns you most?",
                    subtitle: "Select all that apply. Your roadmap prioritizes these first."
                )

                VStack(spacing: 10) {
                    ForEach(painPoints, id: \.0) { id, icon, label in
                        painPointOption(id: id, icon: icon, label: label)
                    }
                }

                if !selectedPainPoints.isEmpty {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(AppTheme.forestGreen)
                        Text("Got it. Your roadmap will cover these first.")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(AppTheme.forestGreen)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(12)
                    .background(AppTheme.forestGreen.opacity(0.08))
                    .clipShape(.rect(cornerRadius: 10))
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                Spacer(minLength: 24)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .animation(.spring(response: 0.35), value: selectedPainPoints.count)
        }
    }

    private let painPoints: [(String, String, String)] = [
        ("resume", "doc.text.fill", "Translating my military experience to a civilian resume"),
        ("benefits", "shield.fill", "Understanding what benefits I have and how to use them"),
        ("finance", "dollarsign.circle.fill", "Figuring out my financial situation after service"),
        ("housing", "house.fill", "Housing — where to live and whether to rent or buy"),
        ("career", "briefcase.fill", "Finding a job or career that fits my background"),
        ("healthcare", "cross.fill", "Healthcare coverage after my military coverage ends"),
        ("family", "person.3.fill", "Managing the impact on my family during the transition"),
    ]

    private func painPointOption(id: String, icon: String, label: String) -> some View {
        let isSelected = selectedPainPoints.contains(id)
        return Button {
            withAnimation(.spring(response: 0.3)) {
                if isSelected { selectedPainPoints.remove(id) }
                else { selectedPainPoints.insert(id) }
            }
        } label: {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(isSelected ? .white : AppTheme.forestGreen)
                    .frame(width: 36, height: 36)
                    .background(
                        isSelected
                        ? LinearGradient(
                            colors: [AppTheme.forestGreen, AppTheme.darkGreen],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing)
                        : LinearGradient(
                            colors: [AppTheme.forestGreen.opacity(0.12), AppTheme.forestGreen.opacity(0.12)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing)
                    )
                    .clipShape(.rect(cornerRadius: 10))
                Text(label)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .font(.title3)
                    .foregroundStyle(isSelected ? AnyShapeStyle(AppTheme.forestGreen) : AnyShapeStyle(HierarchicalShapeStyle.tertiary))
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? AppTheme.forestGreen : Color.clear, lineWidth: 1.5)
            )
            .clipShape(.rect(cornerRadius: 14))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: isSelected)
    }

    // MARK: - SCREEN 5: GOALS

    private var goalsScreen: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                screenHeader(
                    "What are you working toward?",
                    subtitle: "Pick one or more. This shapes your weekly missions and tool recommendations."
                )

                VStack(spacing: 10) {
                    ForEach(TransitionGoal.allCases) { goal in
                        goalOption(goal)
                    }
                }

                Spacer(minLength: 24)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
        }
    }

    private func goalOption(_ goal: TransitionGoal) -> some View {
        let isSelected = selectedGoals.contains(goal)
        return Button {
            withAnimation(.spring(response: 0.3)) {
                if isSelected { selectedGoals.remove(goal) }
                else { selectedGoals.insert(goal) }
            }
        } label: {
            HStack(spacing: 14) {
                Image(systemName: goal.icon)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(isSelected ? .white : AppTheme.forestGreen)
                    .frame(width: 36, height: 36)
                    .background(
                        isSelected
                        ? LinearGradient(
                            colors: [AppTheme.forestGreen, AppTheme.darkGreen],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing)
                        : LinearGradient(
                            colors: [AppTheme.forestGreen.opacity(0.12), AppTheme.forestGreen.opacity(0.12)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing)
                    )
                    .clipShape(.rect(cornerRadius: 10))
                VStack(alignment: .leading, spacing: 2) {
                    Text(goal.rawValue)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.primary)
                    Text(goal.description)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .font(.title3)
                    .foregroundStyle(isSelected ? AnyShapeStyle(AppTheme.forestGreen) : AnyShapeStyle(HierarchicalShapeStyle.tertiary))
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? AppTheme.forestGreen : Color.clear, lineWidth: 1.5)
            )
            .clipShape(.rect(cornerRadius: 14))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: isSelected)
    }

    // MARK: - SCREEN 6: DISCLAIMER

    private var disclaimerScreen: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                screenHeader(
                    "Almost there.",
                    subtitle: "One quick acknowledgment before your roadmap is ready."
                )

                VStack(alignment: .leading, spacing: 16) {

                    VStack(alignment: .leading, spacing: 14) {
                        disclaimerRow(
                            "map.fill",
                            AppTheme.forestGreen,
                            "Your personalized roadmap is ready the moment you step in."
                        )
                        disclaimerRow(
                            "dollarsign.circle.fill",
                            AppTheme.gold,
                            "All calculators and tools are general information — not financial, legal, or medical advice."
                        )
                        disclaimerRow(
                            "shield.fill",
                            .blue,
                            "DashTen is not affiliated with the Department of War, DoD, VA, or any government agency."
                        )
                        disclaimerRow(
                            "lock.fill",
                            Color(.secondaryLabel),
                            "Your data stays on your device. Nothing is sent to a server."
                        )
                    }
                    .padding(16)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(.rect(cornerRadius: 16))

                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            disclaimerAccepted.toggle()
                        }
                    } label: {
                        HStack(spacing: 14) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(
                                        disclaimerAccepted
                                        ? AppTheme.forestGreen
                                        : Color.secondary.opacity(0.4),
                                        lineWidth: 1.5
                                    )
                                    .frame(width: 24, height: 24)
                                if disclaimerAccepted {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(AppTheme.forestGreen)
                                        .frame(width: 24, height: 24)
                                    Image(systemName: "checkmark")
                                        .font(.caption.weight(.heavy))
                                        .foregroundStyle(.white)
                                }
                            }
                            Text("I understand this is an informational guide and not official government guidance.")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.primary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .contentShape(Rectangle())
                        .frame(minHeight: 44)
                    }
                    .buttonStyle(.plain)
                    .sensoryFeedback(.selection, trigger: disclaimerAccepted)
                }

                if disclaimerAccepted {
                    VStack(spacing: 10) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 48))
                            .foregroundStyle(AppTheme.forestGreen)
                        Text("You're ready.")
                            .font(.title2.weight(.bold))
                            .foregroundStyle(.primary)
                        Text("Your roadmap is waiting.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .transition(.scale.combined(with: .opacity))
                }

                Spacer(minLength: 24)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
        }
    }

    private func disclaimerRow(_ icon: String, _ color: Color, _ text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.caption.weight(.bold))
                .foregroundStyle(color)
                .frame(width: 20)
                .padding(.top, 2)
            Text(text)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.primary.opacity(0.85))
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
