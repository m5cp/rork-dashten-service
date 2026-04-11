import SwiftUI

struct OnboardingView: View {
    @Bindable var storage: StorageService
    @State private var currentPage: Int = 0
    @State private var selectedBranch: MilitaryBranch?
    @State private var selectedTimeline: TransitionTimeline?
    @State private var separationDate: Date = Calendar.current.date(byAdding: .month, value: 12, to: Date()) ?? Date()
    @State private var selectedGoals: Set<TransitionGoal> = []
    @State private var disclaimerAccepted: Bool = false

    private let totalPages = 5

    var body: some View {
        VStack(spacing: 0) {
            if currentPage > 0 {
                HStack {
                    Spacer()
                    Button("Skip") {
                        skipOnboarding()
                    }
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.primary.opacity(0.7))
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)

                HStack(spacing: 6) {
                    ForEach(0..<totalPages, id: \.self) { index in
                        Capsule()
                            .fill(index <= currentPage ? AppTheme.forestGreen : AppTheme.forestGreen.opacity(0.2))
                            .frame(height: 4)
                            .animation(.spring(response: 0.3), value: currentPage)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)
            }

            TabView(selection: $currentPage) {
                welcomePage.tag(0)
                branchPage.tag(1)
                timelinePage.tag(2)
                goalsPage.tag(3)
                disclaimerPage.tag(4)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.spring(response: 0.4), value: currentPage)

            if currentPage > 0 {
                bottomBar
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)
            }
        }
        .background(currentPage == 0 ? Color(red: 0.05, green: 0.12, blue: 0.05) : Color(.systemGroupedBackground))
    }

    @State private var welcomeAnimated: Bool = false
    @State private var counterValue: Int = 0
    private let targetCounter = 200000

    private var welcomePage: some View {
        ZStack {
            Color(red: 0.05, green: 0.12, blue: 0.05)
                .ignoresSafeArea()

            MeshGradient(
                width: 3, height: 3,
                points: [
                    [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                    [0.0, 0.5], [0.55, 0.45], [1.0, 0.5],
                    [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
                ],
                colors: [
                    Color(red: 0.05, green: 0.12, blue: 0.05),
                    AppTheme.darkGreen,
                    Color(red: 0.05, green: 0.12, blue: 0.05),
                    AppTheme.darkGreen,
                    AppTheme.gold.opacity(0.15),
                    Color(red: 0.05, green: 0.12, blue: 0.05),
                    Color(red: 0.05, green: 0.12, blue: 0.05),
                    AppTheme.darkGreen,
                    Color(red: 0.05, green: 0.12, blue: 0.05)
                ]
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 36) {
                    VStack(spacing: 20) {
                        Image(systemName: "arrow.up.forward.circle.fill")
                            .font(.system(size: 72, weight: .thin))
                            .foregroundStyle(AppTheme.gold)
                            .shadow(color: AppTheme.gold.opacity(0.4), radius: 20, y: 8)
                            .scaleEffect(welcomeAnimated ? 1.0 : 0.3)
                            .opacity(welcomeAnimated ? 1 : 0)
                            .animation(.spring(response: 1.0, dampingFraction: 0.5).delay(0.3), value: welcomeAnimated)

                        Text("DashTen")
                            .font(.system(size: 52, weight: .bold))
                            .foregroundStyle(.white)
                            .opacity(welcomeAnimated ? 1 : 0)
                            .offset(y: welcomeAnimated ? 0 : 30)
                            .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.7), value: welcomeAnimated)
                    }

                    VStack(spacing: 8) {
                        Text("\(counterValue.formatted(.number))+")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundStyle(AppTheme.gold)
                            .contentTransition(.numericText())
                            .opacity(welcomeAnimated ? 1 : 0)
                            .animation(.spring(response: 0.8).delay(1.2), value: welcomeAnimated)

                        Text("service members transition every year.")
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(.white.opacity(0.9))
                            .opacity(welcomeAnimated ? 1 : 0)
                            .animation(.spring(response: 0.8).delay(1.4), value: welcomeAnimated)

                        Text("Most wish they started planning sooner.")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.white.opacity(0.7))
                            .opacity(welcomeAnimated ? 1 : 0)
                            .animation(.spring(response: 0.8).delay(1.6), value: welcomeAnimated)
                    }
                }

                Spacer()

                VStack(spacing: 24) {
                    HStack(spacing: 20) {
                        FeatureIcon(icon: "map.fill", label: "Plan")
                        FeatureIcon(icon: "checkmark.circle.fill", label: "Track")
                        FeatureIcon(icon: "bolt.fill", label: "Act")
                    }
                    .opacity(welcomeAnimated ? 1 : 0)
                    .offset(y: welcomeAnimated ? 0 : 20)
                    .animation(.spring(response: 0.7).delay(2.0), value: welcomeAnimated)

                    Button {
                        withAnimation(.spring(response: 0.4)) { currentPage = 1 }
                    } label: {
                        Text("Begin Your Transition")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(AppTheme.darkGreen)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(AppTheme.gold)
                            .clipShape(Capsule())
                    }
                    .opacity(welcomeAnimated ? 1 : 0)
                    .offset(y: welcomeAnimated ? 0 : 20)
                    .animation(.spring(response: 0.7).delay(2.3), value: welcomeAnimated)
                    .sensoryFeedback(.impact(weight: .medium), trigger: currentPage)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 48)
            }
        }
        .onAppear {
            welcomeAnimated = true
            animateCounter()
        }
    }

    private func animateCounter() {
        let steps = 30
        let increment = targetCounter / steps
        for i in 1...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2 + Double(i) * 0.03) {
                withAnimation(.easeOut(duration: 0.05)) {
                    counterValue = min(i * increment, targetCounter)
                }
            }
        }
    }

    @State private var branchAnimated: Bool = false

    private var branchPage: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    Image(systemName: "shield.lefthalf.filled")
                        .font(.system(size: 40))
                        .foregroundStyle(AppTheme.forestGreen)
                        .opacity(branchAnimated ? 1 : 0)
                        .scaleEffect(branchAnimated ? 1 : 0.6)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1), value: branchAnimated)

                    Text("Your Background")
                        .font(.title2.bold())
                        .opacity(branchAnimated ? 1 : 0)
                        .animation(.spring(response: 0.5).delay(0.2), value: branchAnimated)

                    Text("Select your branch or affiliation")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary.opacity(0.7))
                        .opacity(branchAnimated ? 1 : 0)
                        .animation(.spring(response: 0.5).delay(0.3), value: branchAnimated)
                }
                .padding(.top, 24)

                LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                    ForEach(Array(MilitaryBranch.allCases.enumerated()), id: \.element.id) { index, branch in
                        Button {
                            selectedBranch = branch
                        } label: {
                            VStack(spacing: 10) {
                                Image(systemName: branch.icon)
                                    .font(.title2)
                                Text(branch.rawValue)
                                    .font(.subheadline.weight(.bold))
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(selectedBranch == branch ? AppTheme.forestGreen.opacity(0.12) : Color(.secondarySystemGroupedBackground))
                            .foregroundStyle(selectedBranch == branch ? AppTheme.forestGreen : .primary)
                            .clipShape(.rect(cornerRadius: 14))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(selectedBranch == branch ? AppTheme.forestGreen : .clear, lineWidth: 2)
                            )
                        }
                        .sensoryFeedback(.selection, trigger: selectedBranch)
                        .opacity(branchAnimated ? 1 : 0)
                        .offset(y: branchAnimated ? 0 : 16)
                        .animation(.spring(response: 0.5).delay(0.3 + Double(index) * 0.04), value: branchAnimated)
                    }
                }
            }
            .padding(.horizontal, 24)
        }
        .scrollIndicators(.hidden)
        .onAppear { branchAnimated = true }
    }

    @State private var timelineAnimated: Bool = false

    private var timelinePage: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    Image(systemName: "calendar.circle.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(AppTheme.forestGreen)
                        .opacity(timelineAnimated ? 1 : 0)
                        .scaleEffect(timelineAnimated ? 1 : 0.6)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1), value: timelineAnimated)

                    Text("Where Are You?")
                        .font(.title2.bold())
                        .opacity(timelineAnimated ? 1 : 0)
                        .animation(.spring(response: 0.5).delay(0.2), value: timelineAnimated)

                    Text("How far are you from separation or retirement?")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .opacity(timelineAnimated ? 1 : 0)
                        .animation(.spring(response: 0.5).delay(0.3), value: timelineAnimated)
                }
                .padding(.top, 24)

                VStack(spacing: 10) {
                    ForEach(Array(TransitionTimeline.allCases.enumerated()), id: \.element.id) { index, timeline in
                        Button {
                            selectedTimeline = timeline
                        } label: {
                            HStack(spacing: 14) {
                                Image(systemName: timeline.icon)
                                    .font(.title3)
                                    .frame(width: 36)
                                Text(timeline.rawValue)
                                    .font(.body.weight(.bold))
                                Spacer()
                                if selectedTimeline == timeline {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(AppTheme.forestGreen)
                                }
                            }
                            .padding(16)
                            .background(selectedTimeline == timeline ? AppTheme.forestGreen.opacity(0.12) : Color(.secondarySystemGroupedBackground))
                            .foregroundStyle(selectedTimeline == timeline ? AppTheme.forestGreen : .primary)
                            .clipShape(.rect(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(selectedTimeline == timeline ? AppTheme.forestGreen : .clear, lineWidth: 2)
                            )
                        }
                        .sensoryFeedback(.selection, trigger: selectedTimeline)
                        .opacity(timelineAnimated ? 1 : 0)
                        .offset(y: timelineAnimated ? 0 : 16)
                        .animation(.spring(response: 0.5).delay(0.3 + Double(index) * 0.06), value: timelineAnimated)
                    }
                }

                if selectedTimeline != nil && selectedTimeline != .separated {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Estimated Separation Date")
                            .font(.subheadline.weight(.bold))
                        DatePicker("", selection: $separationDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                    }
                    .padding(16)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(.rect(cornerRadius: 12))
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
            .padding(.horizontal, 24)
        }
        .scrollIndicators(.hidden)
        .onAppear { timelineAnimated = true }
    }

    @State private var goalsAnimated: Bool = false

    private var goalsPage: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    Image(systemName: "target")
                        .font(.system(size: 40))
                        .foregroundStyle(AppTheme.forestGreen)
                        .opacity(goalsAnimated ? 1 : 0)
                        .scaleEffect(goalsAnimated ? 1 : 0.6)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1), value: goalsAnimated)

                    Text("Your Goals")
                        .font(.title2.bold())
                        .opacity(goalsAnimated ? 1 : 0)
                        .animation(.spring(response: 0.5).delay(0.2), value: goalsAnimated)

                    Text("What matters most to you right now?\nSelect all that apply.")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .opacity(goalsAnimated ? 1 : 0)
                        .animation(.spring(response: 0.5).delay(0.3), value: goalsAnimated)
                }
                .padding(.top, 24)

                LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                    ForEach(Array(TransitionGoal.allCases.enumerated()), id: \.element.id) { index, goal in
                        Button {
                            if selectedGoals.contains(goal) {
                                selectedGoals.remove(goal)
                            } else {
                                selectedGoals.insert(goal)
                            }
                        } label: {
                            VStack(spacing: 8) {
                                Image(systemName: goal.icon)
                                    .font(.title3)
                                Text(goal.rawValue)
                                    .font(.caption.weight(.bold))
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .padding(.horizontal, 8)
                            .background(selectedGoals.contains(goal) ? AppTheme.forestGreen.opacity(0.12) : Color(.secondarySystemGroupedBackground))
                            .foregroundStyle(selectedGoals.contains(goal) ? AppTheme.forestGreen : .primary)
                            .clipShape(.rect(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(selectedGoals.contains(goal) ? AppTheme.forestGreen : .clear, lineWidth: 2)
                            )
                        }
                        .opacity(goalsAnimated ? 1 : 0)
                        .offset(y: goalsAnimated ? 0 : 16)
                        .animation(.spring(response: 0.5).delay(0.3 + Double(index) * 0.04), value: goalsAnimated)
                    }
                }

                if !selectedGoals.isEmpty {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(AppTheme.forestGreen)
                        Text("\(selectedGoals.count) goal\(selectedGoals.count == 1 ? "" : "s") selected")
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(AppTheme.forestGreen)
                    }
                    .transition(.opacity.combined(with: .scale))
                }
            }
            .padding(.horizontal, 24)
        }
        .scrollIndicators(.hidden)
        .onAppear { goalsAnimated = true }
    }

    private var disclaimerPage: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Image(systemName: "checkmark.shield.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(AppTheme.forestGreen)
                    Text("Before We Begin")
                        .font(.title2.bold())
                }
                .padding(.top, 24)

                NonAffiliationBanner()

                VStack(alignment: .leading, spacing: 12) {
                    Label("Important Notices", systemImage: "exclamationmark.triangle.fill")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.orange)

                    Group {
                        Text("• This app is a planning and organization tool only.")
                        Text("• This app does not provide legal, medical, financial, or career advice.")
                        Text("• Always verify eligibility, deadlines, and benefit details through official government sources.")
                        Text("• Information in this app is based on publicly available resources and may change.")
                        Text("• This app is not an emergency service. For crisis support, call 988.")
                    }
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary.opacity(0.8))
                }
                .padding(16)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(.rect(cornerRadius: 14))

                Button {
                    disclaimerAccepted.toggle()
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: disclaimerAccepted ? "checkmark.square.fill" : "square")
                            .font(.title3)
                            .foregroundStyle(disclaimerAccepted ? AppTheme.forestGreen : .primary.opacity(0.5))
                        Text("I understand and accept these terms")
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(.primary)
                        Spacer()
                    }
                    .padding(16)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(.rect(cornerRadius: 12))
                }
            }
            .padding(.horizontal, 24)
        }
        .scrollIndicators(.hidden)
    }

    private var canAdvance: Bool {
        switch currentPage {
        case 0: true
        case 1: selectedBranch != nil
        case 2: selectedTimeline != nil
        case 3: !selectedGoals.isEmpty
        case 4: disclaimerAccepted
        default: false
        }
    }

    private var bottomBar: some View {
        HStack {
            if currentPage > 1 {
                Button("Back") {
                    withAnimation { currentPage -= 1 }
                }
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.primary.opacity(0.7))
            }
            Spacer()
            Button {
                if currentPage < totalPages - 1 {
                    withAnimation { currentPage += 1 }
                } else {
                    completeOnboarding()
                }
            } label: {
                Text(currentPage == totalPages - 1 ? "Get Started" : "Continue")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 14)
                    .background(canAdvance ? AppTheme.forestGreen : AppTheme.forestGreen.opacity(0.4))
                    .clipShape(Capsule())
            }
            .disabled(!canAdvance)
            .sensoryFeedback(.impact(weight: .medium), trigger: currentPage)
        }
    }

    private func completeOnboarding() {
        storage.profile.branch = selectedBranch
        storage.profile.timeline = selectedTimeline
        storage.profile.separationDate = selectedTimeline == .separated ? nil : separationDate
        storage.profile.goals = Array(selectedGoals)
        storage.profile.hasAcceptedDisclaimer = true
        storage.profile.hasCompletedOnboarding = true
    }

    private func skipOnboarding() {
        storage.profile.hasAcceptedDisclaimer = true
        storage.profile.hasCompletedOnboarding = true
    }
}

struct FeatureIcon: View {
    let icon: String
    let label: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2.weight(.semibold))
                .foregroundStyle(AppTheme.gold)
                .frame(width: 52, height: 52)
                .background(.white.opacity(0.1))
                .clipShape(Circle())
            Text(label)
                .font(.caption.weight(.bold))
                .foregroundStyle(.white.opacity(0.9))
        }
    }
}
