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
            HStack {
                Spacer()
                Button("Skip") {
                    skipOnboarding()
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
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

            TabView(selection: $currentPage) {
                welcomePage.tag(0)
                branchPage.tag(1)
                timelinePage.tag(2)
                goalsPage.tag(3)
                disclaimerPage.tag(4)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.spring(response: 0.4), value: currentPage)

            bottomBar
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
        }
        .background(Color(.systemGroupedBackground))
    }

    @State private var welcomeAnimated: Bool = false

    private var welcomePage: some View {
        ZStack {
            AppTheme.accentGradient
                .ignoresSafeArea()

            MeshGradient(
                width: 3, height: 3,
                points: [
                    [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                    [0.0, 0.5], [0.6, 0.4], [1.0, 0.5],
                    [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
                ],
                colors: [
                    AppTheme.darkGreen, AppTheme.forestGreen, AppTheme.darkGreen,
                    AppTheme.forestGreen, AppTheme.gold.opacity(0.3), AppTheme.darkGreen,
                    AppTheme.darkGreen, AppTheme.forestGreen, AppTheme.darkGreen
                ]
            )
            .ignoresSafeArea()
            .opacity(0.9)

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 28) {
                    Image(systemName: "arrow.up.forward.circle.fill")
                        .font(.system(size: 80, weight: .thin))
                        .foregroundStyle(.white.opacity(0.95))
                        .shadow(color: .black.opacity(0.3), radius: 20, y: 10)
                        .scaleEffect(welcomeAnimated ? 1.0 : 0.5)
                        .opacity(welcomeAnimated ? 1 : 0)
                        .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2), value: welcomeAnimated)

                    VStack(spacing: 14) {
                        Text("DashTen")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundStyle(.white)
                            .opacity(welcomeAnimated ? 1 : 0)
                            .offset(y: welcomeAnimated ? 0 : 20)
                            .animation(.spring(response: 0.7, dampingFraction: 0.8).delay(0.5), value: welcomeAnimated)

                        Text("Your next chapter starts here.")
                            .font(.title3.weight(.medium))
                            .foregroundStyle(.white.opacity(0.8))
                            .opacity(welcomeAnimated ? 1 : 0)
                            .offset(y: welcomeAnimated ? 0 : 12)
                            .animation(.spring(response: 0.7, dampingFraction: 0.8).delay(0.7), value: welcomeAnimated)
                    }
                }

                Spacer()

                VStack(spacing: 20) {
                    HStack(spacing: 16) {
                        WelcomeFeaturePill(icon: "map.fill", text: "Plan")
                        WelcomeFeaturePill(icon: "checkmark.circle.fill", text: "Track")
                        WelcomeFeaturePill(icon: "bolt.fill", text: "Act")
                    }
                    .opacity(welcomeAnimated ? 1 : 0)
                    .offset(y: welcomeAnimated ? 0 : 20)
                    .animation(.spring(response: 0.7, dampingFraction: 0.8).delay(1.0), value: welcomeAnimated)

                    Text("Organize your transition. Understand your benefits.\nStay ahead of every deadline.")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .opacity(welcomeAnimated ? 1 : 0)
                        .animation(.spring(response: 0.7).delay(1.2), value: welcomeAnimated)
                }
                .padding(.bottom, 48)
            }
            .padding(.horizontal, 24)
        }
        .onAppear {
            welcomeAnimated = true
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
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
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
                                    .font(.subheadline.weight(.medium))
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
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
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
                                    .font(.body.weight(.medium))
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
                            .font(.subheadline.weight(.medium))
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
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
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
                                    .font(.caption.weight(.medium))
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
                            .font(.subheadline.weight(.medium))
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
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.orange)

                    Group {
                        Text("• This app is a planning and organization tool only.")
                        Text("• This app does not provide legal, medical, financial, or career advice.")
                        Text("• Always verify eligibility, deadlines, and benefit details through official government sources.")
                        Text("• Information in this app is based on publicly available resources and may change.")
                        Text("• This app is not an emergency service. For crisis support, call 988.")
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
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
                            .foregroundStyle(disclaimerAccepted ? AppTheme.forestGreen : .secondary)
                        Text("I understand and accept these terms")
                            .font(.subheadline)
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
            if currentPage > 0 {
                Button("Back") {
                    withAnimation { currentPage -= 1 }
                }
                .foregroundStyle(.secondary)
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
                    .font(.headline)
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
