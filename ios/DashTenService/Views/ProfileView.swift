import SwiftUI

struct ProfileView: View {
    @Bindable var storage: StorageService
    @State private var showAbout: Bool = false
    @State private var showTransparency: Bool = false
    @State private var showTerms: Bool = false
    @State private var showPrivacy: Bool = false
    @State private var showEULA: Bool = false
    @State private var showAccessibility: Bool = false
    @State private var showDisclaimer: Bool = false
    @State private var showResetAlert: Bool = false
    @State private var showOnboarding: Bool = false

    private var readiness: ReadinessCalculator.ReadinessScore {
        ReadinessCalculator.calculate(checklist: storage.checklistItems, documents: storage.documents, benefits: storage.benefitCategories)
    }

    var body: some View {
        NavigationStack {
            List {
                profileHeader
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)

                Section {
                    NavigationLink(value: PlanningRoute.achievementBadges) {
                        HStack(spacing: 14) {
                            ProgressRing(progress: storage.transitionLevel.progressToNextLevel, size: 44, lineWidth: 4, color: AppTheme.gold)
                                .overlay {
                                    Text("Lv\(storage.transitionLevel.level)")
                                        .font(.system(size: 9, weight: .heavy))
                                        .foregroundStyle(AppTheme.gold)
                                }

                            VStack(alignment: .leading, spacing: 4) {
                                Text(storage.transitionLevel.levelTitle)
                                    .font(.subheadline.weight(.bold))
                                HStack(spacing: 10) {
                                    Text("\(storage.transitionLevel.totalXPEarned) XP")
                                        .font(.caption.weight(.bold))
                                        .foregroundStyle(AppTheme.gold)
                                    Text("\(storage.badges.filter(\.isUnlocked).count)/\(storage.badges.count) badges")
                                        .font(.caption.weight(.bold))
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                } header: {
                    Text("Level & Achievements")
                }

                Section("Goals") {
                    if storage.profile.goals.isEmpty {
                        Text("No goals selected")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.primary.opacity(0.6))
                    } else {
                        ForEach(storage.profile.goals) { goal in
                            Label(goal.rawValue, systemImage: goal.icon)
                                .font(.subheadline.weight(.semibold))
                        }
                    }
                }

                Section("Personal Info") {
                    TextField("Display Name", text: $storage.profile.displayName)
                        .font(.body.weight(.semibold))

                    if storage.profile.separationDate != nil {
                        DatePicker("Separation Date", selection: Binding(
                            get: { storage.profile.separationDate ?? Date() },
                            set: { storage.profile.separationDate = $0 }
                        ), displayedComponents: .date)
                        .font(.body.weight(.semibold))
                    }

                    Stepper("Household Size: \(storage.profile.householdSize)", value: $storage.profile.householdSize, in: 1...20)
                        .font(.body.weight(.semibold))

                    TextField("Spouse Name", text: $storage.profile.spouseName)
                        .font(.body.weight(.semibold))
                }

                Section("Notifications") {
                    Toggle("Weekly Check-In Reminder", isOn: Binding(
                        get: { storage.profile.notificationsEnabled },
                        set: { newValue in
                            Task {
                                if newValue {
                                    let granted = await NotificationService.shared.requestPermission()
                                    storage.profile.notificationsEnabled = granted
                                    if granted {
                                        NotificationService.shared.scheduleWeeklyReminder()
                                        if let sepDate = storage.profile.separationDate {
                                            NotificationService.shared.scheduleSeparationCountdown(separationDate: sepDate)
                                        }
                                    }
                                } else {
                                    storage.profile.notificationsEnabled = false
                                    NotificationService.shared.cancelAllNotifications()
                                }
                            }
                        }
                    ))
                    .font(.body.weight(.semibold))
                    .tint(AppTheme.forestGreen)

                    if storage.profile.notificationsEnabled {
                        Label("You'll get weekly check-ins and separation countdown alerts", systemImage: "bell.badge.fill")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.primary.opacity(0.7))
                    }
                }

                Section("App") {
                    Button {
                        showAbout = true
                    } label: {
                        Label("About DashTen", systemImage: "info.circle")
                            .font(.body.weight(.semibold))
                    }

                    Button {
                        showTransparency = true
                    } label: {
                        Label("Source Transparency", systemImage: "doc.text.magnifyingglass")
                            .font(.body.weight(.semibold))
                    }

                    NavigationLink {
                        CrisisResourcesView()
                    } label: {
                        Label("Crisis Resources", systemImage: "heart.fill")
                            .font(.body.weight(.semibold))
                            .foregroundStyle(.red)
                    }
                }

                Section("Legal") {
                    Button {
                        showTerms = true
                    } label: {
                        Label("Terms of Use", systemImage: "doc.plaintext")
                            .font(.body.weight(.semibold))
                    }

                    Button {
                        showPrivacy = true
                    } label: {
                        Label("Privacy Policy", systemImage: "lock.shield")
                            .font(.body.weight(.semibold))
                    }

                    Button {
                        showEULA = true
                    } label: {
                        Label("Apple EULA", systemImage: "doc.text")
                            .font(.body.weight(.semibold))
                    }

                    Button {
                        showAccessibility = true
                    } label: {
                        Label("Accessibility", systemImage: "accessibility")
                            .font(.body.weight(.semibold))
                    }

                    Button {
                        showDisclaimer = true
                    } label: {
                        Label("Disclaimer & Risks", systemImage: "exclamationmark.triangle")
                            .font(.body.weight(.semibold))
                    }
                }

                Section {
                    NonAffiliationBanner()
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                }

                Section {
                    Button {
                        showOnboarding = true
                    } label: {
                        Label("Retake Setup", systemImage: "arrow.counterclockwise.circle.fill")
                            .font(.body.weight(.semibold))
                    }

                    Button("Reset All Data", role: .destructive) {
                        showResetAlert = true
                    }
                    .font(.body.weight(.bold))
                }

                Section {} footer: {
                    VStack(spacing: 4) {
                        Text("DashTen v1.0.0")
                            .font(.caption.weight(.bold))
                        Text("Built independently for the transition community")
                            .font(.caption.weight(.semibold))
                    }
                    .foregroundStyle(.primary.opacity(0.5))
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Profile")
            .navigationDestination(for: PlanningRoute.self) { route in
                profileRouteDestination(route)
            }
            .sheet(isPresented: $showAbout) {
                AboutView()
            }
            .sheet(isPresented: $showTransparency) {
                SourceTransparencyView()
            }
            .sheet(isPresented: $showTerms) {
                TermsOfUseView()
            }
            .sheet(isPresented: $showPrivacy) {
                PrivacyPolicyView()
            }
            .sheet(isPresented: $showEULA) {
                EULAView()
            }
            .sheet(isPresented: $showAccessibility) {
                AccessibilityStatementView()
            }
            .sheet(isPresented: $showDisclaimer) {
                DisclaimerRisksView()
            }
            .fullScreenCover(isPresented: $showOnboarding) {
                OnboardingView(storage: storage)
            }
            .alert("Reset All Data?", isPresented: $showResetAlert) {
                Button("Reset", role: .destructive) {
                    storage.resetOnboarding()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will erase all your progress, documents, and settings. This cannot be undone.")
            }
        }
    }

    @ViewBuilder
    private func profileRouteDestination(_ route: PlanningRoute) -> some View {
        switch route {
        case .achievementBadges: AchievementBadgesView(storage: storage)
        default: EmptyView()
        }
    }

    private var profileHeader: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(AppTheme.forestGreen.opacity(0.12))
                        .frame(width: 64, height: 64)
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 36))
                        .foregroundStyle(AppTheme.forestGreen)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(storage.profile.displayName.isEmpty ? "Service Member" : storage.profile.displayName)
                        .font(.title3.bold())
                    if let branch = storage.profile.branch {
                        Text(branch.rawValue)
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.primary.opacity(0.7))
                    }
                    if let date = storage.profile.separationDate {
                        let days = Calendar.current.dateComponents([.day], from: Date(), to: date).day ?? 0
                        Text(days > 0 ? "\(days) days until separation" : "\(abs(days)) days since separation")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(.primary.opacity(0.6))
                    }
                }

