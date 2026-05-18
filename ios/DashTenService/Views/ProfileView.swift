import SwiftUI
import StoreKit
import RevenueCat

struct ProfileView: View {
    @Bindable var storage: StorageService
    var store: StoreViewModel
    @State private var showAbout: Bool = false
    @Environment(PaywallCenter.self) private var paywall
    @State private var showRedeemCode: Bool = false
    @State private var showTransparency: Bool = false
    @State private var showSources: Bool = false
    @State private var showNotificationsTune: Bool = false
    @State private var showTerms: Bool = false
    @State private var showPrivacy: Bool = false
    @State private var showEULA: Bool = false
    @State private var showAccessibility: Bool = false
    @State private var showDisclaimer: Bool = false
    @State private var showResetAlert: Bool = false
    @State private var showOnboarding: Bool = false
    @State private var showEditProfile: Bool = false

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
                    NavigationLink(value: ProfileRoute.wellness) {
                        HStack(spacing: 14) {
                            Image(systemName: "heart.text.square.fill")
                                .font(.title3.weight(.bold))
                                .foregroundStyle(.pink)
                                .frame(width: 40, height: 40)
                                .background(Color.pink.opacity(0.12))
                                .clipShape(.rect(cornerRadius: 10))

                            VStack(alignment: .leading, spacing: 3) {
                                Text("Wellness")
                                    .font(.subheadline.weight(.bold))
                                Text(wellnessSubtitle)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                } header: {
                    Text("Wellness")
                }

                Section {
                    NavigationLink(value: PlanningRoute.achievementBadges) {
                        HStack(spacing: 14) {
                            ZStack {
                                Circle()
                                    .fill(AppTheme.gold.opacity(0.15))
                                    .frame(width: 44, height: 44)
                                Image(systemName: "rosette")
                                    .font(.title3.weight(.bold))
                                    .foregroundStyle(AppTheme.gold)
                            }

                            VStack(alignment: .leading, spacing: 3) {
                                Text("Badges")
                                    .font(.subheadline.weight(.bold))
                                Text("\(storage.badges.filter(\.isUnlocked).count) of \(storage.badges.count) earned · \(readiness.overallPercent)% ready")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                } header: {
                    Text("Achievements")
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

                    if storage.profile.timeline == .separated {
                        Picker("Post-Service Status", selection: Binding(
                            get: { storage.profile.postServiceStatus },
                            set: { newValue in
                                if let v = newValue {
                                    storage.applyPostServiceStatus(v)
                                } else {
                                    storage.profile.postServiceStatus = nil
                                }
                            }
                        )) {
                            Text("Select Status").tag(PostServiceStatus?.none)
                            ForEach(PostServiceStatus.allCases) { status in
                                Label(status.rawValue, systemImage: status.icon).tag(PostServiceStatus?.some(status))
                            }
                        }
                        .font(.body.weight(.semibold))
                    }
                }

                Section {
                    Stepper("Household Size: \(storage.profile.householdSize)", value: $storage.profile.householdSize, in: 1...20)
                        .font(.body.weight(.semibold))

                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Your Current VA Rating")
                                .font(.subheadline.weight(.bold))
                            Spacer()
                            Text(storage.profile.disabilityRating == 0 ? "None" : "\(storage.profile.disabilityRating)%")
                                .font(.subheadline.weight(.bold))
                                .foregroundStyle(AppTheme.forestGreen)
                        }
                        Slider(value: Binding(
                            get: { Double(storage.profile.disabilityRating) },
                            set: { storage.profile.disabilityRating = Int($0.rounded() / 10) * 10 }
                        ), in: 0...100, step: 10)
                        .tint(AppTheme.forestGreen)
                        Text("Enter your current VA-assigned combined rating. Ratings are determined by the VA — this is for personalizing your benefit information only.")
                            .font(.caption2.weight(.semibold))
                            .foregroundStyle(.secondary)
                    }
                    .padding(14)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(.rect(cornerRadius: 14))
                } header: {
                    Text("Household")
                } footer: {
                    Text("Used by budget and benefit calculators.")
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
                        paywall.present(source: "profile_upgrade_row")
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
                    Picker(selection: $storage.profile.themePreference) {
                        ForEach(ThemePreference.allCases) { theme in
                            Label(theme.label, systemImage: theme.icon).tag(theme)
                        }
                    } label: {
                        Label("Appearance", systemImage: "circle.lefthalf.filled")
                            .font(.body.weight(.semibold))
                    }
                    .pickerStyle(.menu)

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

                    Button {
                        showSources = true
                    } label: {
                        Label("Sources & References", systemImage: "books.vertical")
                            .font(.body.weight(.semibold))
                    }

                    Button {
                        showNotificationsTune = true
                    } label: {
                        Label("Tune notifications", systemImage: "bell.badge")
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
                        Label("Delete Account & All Data", systemImage: "trash")
                            .font(.body.weight(.bold))
                    }
                    .accessibilityLabel("Delete your account and erase all data stored on this device")
                }

                Section {} footer: {
                    VStack(spacing: 4) {
                        Text("DashTen \(Self.appVersionString)")
                            .font(.caption.weight(.bold))
                        Text("Built independently for the transition community")
                            .font(.caption.weight(.semibold))
                    }
                    .foregroundStyle(.primary.opacity(0.7))
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Profile")
            .navigationDestination(for: PlanningRoute.self) { route in
                profileRouteDestination(route)
            }
            .navigationDestination(for: ProfileRoute.self) { route in
                switch route {
                case .wellness: WellnessView(storage: storage)
                }
            }
            .sheet(isPresented: $showAbout) {
                AboutView()
            }
            .sheet(isPresented: $showTransparency) {
                SourceTransparencyView()
            }
            .sheet(isPresented: $showSources) {
                SourcesReferencesView()
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
            .sheet(isPresented: $showNotificationsTune) {
                NotificationPermissionView(storage: storage)
            }
            .sheet(isPresented: $showAccessibility) {
                AccessibilityStatementView()
            }
            .sheet(isPresented: $showDisclaimer) {
                DisclaimerRisksView()
            }
            .fullScreenCover(isPresented: $showOnboarding) {
                OnboardingView(storage: storage, store: store)
            }
            .onReceive(NotificationCenter.default.publisher(for: .openProfileSetup)) { _ in
                showOnboarding = true
            }
            .sheet(isPresented: $showEditProfile) {
                EditProfileSheet(storage: storage)
            }
            .offerCodeRedemption(isPresented: $showRedeemCode) { _ in
                Task { await store.checkStatus() }
            }
            .alert("Delete Account & All Data?", isPresented: $showResetAlert) {
                Button("Delete Everything", role: .destructive) {
                    storage.resetOnboarding()
                    showOnboarding = true
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This permanently erases your profile, roadmap, documents, journal, tool entries, streaks, subscription preferences, and all progress from this device. DashTen does not keep any server-side account, so nothing is recoverable. This cannot be undone — you'll be returned to setup.")
            }
        }
    }

    private static var appVersionString: String {
        let version = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "1.0.0"
        let build = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "1"
        return "v\(version) (\(build))"
    }

    private var proUpsellSubtitle: String {
        "Interview Prep, Pitch Builder, Networking Hub and more"
    }

    @ViewBuilder
    private func profileRouteDestination(_ route: PlanningRoute) -> some View {
        switch route {
        case .achievementBadges: AchievementBadgesView(storage: storage)
        case .firstYearGuide: FirstYearGuideView()
        default: EmptyView()
        }
    }

    private var wellnessSubtitle: String {
        if HealthKitService.shared.hasOptedIn {
            return "Apple Health connected · check-ins & reset"
        }
        return "Apple Health, check-ins & a quick reset"
    }

    private var profileHeader: some View {
        VStack(spacing: 16) {
            Button {
                showEditProfile = true
            } label: {
                HStack(spacing: 16) {
                    ZStack(alignment: .bottomTrailing) {
                        AvatarView(
                            photoData: storage.profile.avatarPhotoData,
                            presetId: storage.profile.avatarPresetId,
                            displayName: storage.profile.displayName,
                            size: 64
                        )
                        Image(systemName: "pencil")
                            .font(.system(size: 11, weight: .heavy))
                            .foregroundStyle(.white)
                            .frame(width: 22, height: 22)
                            .background(AppTheme.forestGreen, in: Circle())
                            .overlay(Circle().stroke(Color(.systemBackground), lineWidth: 2))
                            .offset(x: 2, y: 2)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(storage.profile.displayName.isEmpty ? "Tap to set name" : storage.profile.displayName)
                            .font(.title3.bold())
                            .foregroundStyle(.primary)
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

                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.tertiary)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Edit profile name and avatar")

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

                    SupportContactCard()

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

struct SourcesReferencesView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("The stats and figures shown in DashTen come from the following public sources. Always verify with the originating agency before making decisions.")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, 4)

                    sourceRow("U.S. Department of Veterans Affairs — VetPop", "VetPop2023 transition projection — approximately 200,000 service members separate or retire each year", "va.gov/vetdata")

                    sourceRow("Ipsos / KnowledgePanel Veterans Survey", "October 2024 nationally representative survey of 516 veterans — VA financial counseling and career services awareness gaps", "ipsos.com/en-us/knowledge/society/what-veterans-know-about-their-benefits-and-services")

                    sourceRow("Veterans Education Success", "Analysis of Post-9/11 GI Bill usage — approximately 40% of veterans never use their GI Bill benefit", "vetsedsuccess.org")

                    sourceRow("U.S. Department of Veterans Affairs — VR&E Research", "National Survey of Veterans — only 14.8% of disability applicants used Vocational Rehabilitation & Employment services", "va.gov/careers-employment/vocational-rehabilitation")

                    sourceRow("U.S. Department of Veterans Affairs — VBA", "FY 2024 Annual Benefits Report — 36% of disability claims denied; 2.4 million claims processed", "benefits.va.gov/reports")

                    sourceRow("U.S. Government Accountability Office", "GAO reports on the National Personnel Records Center backlog — hundreds of thousands of pending requests for DD-214s and service records", "gao.gov")

                    sourceRow("U.S. Department of Labor — VETS", "Bureau of Labor Statistics monthly veteran employment reports", "dol.gov/agencies/vets/latest-numbers")

                    sourceRow("American Institutes for Research", "Post-9/11 GI Bill outcomes assessment with the Census Bureau and the VA's National Center for Veterans Analysis & Statistics", "air.org")

                    sourceRow("Syracuse IVMF — D'Aniello Institute", "Veterans and Military Families employment and reintegration research", "ivmf.syracuse.edu")

                    sourceRow("FINRA Foundation", "Military Financial Readiness Project — moving fund and TSP rollover decision guides", "finra.org/military")

                    sourceRow("VA Home Loan Guaranty", "VA Buyers Guide and funding fee schedule", "va.gov/housing-assistance")

                    sourceRow("U.S. Department of Veterans Affairs — Caregiver Support", "VA Caregiver Support Program eligibility and family benefits including Chapter 35/DEA", "caregiver.va.gov")

                    NonAffiliationBanner()
                        .padding(.top, 8)
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Sources & References")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(.body.weight(.bold))
                }
            }
        }
    }

    private func sourceRow(_ title: String, _ detail: String, _ urlString: String) -> some View {
        let url = URL(string: urlString.hasPrefix("http") ? urlString : "https://\(urlString)")
        return VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)
            Text(detail)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            if let url {
                Link(destination: url) {
                    HStack(spacing: 4) {
                        Image(systemName: "link")
                            .font(.caption2.weight(.bold))
                        Text(urlString)
                            .font(.caption2.weight(.bold))
                    }
                    .foregroundStyle(AppTheme.forestGreen)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 12))
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

    private static let lastUpdated: String = "April 2026"

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
                    Text("Last updated: \(Self.lastUpdated)")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.secondary)

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

    private static let lastUpdated: String = "April 2026"

    private let items: [(icon: String, color: Color, title: String, body: String)] = [
        ("iphone", .blue, "Local-only storage", "DashTen stores all data locally on your device. No personal information is transmitted to external servers."),
        ("lock.shield.fill", AppTheme.forestGreen, "Private by design", "Your transition plan, documents checklist, and progress are private and under your complete control."),
        ("person.crop.circle.badge.xmark", .purple, "No PII collection", "We do not collect, store, or share any personally identifiable information."),
        ("chart.bar.xaxis", .orange, "On-device diagnostics only", "DashTen records anonymous diagnostic events (such as which screen you opened or whether the paywall was shown) to a local log on your device. These events are not personally identifiable, never leave your device, and are not sent to any analytics, advertising, or third-party SDK. They are erased when you delete the app."),
        ("heart.text.square.fill", .pink, "Apple Health (optional, read-only)", "If you opt in, DashTen reads Steps, Sleep, and Mindful Minutes from Apple Health to show you a private 7-day snapshot. We never write to Apple Health, never upload your health data, and never share it with any third party."),
        ("bell.badge.fill", .yellow, "Notifications (optional)", "If you opt in, DashTen schedules local-only reminders (daily check-in, streak protection, phase deadlines, milestones, weekly summary). Notifications are scheduled on-device and contain no marketing or third-party content."),
        ("trash.fill", .red, "Delete = gone", "If you delete the app, all local data is permanently removed from your device."),
        ("link", .teal, "External links", "External links in the app will open in your browser. Those websites have their own privacy policies.")
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    Text("Last updated: \(Self.lastUpdated)")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.secondary)

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
