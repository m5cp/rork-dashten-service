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

    // MARK: - Body

    var body: some View {
        ZStack {
            backgroundGradient

            VStack(spacing: 0) {
                if currentPage > 0 {
                    progressBar
                        .padding(.horizontal, 24)
                        .padding(.top, 12)
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
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    .padding(.bottom, 24)
            }
        }
        .overlay(alignment: .topTrailing) {
            if currentPage > 0 && currentPage < totalPages - 1 {
                Button {
                    showSkipConfirm = true
                } label: {
                    Text("Skip")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.7))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .frame(minWidth: 44, minHeight: 44)
                }
                .padding(.top, 6)
                .padding(.trailing, 8)
                .confirmationDialog("Skip onboarding?", isPresented: $showSkipConfirm) {
                    Button("Skip to App") {
                        finishOnboarding()
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
        .fullScreenCover(isPresented: $showPaywall, onDismiss: {
            dismiss()
        }) {
            PaywallView(store: store)
        }
    }

    // MARK: - Background

    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                AppTheme.darkGreen,
                AppTheme.forestGreen.opacity(0.85),
                AppTheme.darkGreen
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .overlay(
            // Subtle radial glow for depth
            RadialGradient(
                colors: [AppTheme.forestGreen.opacity(0.35), .clear],
                center: .top,
                startRadius: 20,
                endRadius: 400
            )
            .blendMode(.plusLighter)
            .opacity(0.4)
        )
        .ignoresSafeArea()
    }

    // MARK: - Progress Bar

    private var progressBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.white.opacity(0.18))
                    .frame(height: 3)
                RoundedRectangle(cornerRadius: 2)
                    .fill(LinearGradient(
                        colors: [AppTheme.gold, .white],
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

    // MARK: - Bottom Bar (balanced Back + Continue)

    private var bottomBar: some View {
        HStack(spacing: 12) {
            // Back — outlined white pill, same height/prominence as Continue
            Button {
                if currentPage > 0 {
                    withAnimation(.spring(response: 0.4)) { currentPage -= 1 }
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.left")
                        .font(.subheadline.weight(.bold))
                    Text("Back")
                        .font(.headline.weight(.bold))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    Capsule().fill(Color.white.opacity(0.12))
                )
                .overlay(
                    Capsule().stroke(Color.white.opacity(0.5), lineWidth: 1.5)
                )
            }
            .opacity(currentPage > 0 ? 1.0 : 0.0)
            .disabled(currentPage == 0)
            .frame(minHeight: 44)

            // Continue — filled green pill
            Button {
                if canAdvance {
                    if currentPage < totalPages - 1 {
                        withAnimation(.spring(response: 0.4)) { currentPage += 1 }
                    } else {
                        finishOnboarding()
                    }
                }
            } label: {
                HStack(spacing: 6) {
                    Text(ctaLabel)
                        .font(.headline.weight(.bold))
                    if currentPage < totalPages - 1 {
                        Image(systemName: "chevron.right")
                            .font(.subheadline.weight(.bold))
                    }
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    Capsule()
                        .fill(
                            canAdvance
                            ? AnyShapeStyle(LinearGradient(
                                colors: [AppTheme.forestGreen, AppTheme.darkGreen],
                                startPoint: .leading,
                                endPoint: .trailing))
                            : AnyShapeStyle(Color.white.opacity(0.18))
                        )
                )
                .shadow(color: canAdvance ? AppTheme.forestGreen.opacity(0.5) : .clear, radius: 12, y: 4)
            }
            .disabled(!canAdvance)
            .frame(minHeight: 44)
            .sensoryFeedback(.impact(weight: .medium), trigger: currentPage)
            .scaleEffect(canAdvance ? 1.0 : 0.97)
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

    // MARK: - SCREEN 1: WELCOME (tighter rhythm)

    private var welcomeScreen: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 8)

            ZStack {
                Circle()
                    .fill(AppTheme.forestGreen.opacity(0.35))
                    .frame(width: 140, height: 140)
                    .blur(radius: 22)
                    .scaleEffect(appeared ? 1.15 : 0.85)
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
                    .frame(width: 92, height: 92)
                    .overlay(
                        Image(systemName: "map.fill")
                            .font(.system(size: 38, weight: .bold))
                            .foregroundStyle(.white)
                    )
                    .overlay(
                        Circle().stroke(Color.white.opacity(0.25), lineWidth: 1)
                    )
                    .shadow(color: AppTheme.forestGreen.opacity(0.5), radius: 20, y: 8)
            }
            .scaleEffect(appeared ? 1 : 0.6)
            .opacity(appeared ? 1 : 0)
            .animation(.spring(response: 0.7, dampingFraction: 0.7), value: appeared)

            Spacer(minLength: 20)

            VStack(spacing: 12) {
                Text("Your transition starts here.")
                    .font(.system(size: 30, weight: .heavy))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 20)
                    .animation(.spring(response: 0.6).delay(0.15), value: appeared)

                Text("A personalized roadmap, the right tools, and a clear plan, so you walk out confident, not guessing.")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.white.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 8)
                    .fixedSize(horizontal: false, vertical: true)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 20)
                    .animation(.spring(response: 0.6).delay(0.25), value: appeared)
            }

            Spacer(minLength: 20)

            VStack(spacing: 10) {
                ForEach(Array(welcomeProps.enumerated()), id: \.0) { i, prop in
                    HStack(spacing: 12) {
                        Image(systemName: prop.0)
                            .font(.body.weight(.semibold))
                            .foregroundStyle(.white)
                            .frame(width: 32, height: 32)
                            .background(Color.white.opacity(0.18))
                            .clipShape(.rect(cornerRadius: 8))
                        Text(prop.1)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.white)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer(minLength: 0)
                    }
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 16)
                    .animation(
                        .spring(response: 0.5).delay(0.3 + Double(i) * 0.1),
                        value: appeared
                    )
                }
            }
            .padding(16)
            .background(Color.white.opacity(0.10))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
            )
            .clipShape(.rect(cornerRadius: 16))

            Spacer(minLength: 8)
        }
        .padding(.horizontal, 24)
        .padding(.top, 8)
    }

    private let welcomeProps: [(String, String)] = [
        ("map.fill", "A week by week roadmap built around your separation date"),
        ("shield.lefthalf.filled", "Know every benefit you earned before you walk out"),
        ("dollarsign.circle.fill", "Financial tools that show you exactly where you stand"),
    ]

    // MARK: - SCREEN 2: BRANCH (compact 2-col grid)

    private var branchScreen: some View {
        VStack(alignment: .leading, spacing: 16) {
            screenHeader(
                "Which branch did you serve?",
                subtitle: "Your roadmap, resume translator, and tools adapt to match."
            )
            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)],
                spacing: 10
            ) {
                ForEach(MilitaryBranch.allCases) { branch in
                    branchOption(branch)
                }
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
    }

    private func branchOption(_ branch: MilitaryBranch) -> some View {
        let isSelected = selectedBranch == branch
        return Button {
            withAnimation(.spring(response: 0.3)) {
                selectedBranch = branch
            }
        } label: {
            HStack(spacing: 10) {
                Image(systemName: branch.icon)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(width: 36, height: 36)
                    .background(
                        isSelected
                        ? AnyShapeStyle(LinearGradient(
                            colors: [AppTheme.forestGreen, AppTheme.darkGreen],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing))
                        : AnyShapeStyle(Color.white.opacity(0.18))
                    )
                    .clipShape(.rect(cornerRadius: 10))
                Text(branch.rawValue)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(glassFill(isSelected: isSelected))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? AppTheme.gold : Color.white.opacity(0.18), lineWidth: isSelected ? 2 : 1)
            )
            .clipShape(.rect(cornerRadius: 14))
            .shadow(color: isSelected ? AppTheme.forestGreen.opacity(0.45) : .clear, radius: 10, y: 4)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.spring(response: 0.3), value: isSelected)
        .sensoryFeedback(.selection, trigger: isSelected)
    }

    // MARK: - SCREEN 3: TIMELINE (compact rows, all fit)

    private var timelineScreen: some View {
        VStack(alignment: .leading, spacing: 14) {
            screenHeader(
                "Where are you in your transition?",
                subtitle: "Your roadmap meets you exactly where you are."
            )

            VStack(spacing: 8) {
                ForEach(TransitionTimeline.allCases) { timeline in
                    timelineOption(timeline)
                }
            }

            if selectedTimeline == .separated {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Are you separated or retired?")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.white)
                    ForEach(PostServiceStatus.allCases) { status in
                        postServiceOption(status)
                    }
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }

            if let t = selectedTimeline, t != .separated {
                HStack(spacing: 10) {
                    Image(systemName: "calendar")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.white)
                    Text("Separation date")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.white)
                    Spacer()
                    DatePicker(
                        "",
                        selection: $separationDate,
                        in: Date()...,
                        displayedComponents: [.date]
                    )
                    .labelsHidden()
                    .colorScheme(.dark)
                    .tint(AppTheme.gold)
                }
                .padding(12)
                .background(glassFill(isSelected: false))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.white.opacity(0.18), lineWidth: 1)
                )
                .clipShape(.rect(cornerRadius: 14))
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .animation(.spring(response: 0.4), value: selectedTimeline)
    }

    private func timelineOption(_ timeline: TransitionTimeline) -> some View {
        let isSelected = selectedTimeline == timeline
        return Button {
            withAnimation(.spring(response: 0.35)) {
                selectedTimeline = timeline
                if timeline != .separated { selectedPostServiceStatus = nil }
            }
        } label: {
            optionRow(
                icon: timeline.icon,
                title: timeline.rawValue,
                subtitle: timeline.description,
                isSelected: isSelected,
                indicator: .radio
            )
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
            optionRow(
                icon: status.icon,
                title: status.rawValue,
                subtitle: status.subtitle,
                isSelected: isSelected,
                indicator: .radio
            )
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: isSelected)
    }

    // MARK: - SCREEN 4: PAIN POINTS (compact rows)

    private var painPointsScreen: some View {
        VStack(alignment: .leading, spacing: 14) {
            screenHeader(
                "What concerns you most?",
                subtitle: "Select all that apply. Your roadmap prioritizes these first."
            )

            VStack(spacing: 8) {
                ForEach(painPoints, id: \.0) { id, icon, label in
                    painPointOption(id: id, icon: icon, label: label)
                }
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .animation(.spring(response: 0.35), value: selectedPainPoints.count)
    }

    private let painPoints: [(String, String, String)] = [
        ("resume", "doc.text.fill", "Translating my military experience"),
        ("benefits", "shield.fill", "Understanding my benefits"),
        ("finance", "dollarsign.circle.fill", "My financial situation after service"),
        ("housing", "house.fill", "Housing, rent or buy decisions"),
        ("career", "briefcase.fill", "Finding the right civilian career"),
        ("healthcare", "cross.fill", "Healthcare coverage after service"),
        ("family", "person.3.fill", "Family impact during transition"),
    ]

    private func painPointOption(id: String, icon: String, label: String) -> some View {
        let isSelected = selectedPainPoints.contains(id)
        return Button {
            withAnimation(.spring(response: 0.3)) {
                if isSelected { selectedPainPoints.remove(id) }
                else { selectedPainPoints.insert(id) }
            }
        } label: {
            optionRow(
                icon: icon,
                title: label,
                subtitle: nil,
                isSelected: isSelected,
                indicator: .check
            )
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: isSelected)
    }

    // MARK: - SCREEN 5: GOALS (compact)

    private var goalsScreen: some View {
        VStack(alignment: .leading, spacing: 14) {
            screenHeader(
                "What are you working toward?",
                subtitle: "Pick one or more. This shapes your weekly missions."
            )

            ScrollView(showsIndicators: false) {
                VStack(spacing: 8) {
                    ForEach(TransitionGoal.allCases) { goal in
                        goalOption(goal)
                    }
                }
                .padding(.bottom, 8)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
    }

    private func goalOption(_ goal: TransitionGoal) -> some View {
        let isSelected = selectedGoals.contains(goal)
        return Button {
            withAnimation(.spring(response: 0.3)) {
                if isSelected { selectedGoals.remove(goal) }
                else { selectedGoals.insert(goal) }
            }
        } label: {
            optionRow(
                icon: goal.icon,
                title: goal.rawValue,
                subtitle: nil,
                isSelected: isSelected,
                indicator: .check
            )
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: isSelected)
    }

    // MARK: - SCREEN 6: DISCLAIMER

    private var disclaimerScreen: some View {
        VStack(alignment: .leading, spacing: 14) {
            screenHeader(
                "Almost there.",
                subtitle: "One quick acknowledgment before your roadmap is ready."
            )

            VStack(alignment: .leading, spacing: 12) {
                disclaimerRow(
                    "map.fill",
                    "Your personalized roadmap is ready the moment you step in."
                )
                disclaimerRow(
                    "dollarsign.circle.fill",
                    "Calculators and tools are general information, not financial, legal, or medical advice."
                )
                disclaimerRow(
                    "shield.fill",
                    "DashTen is not affiliated with the Department of War, DoD, VA, or any government agency."
                )
                disclaimerRow(
                    "lock.fill",
                    "Your data stays on your device. Nothing is sent to a server."
                )
            }
            .padding(14)
            .background(glassFill(isSelected: false))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.white.opacity(0.18), lineWidth: 1)
            )
            .clipShape(.rect(cornerRadius: 14))

            Button {
                withAnimation(.spring(response: 0.3)) {
                    disclaimerAccepted.toggle()
                }
            } label: {
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(
                                disclaimerAccepted
                                ? AppTheme.gold
                                : Color.white.opacity(0.5),
                                lineWidth: 1.5
                            )
                            .frame(width: 24, height: 24)
                        if disclaimerAccepted {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(AppTheme.gold)
                                .frame(width: 24, height: 24)
                            Image(systemName: "checkmark")
                                .font(.caption.weight(.heavy))
                                .foregroundStyle(AppTheme.darkGreen)
                        }
                    }
                    Text("I understand this is an informational guide and not official government guidance.")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer(minLength: 0)
                }
                .padding(12)
                .background(glassFill(isSelected: disclaimerAccepted))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(disclaimerAccepted ? AppTheme.gold : Color.white.opacity(0.18), lineWidth: disclaimerAccepted ? 1.5 : 1)
                )
                .clipShape(.rect(cornerRadius: 14))
                .contentShape(Rectangle())
                .frame(minHeight: 44)
            }
            .buttonStyle(.plain)
            .sensoryFeedback(.selection, trigger: disclaimerAccepted)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
    }

    private func disclaimerRow(_ icon: String, _ text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.caption.weight(.bold))
                .foregroundStyle(AppTheme.gold)
                .frame(width: 22, height: 22)
                .background(Color.white.opacity(0.12))
                .clipShape(.rect(cornerRadius: 6))
            Text(text)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white.opacity(0.92))
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 0)
        }
    }

    // MARK: - Shared helpers

    private enum OptionIndicator { case radio, check }

    private func optionRow(
        icon: String,
        title: String,
        subtitle: String?,
        isSelected: Bool,
        indicator: OptionIndicator
    ) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.body.weight(.semibold))
                .foregroundStyle(.white)
                .frame(width: 34, height: 34)
                .background(
                    isSelected
                    ? AnyShapeStyle(LinearGradient(
                        colors: [AppTheme.forestGreen, AppTheme.darkGreen],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing))
                    : AnyShapeStyle(Color.white.opacity(0.18))
                )
                .clipShape(.rect(cornerRadius: 9))

            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)
                if let subtitle {
                    Text(subtitle)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.75))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            Spacer(minLength: 0)
            Image(systemName: indicatorIcon(indicator: indicator, isSelected: isSelected))
                .font(.title3)
                .foregroundStyle(isSelected ? AnyShapeStyle(AppTheme.gold) : AnyShapeStyle(Color.white.opacity(0.45)))
        }
        .padding(12)
        .background(glassFill(isSelected: isSelected))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(isSelected ? AppTheme.gold : Color.white.opacity(0.18), lineWidth: isSelected ? 2 : 1)
        )
        .clipShape(.rect(cornerRadius: 14))
        .shadow(color: isSelected ? AppTheme.forestGreen.opacity(0.4) : .clear, radius: 10, y: 4)
        .contentShape(Rectangle())
    }

    private func indicatorIcon(indicator: OptionIndicator, isSelected: Bool) -> String {
        switch indicator {
        case .radio: return isSelected ? "checkmark.circle.fill" : "circle"
        case .check: return isSelected ? "checkmark.square.fill" : "square"
        }
    }

    private func glassFill(isSelected: Bool) -> Color {
        isSelected ? Color.white.opacity(0.18) : Color.white.opacity(0.08)
    }

    private func screenHeader(_ title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 24, weight: .heavy))
                .foregroundStyle(.white)
                .fixedSize(horizontal: false, vertical: true)
            Text(subtitle)
                .font(.footnote.weight(.medium))
                .foregroundStyle(.white.opacity(0.75))
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: - Complete Onboarding

    private func finishOnboarding() {
        storage.profile.branch = selectedBranch
        storage.profile.timeline = selectedTimeline
        storage.profile.separationDate = selectedTimeline == .separated ? nil : separationDate
        if selectedTimeline == .separated, let status = selectedPostServiceStatus {
            storage.applyPostServiceStatus(status)
        }
        storage.profile.goals = Array(selectedGoals)
        storage.profile.hasAcceptedDisclaimer = true
        storage.profile.hasCompletedOnboarding = true
        // Show paywall first; onboarding view dismisses after paywall closes.
        showPaywall = true
    }
}