                Spacer()
            }

            HStack(spacing: 12) {
                MiniReadinessCard(
                    title: "Readiness",
                    value: "\(readiness.overallPercent)%",
                    color: AppTheme.forestGreen
                )
                MiniReadinessCard(
                    title: "Tasks Done",
                    value: "\(storage.checklistItems.filter(\.isCompleted).count)/\(storage.checklistItems.count)",
                    color: .blue
                )
                MiniReadinessCard(
                    title: "Docs Verified",
                    value: "\(storage.documents.filter { $0.status == .verified }.count)/\(storage.documents.count)",
                    color: .orange
                )
            }
        }
        .padding(16)
    }
}

struct MiniReadinessCard: View {
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline.weight(.bold))
                .foregroundStyle(color)
            Text(title)
                .font(.caption2.weight(.bold))
                .foregroundStyle(.primary.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(color.opacity(0.08))
        .clipShape(.rect(cornerRadius: 10))
    }
}

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(spacing: 12) {
                        Image(systemName: "arrow.up.forward.circle.fill")
                            .font(.system(size: 56))
                            .foregroundStyle(AppTheme.forestGreen)
                        Text("DashTen")
                            .font(.largeTitle.bold())
                        Text("Your transition, organized.")
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(.primary.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Why This App Exists")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(AppTheme.forestGreen)

                        Text("I built this app because I wasn't as prepared as I should have been when I separated from the military. The transition was overwhelming — too many decisions, too many deadlines, and not enough clarity on what mattered most.")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.primary.opacity(0.8))

                        Text("DashTen is the tool I wish I had. A single place to organize your plan, understand your benefits, track your documents, and stay on top of what matters — on your timeline.")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.primary.opacity(0.8))

                        Text("This app is for every service member, veteran, and military family navigating the transition to civilian life. You've earned the preparation.")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.primary.opacity(0.8))
                    }
                    .padding(16)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(.rect(cornerRadius: 14))

                    NonAffiliationBanner()
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(.body.weight(.bold))
                }
            }
        }
    }
}

