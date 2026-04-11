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

    var body: some View {
        NavigationStack {
            List {
                Section("Personal Info") {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 44))
                            .foregroundStyle(AppTheme.forestGreen)
                        VStack(alignment: .leading, spacing: 4) {
                            TextField("Display Name", text: $storage.profile.displayName)
                                .font(.headline)
                            if let branch = storage.profile.branch {
                                Text(branch.rawValue)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }

                    if storage.profile.separationDate != nil {
                        DatePicker("Separation Date", selection: Binding(
                            get: { storage.profile.separationDate ?? Date() },
                            set: { storage.profile.separationDate = $0 }
                        ), displayedComponents: .date)
                    }

                    Stepper("Household Size: \(storage.profile.householdSize)", value: $storage.profile.householdSize, in: 1...20)

                    TextField("Spouse Name", text: $storage.profile.spouseName)
                }

                Section("Goals") {
                    if storage.profile.goals.isEmpty {
                        Text("No goals selected")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(storage.profile.goals) { goal in
                            Label(goal.rawValue, systemImage: goal.icon)
                                .font(.subheadline)
                        }
                    }
                }

                Section("App") {
                    Button {
                        showAbout = true
                    } label: {
                        Label("About DashTen", systemImage: "info.circle")
                    }

                    Button {
                        showTransparency = true
                    } label: {
                        Label("Source Transparency", systemImage: "doc.text.magnifyingglass")
                    }

                    NavigationLink {
                        CrisisResourcesView()
                    } label: {
                        Label("Crisis Resources", systemImage: "heart.fill")
                            .foregroundStyle(.red)
                    }
                }

                Section("Legal") {
                    Button {
                        showTerms = true
                    } label: {
                        Label("Terms of Use", systemImage: "doc.plaintext")
                    }

                    Button {
                        showPrivacy = true
                    } label: {
                        Label("Privacy Policy", systemImage: "lock.shield")
                    }

                    Button {
                        showEULA = true
                    } label: {
                        Label("Apple EULA", systemImage: "doc.text")
                    }

                    Button {
                        showAccessibility = true
                    } label: {
                        Label("Accessibility", systemImage: "accessibility")
                    }

                    Button {
                        showDisclaimer = true
                    } label: {
                        Label("Disclaimer & Risks", systemImage: "exclamationmark.triangle")
                    }
                }

                Section {
                    NonAffiliationBanner()
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                }

                Section {
                    Button("Reset All Data", role: .destructive) {
                        showResetAlert = true
                    }
                }

                Section {} footer: {
                    VStack(spacing: 4) {
                        Text("DashTen v1.0.0")
                        Text("Built independently for the transition community")
                    }
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Profile")
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
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Why This App Exists")
                            .font(.headline)
                            .foregroundStyle(AppTheme.forestGreen)

                        Text("I built this app because I wasn't as prepared as I should have been when I separated from the military. The transition was overwhelming — too many decisions, too many deadlines, and not enough clarity on what mattered most.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Text("DashTen is the tool I wish I had. A single place to organize your plan, understand your benefits, track your documents, and stay on top of what matters — on your timeline.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Text("This app is for every service member, veteran, and military family navigating the transition to civilian life. You've earned the preparation.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
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
                            .font(.headline)
                            .foregroundStyle(AppTheme.forestGreen)

                        Group {
                            Text("DashTen summarizes publicly available information about military transition, veteran benefits, and post-service planning.")
                            Text("All content in this app is based on publicly accessible resources from official websites, publicly available guides, and common transition knowledge.")
                            Text("This app does not claim to have insider, proprietary, or classified information. All information should be verified with official sources before making decisions.")
                        }
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    }
                    .padding(16)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(.rect(cornerRadius: 14))

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Important Reminders")
                            .font(.headline)

                        Group {
                            Label("Eligibility requirements can change. Always verify with official sources.", systemImage: "exclamationmark.triangle")
                            Label("Deadlines and timelines may vary by branch, location, and individual situation.", systemImage: "clock")
                            Label("Benefit details are summaries, not official determinations.", systemImage: "doc.text")
                            Label("External links go to official or established organization websites.", systemImage: "link")
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                    .padding(16)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(.rect(cornerRadius: 14))

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Official Resources")
                            .font(.headline)
                        OfficialLinkButton(title: "Military OneSource", url: "https://www.militaryonesource.mil/")
                        OfficialLinkButton(title: "Department of Labor Veterans' Employment", url: "https://www.dol.gov/agencies/vets")
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
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Group {
                            Text("1. DashTen is an informational and organizational tool designed to help users plan their transition from military to civilian life.")
                            Text("2. You accept full responsibility for verifying all information with official sources before making any decisions based on content in this app.")
                            Text("3. The app creator is not liable for any decisions made, actions taken, or outcomes resulting from information presented in this app.")
                            Text("4. This app does not provide legal, medical, financial, career counseling, or claims assistance of any kind.")
                            Text("5. You agree not to rely solely on this app for transition planning and will consult qualified professionals and official agencies as needed.")
                            Text("6. All data is stored locally on your device. You are responsible for backing up your own data.")
                            Text("7. The app creator reserves the right to update these terms at any time.")
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
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
                        .font(.caption)
                        .foregroundStyle(.secondary)
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
                        .font(.caption)
                        .foregroundStyle(.secondary)

                        OfficialLinkButton(title: "Apple Standard EULA", url: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")

                        Group {
                            Text("The licensor of DashTen is the app developer, not Apple Inc. Apple has no obligation to furnish maintenance and support services for this app.")
                            Text("In the event of any failure of DashTen to conform to any applicable warranty, you may notify Apple for a refund of the purchase price (if any). Apple has no other warranty obligation.")
                            Text("Any claims relating to DashTen, including product liability claims, are the responsibility of the app developer, not Apple.")
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
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
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Group {
                            Label("Dynamic Type — text scales with your system font size settings", systemImage: "textformat.size")
                            Label("VoiceOver — all interactive elements include descriptive labels", systemImage: "speaker.wave.2.fill")
                            Label("Color Contrast — designed to meet accessibility contrast standards", systemImage: "circle.lefthalf.filled")
                            Label("Reduced Motion — respects system reduced motion preferences", systemImage: "figure.walk")
                            Label("Touch Targets — all buttons meet the minimum 44×44pt touch target", systemImage: "hand.tap.fill")
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)

                        Text("If you experience any accessibility issues, please contact us through the App Store.")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
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
                            .font(.headline)
                            .foregroundStyle(.orange)

                        Group {
                            Text("DashTen is a planning and organization tool only. It does not provide legal, medical, financial, or career advice of any kind.")
                            Text("Users should consult qualified professionals and official agencies for specific guidance about benefits, eligibility, claims, and any other matters discussed in this app.")
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                    .padding(16)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(.rect(cornerRadius: 14))

                    VStack(alignment: .leading, spacing: 12) {
                        Label("Risk Acknowledgment", systemImage: "shield.lefthalf.filled")
                            .font(.headline)
                            .foregroundStyle(.red)

                        Group {
                            Text("Transition planning involves complex decisions with significant consequences.")
                            Text("DashTen helps organize your approach but cannot replace official counseling, legal review, or professional guidance.")
                            Text("Eligibility requirements, deadlines, and benefit details can change at any time. Always verify with official sources.")
                            Text("The app creator assumes no liability for any actions taken or decisions made based on information in this app.")
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                    .padding(16)
                    .background(Color(.secondarySystemGroupedBackground))
                    .clipShape(.rect(cornerRadius: 14))

                    VStack(alignment: .leading, spacing: 12) {
                        Label("Crisis Support", systemImage: "heart.fill")
                            .font(.headline)
                            .foregroundStyle(.red)

                        Text("If you are experiencing a crisis, please contact the 988 Suicide & Crisis Lifeline by calling or texting 988. This app is not an emergency service.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
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
                }
            }
        }
    }
}
