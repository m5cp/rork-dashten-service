import SwiftUI
import StoreKit
import RevenueCat

struct ProfileView: View {
    @Bindable var storage: StorageService
    var store: StoreViewModel
    @State private var showAbout: Bool = false
    @State private var showPaywall: Bool = false
    @State private var showRedeemCode: Bool = false
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

                Section {
                    ForEach(TransitionGoal.allCases) { goal in
                        Button {
                            if storage.profile.goals.contains(goal) {
                                storage.profile.goals.removeAll { $0 == goal }
                            } else {
                                storage.profile.goals.append(goal)
                            }
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: goal.icon)
                                    .font(.subheadline)
                                    .foregroundStyle(storage.profile.goals.contains(goal) ? AppTheme.forestGreen : .secondary)
                                    .frame(width: 24)
                                Text(goal.rawValue)
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(.primary)
                                Spacer()
                                if storage.profile.goals.contains(goal) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(AppTheme.forestGreen)
                                }
                            }
                        }
                    }
                } header: {
                    Text("Goals")
                } footer: {
                    Text("Select all that apply to your transition")
                }

                Section("Service Info") {
                    Picker("Branch", selection: $storage.profile.branch) {
                        Text("Select Branch").tag(MilitaryBranch?.none)
                        ForEach(MilitaryBranch.allCases) { branch in
                            Label(branch.rawValue, systemImage: branch.icon).tag(MilitaryBranch?.some(branch))
                        }
                    }
                    .font(.body.weight(.semibold))

                    Picker("Status", selection: Binding(
                        get: { storage.profile.timeline },
                        set: { newValue in
                            storage.profile.timeline = newValue
                            if newValue == .separated {
                                storage.profile.separationDate = nil
                            }
                        }
                    )) {
                        Text("Select Status").tag(TransitionTimeline?.none)
                        ForEach(TransitionTimeline.allCases) { timeline in
                            Text(timeline.rawValue).tag(TransitionTimeline?.some(timeline))
                        }
                    }
                    .font(.body.weight(.semibold))

                    if storage.profile.timeline != nil && storage.profile.timeline != .separated {
                        SeparationDateRow(date: Binding(
                            get: { storage.profile.separationDate ?? Date() },
                            set: { storage.profile.separationDate = $0 }
                        ))
                    }
                }

                Section("Personal Info") {
                    TextField("Display Name", text: $storage.profile.displayName)
                        .font(.body.weight(.semibold))

                    Stepper("Household Size: \(storage.profile.householdSize)", value: $storage.profile.householdSize, in: 1...20)
                        .font(.body.weight(.semibold))

                    TextField("Spouse Name", text: $storage.profile.spouseName)
                        .font(.body.weight(.semibold))
                }

                Section("Notifications") {
                    Toggle("Reminders & milestones", isOn: Binding(
                        get: { storage.profile.notificationsEnabled },
                        set: { newValue in
                            Task {
                                if newValue {
                                    let granted = await NotificationService.shared.requestPermission()
                                    storage.profile.notificationsEnabled = granted
                                    if granted {
                                        NotificationService.shared.scheduleWeeklyReminder()
                                        NotificationService.shared.scheduleMilestoneReminders(accountCreated: storage.profile.createdAt)
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
                        Label("Weekly check-ins, 7/30/90-day milestones, and phase deadlines", systemImage: "bell.badge.fill")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.primary.opacity(0.7))
                    }

                    Toggle("Lock Screen countdown", isOn: Binding(
                        get: { LiveActivityService.shared.isActive },
                        set: { newValue in
                            if newValue {
                                if let sepDate = storage.profile.separationDate {
                                    let focus = storage.checklistItems.first(where: { !$0.isCompleted })?.title ?? "All caught up"
                                    let days = Calendar.current.dateComponents([.day], from: Date(), to: sepDate).day ?? 0
                                    let phase: String = {
                                        if days > 540 { return "18+ mo" }
                                        if days > 365 { return "12 mo" }
                                        if days > 180 { return "6 mo" }
                                        if days > 90 { return "90 days" }
                                        if days > 30 { return "30 days" }
                                        if days > 0 { return "This week" }
                                        return "Post-service"
                                    }()
                                    LiveActivityService.shared.start(
                                        separationDate: sepDate,
                                        branch: storage.profile.branch?.rawValue ?? "",
                                        focusTitle: focus,
                                        phaseLabel: phase
                                    )
                                }
                            } else {
                                LiveActivityService.shared.end()
                            }
                        }
                    ))
                    .font(.body.weight(.semibold))
                    .tint(AppTheme.forestGreen)
                    .disabled(storage.profile.separationDate == nil || !LiveActivityService.shared.isSupported)

                    if storage.profile.separationDate == nil {
                        Label("Set a separation date to enable", systemImage: "info.circle")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                    }
                }

                Section {
                    Button {
                        showPaywall = true
                    } label: {
                        HStack(spacing: 14) {
                            Image(systemName: store.isPremium ? "checkmark.seal.fill" : "arrow.up.forward.circle.fill")
                                .font(.title3.weight(.semibold))
                                .foregroundStyle(store.isPremium ? AppTheme.forestGreen : AppTheme.gold)
                                .frame(width: 40, height: 40)
                                .background((store.isPremium ? AppTheme.forestGreen : AppTheme.gold).opacity(0.12))
                                .clipShape(.rect(cornerRadius: 10))

                            VStack(alignment: .leading, spacing: 3) {
                                Text(store.isPremium ? "DashTen Pro" : "Upgrade to Pro")
                                    .font(.subheadline.weight(.bold))
                                Text(store.isPremium ? "All Pro features unlocked" : proUpsellSubtitle)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            if !store.isPremium {
                                Image(systemName: "chevron.right")
                                    .font(.caption.weight(.bold))
                                    .foregroundStyle(.tertiary)
                            }
                        }
                    }

                    Button {
                        Task { await store.restore() }
                    } label: {
                        Label("Restore Purchases", systemImage: "arrow.clockwise")
                            .font(.body.weight(.semibold))
                    }
                    .accessibilityLabel("Restore previous purchases")

                    Button {
                        showRedeemCode = true
                    } label: {
                        Label("Redeem a Code", systemImage: "gift.fill")
                            .font(.body.weight(.semibold))
                    }
                    .accessibilityLabel("Redeem an offer code for a free or discounted subscription")
                } header: {
                    Text("Subscription")
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

                    Button(role: .destructive) {
                        showResetAlert = true
                    } label: {
                        Label("Delete All My Data", systemImage: "trash")
                            .font(.body.weight(.bold))
                    }
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
            .onReceive(NotificationCenter.default.publisher(for: .openProfileSetup)) { _ in
                showOnboarding = true
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView(store: store)
            }
            .offerCodeRedemption(isPresented: $showRedeemCode) { _ in
                Task { await store.checkStatus() }
            }
            .alert("Delete All My Data?", isPresented: $showResetAlert) {
                Button("Delete Everything", role: .destructive) {
                    storage.resetOnboarding()
                    showOnboarding = true
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This permanently erases your profile, roadmap, documents, journal, tool entries, streaks, and progress from this device. This cannot be undone. You'll be returned to setup.")
            }
        }
    }

    private var proUpsellSubtitle: String {
        if let price = store.offerings?.current?.availablePackages.first?.storeProduct.localizedPriceString {
            return "Unlock 11 tools & 2 guides — \(price) lifetime"
        }
        return "Unlock 11 tools & 2 guides — one-time purchase"
    }

    @ViewBuilder
    private func profileRouteDestination(_ route: PlanningRoute) -> some View {
        switch route {
        case .achievementBadges: AchievementBadgesView(storage: storage)
        case .firstYearGuide: FirstYearGuideView()
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
                VStack(alignment: .leading, spacing: 14) {
                    PolicyBlock(
                        icon: "doc.text.magnifyingglass",
                        accent: AppTheme.forestGreen,
                        title: "How We Source Information",
                        body: "DashTen summarizes publicly available information about military transition, veteran benefits, and post-service planning."
                    )
                    PolicyBlock(
                        icon: "globe",
                        accent: .blue,
                        title: "Public Sources Only",
                        body: "All content is based on publicly accessible resources from official websites, publicly available guides, and common transition knowledge."
                    )
                    PolicyBlock(
                        icon: "checkmark.shield.fill",
                        accent: .purple,
                        title: "No Insider Claims",
                        body: "This app does not claim to have insider, proprietary, or classified information. All information should be verified with official sources before making decisions."
                    )

                    Text("Important Reminders")
                        .font(.headline.weight(.bold))
                        .padding(.top, 6)

                    PolicyBlock(icon: "exclamationmark.triangle", accent: .orange, title: "Eligibility Changes", body: "Eligibility requirements can change. Always verify with official sources.")
                    PolicyBlock(icon: "clock", accent: .teal, title: "Timelines Vary", body: "Deadlines and timelines may vary by branch, location, and individual situation.")
                    PolicyBlock(icon: "doc.text", accent: .blue, title: "Summaries Only", body: "Benefit details are summaries, not official determinations.")
                    PolicyBlock(icon: "link", accent: AppTheme.forestGreen, title: "External Links", body: "External links go to official or established organization websites.")

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

    private let terms: [String] = [
        "DashTen is an informational and organizational tool designed to help users plan their transition from military to civilian life.",
        "You accept full responsibility for verifying all information with official sources before making any decisions based on content in this app.",
        "The app creator is not liable for any decisions made, actions taken, or outcomes resulting from information presented in this app.",
        "This app does not provide legal, medical, financial, career counseling, or claims assistance of any kind.",
        "You agree not to rely solely on this app for transition planning and will consult qualified professionals and official agencies as needed.",
        "All data is stored locally on your device. You are responsible for backing up your own data.",
        "The app creator reserves the right to update these terms at any time."
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    Text("By using DashTen, you acknowledge and agree to the following:")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary.opacity(0.8))
                        .padding(.bottom, 4)

                    ForEach(Array(terms.enumerated()), id: \.offset) { idx, text in
                        PolicyBlock(number: idx + 1, accent: AppTheme.forestGreen, body: text)
                    }
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

    private let items: [(icon: String, color: Color, title: String, body: String)] = [
        ("iphone", .blue, "Local-only storage", "DashTen stores all data locally on your device. No personal information is transmitted to external servers."),
        ("lock.shield.fill", AppTheme.forestGreen, "Private by design", "Your transition plan, documents checklist, and progress are private and under your complete control."),
        ("person.crop.circle.badge.xmark", .purple, "No PII collection", "We do not collect, store, or share any personally identifiable information."),
        ("chart.bar.xaxis", .orange, "No analytics or ads", "No analytics, tracking, or advertising SDKs are included in this app."),
        ("trash.fill", .red, "Delete = gone", "If you delete the app, all local data is permanently removed from your device."),
        ("link", .teal, "External links", "External links in the app will open in your browser. Those websites have their own privacy policies.")
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                        PolicyBlock(icon: item.icon, accent: item.color, title: item.title, body: item.body)
                    }

                    NonAffiliationBanner()
                        .padding(.top, 4)
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
                VStack(alignment: .leading, spacing: 14) {
                    PolicyBlock(
                        icon: "doc.text.fill",
                        accent: .blue,
                        title: "Licensed, not sold",
                        body: "This application is licensed, not sold, to you under the terms of Apple's Standard End User License Agreement (EULA). By downloading, installing, or using DashTen, you agree to Apple's Licensed Application End User License Agreement."
                    )

                    OfficialLinkButton(title: "Apple Standard EULA", url: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")

                    PolicyBlock(
                        icon: "building.2.fill",
                        accent: .purple,
                        title: "Licensor",
                        body: "The licensor of DashTen is the app developer, not Apple Inc. Apple has no obligation to furnish maintenance and support services for this app."
                    )

                    PolicyBlock(
                        icon: "arrow.uturn.backward.circle.fill",
                        accent: .orange,
                        title: "Refunds & warranty",
                        body: "In the event of any failure of DashTen to conform to any applicable warranty, you may notify Apple for a refund of the purchase price (if any). Apple has no other warranty obligation."
                    )

                    PolicyBlock(
                        icon: "exclamationmark.shield.fill",
                        accent: .red,
                        title: "Claims",
                        body: "Any claims relating to DashTen, including product liability claims, are the responsibility of the app developer, not Apple."
                    )
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

    private let items: [(icon: String, color: Color, title: String, body: String)] = [
        ("textformat.size", .blue, "Dynamic Type", "Text scales with your system font size settings."),
        ("speaker.wave.2.fill", .purple, "VoiceOver", "All interactive elements include descriptive labels."),
        ("circle.lefthalf.filled", .orange, "Color Contrast", "Designed to meet accessibility contrast standards."),
        ("figure.walk", .teal, "Reduced Motion", "Respects system reduced motion preferences."),
        ("hand.tap.fill", AppTheme.forestGreen, "Touch Targets", "All buttons meet the minimum 44×44pt touch target.")
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    Text("DashTen is committed to being accessible to all users. We strive to follow Apple's accessibility guidelines:")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary.opacity(0.8))
                        .padding(.bottom, 4)

                    ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                        PolicyBlock(icon: item.icon, accent: item.color, title: item.title, body: item.body)
                    }

                    Text("If you experience any accessibility issues, please contact us through the App Store.")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .padding(.top, 4)
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

struct SeparationDateRow: View {
    @Binding var date: Date
    @State private var showPicker: Bool = false

    private static let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f
    }()

    var body: some View {
        HStack {
            Text("Separation Date")
                .font(.body.weight(.semibold))
            Spacer()
            Button {
                showPicker = true
            } label: {
                Text(Self.formatter.string(from: date))
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(AppTheme.forestGreen)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(AppTheme.forestGreen.opacity(0.1))
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
        .sheet(isPresented: $showPicker) {
            NavigationStack {
                DatePicker(
                    "Separation Date",
                    selection: $date,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .padding()
                .navigationTitle("Separation Date")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") { showPicker = false }
                            .font(.body.weight(.bold))
                    }
                }
            }
            .presentationDetents([.medium, .large])
        }
    }
}

struct PolicyBlock: View {
    let number: Int?
    let icon: String?
    let accent: Color
    let title: String?
    let text: String

    init(number: Int? = nil, icon: String? = nil, accent: Color = AppTheme.forestGreen, title: String? = nil, body: String) {
        self.number = number
        self.icon = icon
        self.accent = accent
        self.title = title
        self.text = body
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Group {
                if let number {
                    Text("\(number)")
                        .font(.subheadline.weight(.heavy))
                        .foregroundStyle(accent)
                        .frame(width: 30, height: 30)
                        .background(accent.opacity(0.12))
                        .clipShape(.rect(cornerRadius: 8))
                } else if let icon {
                    Image(systemName: icon)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(accent)
                        .frame(width: 30, height: 30)
                        .background(accent.opacity(0.12))
                        .clipShape(.rect(cornerRadius: 8))
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                if let title {
                    Text(title)
                        .font(.subheadline.weight(.bold))
                }
                Text(text)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.primary.opacity(0.8))
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 14))
    }
}

struct DisclaimerRisksView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    PolicyBlock(
                        icon: "exclamationmark.triangle.fill",
                        accent: .orange,
                        title: "Disclaimer",
                        body: "DashTen is a planning and organization tool only. It does not provide legal, medical, financial, or career advice of any kind."
                    )
                    PolicyBlock(
                        icon: "checkmark.seal.fill",
                        accent: .blue,
                        title: "Consult Professionals",
                        body: "Users should consult qualified professionals and official agencies for specific guidance about benefits, eligibility, claims, and any other matters discussed in this app."
                    )
                    PolicyBlock(
                        icon: "shield.lefthalf.filled",
                        accent: .red,
                        title: "Risk Acknowledgment",
                        body: "Transition planning involves complex decisions with significant consequences. DashTen helps organize your approach but cannot replace official counseling, legal review, or professional guidance."
                    )
                    PolicyBlock(
                        icon: "arrow.clockwise.circle.fill",
                        accent: .purple,
                        title: "Information Can Change",
                        body: "Eligibility requirements, deadlines, and benefit details can change at any time. Always verify with official sources. The app creator assumes no liability for any actions taken or decisions made based on information in this app."
                    )
                    PolicyBlock(
                        icon: "heart.fill",
                        accent: .red,
                        title: "Crisis Support",
                        body: "If you are experiencing a crisis, please contact the 988 Suicide & Crisis Lifeline by calling or texting 988. This app is not an emergency service."
                    )

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