struct SourceTransparencyView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 12) {
                        Label("How We Source Information", systemImage: "doc.text.magnifyingglass")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(AppTheme.forestGreen)

                        Group {
                            Text("DashTen summarizes publicly available information about military transition, veteran benefits, and post-service planning.")
                            Text("All content in this app is based on publicly accessible resources from official websites, publicly available guides, and common transition knowledge.")
                            Text("This app does not claim to have insider, proprietary, or classified information. All information should be verified with official sources before making decisions.")
                        }
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.primary.opacity(0.8))
                    }
                    .padding(16)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(.rect(cornerRadius: 14))

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Important Reminders")
                            .font(.headline.weight(.bold))

                        Group {
                            Label("Eligibility requirements can change. Always verify with official sources.", systemImage: "exclamationmark.triangle")
                            Label("Deadlines and timelines may vary by branch, location, and individual situation.", systemImage: "clock")
                            Label("Benefit details are summaries, not official determinations.", systemImage: "doc.text")
                            Label("External links go to official or established organization websites.", systemImage: "link")
                        }
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.primary.opacity(0.8))
                    }
                    .padding(16)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(.rect(cornerRadius: 14))

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Official Resources")
                            .font(.headline.weight(.bold))
                        OfficialLinkButton(title: "Benefits.gov", url: "https://www.benefits.gov/")
                        OfficialLinkButton(title: "National Archives (Records)", url: "https://www.archives.gov/veterans")
                        OfficialLinkButton(title: "USAJobs.gov (Federal Jobs)", url: "https://www.usajobs.gov/")
                    }

                    NonAffiliationBanner()
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Source Transparency")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(.body.weight(.bold))
                }
            }
        }
    }
}

struct TermsOfUseView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Terms of Use")
                            .font(.title3.bold())

                        Text("By using DashTen, you acknowledge and agree to the following:")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.primary.opacity(0.8))

                        Group {
                            Text("1. DashTen is an informational and organizational tool designed to help users plan their transition from military to civilian life.")
                            Text("2. You accept full responsibility for verifying all information with official sources before making any decisions based on content in this app.")
                            Text("3. The app creator is not liable for any decisions made, actions taken, or outcomes resulting from information presented in this app.")
                            Text("4. This app does not provide legal, medical, financial, career counseling, or claims assistance of any kind.")
                            Text("5. You agree not to rely solely on this app for transition planning and will consult qualified professionals and official agencies as needed.")
                            Text("6. All data is stored locally on your device. You are responsible for backing up your own data.")
                            Text("7. The app creator reserves the right to update these terms at any time.")
                        }
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.primary.opacity(0.8))
                    }
                    .padding(16)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(.rect(cornerRadius: 14))
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Terms of Use")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(.body.weight(.bold))
                }
            }
        }
    }
}

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Privacy Policy")
                            .font(.title3.bold())

                        Group {
                            Text("DashTen stores all data locally on your device. No personal information is transmitted to external servers.")
                            Text("Your transition plan, documents checklist, and progress are private and under your complete control.")
                            Text("We do not collect, store, or share any personally identifiable information.")
                            Text("No analytics, tracking, or advertising SDKs are included in this app.")
                            Text("If you delete the app, all local data is permanently removed from your device.")
                            Text("External links in the app will open in your browser. Those websites have their own privacy policies.")
                        }
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.primary.opacity(0.8))
                    }
                    .padding(16)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(.rect(cornerRadius: 14))

                    NonAffiliationBanner()
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Privacy Policy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(.body.weight(.bold))
                }
            }
        }
    }
}

struct EULAView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("End User License Agreement")
                            .font(.title3.bold())

                        Group {
                            Text("This application is licensed, not sold, to you under the terms of Apple's Standard End User License Agreement (EULA).")
                            Text("By downloading, installing, or using DashTen, you agree to Apple's Licensed Application End User License Agreement, available at:")
                        }
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.primary.opacity(0.8))

                        OfficialLinkButton(title: "Apple Standard EULA", url: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")

                        Group {
                            Text("The licensor of DashTen is the app developer, not Apple Inc. Apple has no obligation to furnish maintenance and support services for this app.")
                            Text("In the event of any failure of DashTen to conform to any applicable warranty, you may notify Apple for a refund of the purchase price (if any). Apple has no other warranty obligation.")
                            Text("Any claims relating to DashTen, including product liability claims, are the responsibility of the app developer, not Apple.")
                        }
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.primary.opacity(0.8))
                    }
                    .padding(16)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(.rect(cornerRadius: 14))
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Apple EULA")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(.body.weight(.bold))
                }
            }
        }
    }
}

struct AccessibilityStatementView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Accessibility")
                            .font(.title3.bold())

                        Text("DashTen is committed to being accessible to all users. We strive to follow Apple's accessibility guidelines and support the following features:")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.primary.opacity(0.8))

                        Group {
                            Label("Dynamic Type — text scales with your system font size settings", systemImage: "textformat.size")
                            Label("VoiceOver — all interactive elements include descriptive labels", systemImage: "speaker.wave.2.fill")
                            Label("Color Contrast — designed to meet accessibility contrast standards", systemImage: "circle.lefthalf.filled")
                            Label("Reduced Motion — respects system reduced motion preferences", systemImage: "figure.walk")
                            Label("Touch Targets — all buttons meet the minimum 44×44pt touch target", systemImage: "hand.tap.fill")
                        }
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.primary.opacity(0.8))

                        Text("If you experience any accessibility issues, please contact us through the App Store.")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.primary.opacity(0.6))
                    }
                    .padding(16)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(.rect(cornerRadius: 14))
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Accessibility")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(.body.weight(.bold))
                }
            }
        }
    }
}

struct DisclaimerRisksView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Disclaimer", systemImage: "exclamationmark.triangle.fill")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.orange)

                        Group {
                            Text("DashTen is a planning and organization tool only. It does not provide legal, medical, financial, or career advice of any kind.")
                            Text("Users should consult qualified professionals and official agencies for specific guidance about benefits, eligibility, claims, and any other matters discussed in this app.")
                        }
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.primary.opacity(0.8))
                    }
                    .padding(16)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(.rect(cornerRadius: 14))

                    VStack(alignment: .leading, spacing: 12) {
                        Label("Risk Acknowledgment", systemImage: "shield.lefthalf.filled")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.red)

                        Group {
                            Text("Transition planning involves complex decisions with significant consequences.")
                            Text("DashTen helps organize your approach but cannot replace official counseling, legal review, or professional guidance.")
                            Text("Eligibility requirements, deadlines, and benefit details can change at any time. Always verify with official sources.")
                            Text("The app creator assumes no liability for any actions taken or decisions made based on information in this app.")
                        }
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.primary.opacity(0.8))
                    }
                    .padding(16)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(.rect(cornerRadius: 14))

                    VStack(alignment: .leading, spacing: 12) {
                        Label("Crisis Support", systemImage: "heart.fill")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.red)

                        Text("If you are experiencing a crisis, please contact the 988 Suicide & Crisis Lifeline by calling or texting 988. This app is not an emergency service.")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.primary.opacity(0.8))
                    }
                    .padding(16)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(.rect(cornerRadius: 14))

                    NonAffiliationBanner()
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Disclaimer & Risks")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(.body.weight(.bold))
                }
            }
        }
    }
}
