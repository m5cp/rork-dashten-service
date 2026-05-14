import SwiftUI

enum ProfileRoute: Hashable {
    case wellness
}

struct WellnessView: View {
    let storage: StorageService

    @State private var snapshot: HealthSnapshot = .empty
    @State private var hasOptedIn: Bool = HealthKitService.shared.hasOptedIn
    @State private var working: Bool = false
    @State private var appeared: Bool = false
    @State private var showCheckIn: Bool = false
    @State private var showMindset: Bool = false
    @State private var showBreathing: Bool = false
    @State private var mindsetIndex: Int = 0

    private let shifts = TransitionDataService.mindsetShifts()

    private var currentShift: MindsetShift? {
        guard !shifts.isEmpty else { return nil }
        return shifts[mindsetIndex % shifts.count]
    }

    private var lastCheckIn: WeeklyCheckInEntry? {
        storage.weeklyCheckIns.first
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                header
                    .delayedEntrance(appeared, delay: 0.0)

                healthCard
                    .delayedEntrance(appeared, delay: 0.06)

                checkInCard
                    .delayedEntrance(appeared, delay: 0.12)

                breathingCard
                    .delayedEntrance(appeared, delay: 0.18)

                if let shift = currentShift {
                    mindsetCard(shift)
                        .delayedEntrance(appeared, delay: 0.24)
                }

                privacyFooter
                    .delayedEntrance(appeared, delay: 0.3)
            }
            .readableContentWidth()
            .padding(.horizontal, 16)
            .padding(.top, 4)
            .padding(.bottom, 40)
        }
        .scrollIndicators(.hidden)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Wellness")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if hasOptedIn {
                snapshot = await HealthKitService.shared.loadSnapshot()
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.85)) {
                appeared = true
            }
            let day = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
            mindsetIndex = shifts.isEmpty ? 0 : (day % shifts.count)
            AnalyticsService.shared.log(.screenView, properties: ["name": "wellness"])
        }
        .sheet(isPresented: $showCheckIn) {
            NavigationStack {
                WeeklyCheckInView(storage: storage)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Done") { showCheckIn = false }
                                .fontWeight(.semibold)
                        }
                    }
            }
        }
        .sheet(isPresented: $showMindset) {
            NavigationStack {
                MindsetShiftsView(highlightedShiftId: currentShift?.id)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Done") { showMindset = false }
                                .fontWeight(.semibold)
                        }
                    }
            }
        }
        .sheet(isPresented: $showBreathing) {
            BoxBreathingView()
                .presentationDetents([.large])
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                Image(systemName: "heart.text.square.fill")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.pink)
                    .frame(width: 42, height: 42)
                    .background(Color.pink.opacity(0.12))
                    .clipShape(.rect(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 2) {
                    Text("Your wellness")
                        .font(.title3.weight(.heavy))
                    Text("Sleep, movement, and mindset")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }

            RoundedRectangle(cornerRadius: 1.5)
                .fill(LinearGradient(
                    colors: [AppTheme.gold, AppTheme.gold.opacity(0)],
                    startPoint: .leading,
                    endPoint: .trailing
                ))
                .frame(height: 2)
                .frame(maxWidth: 120, alignment: .leading)
                .padding(.top, 2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 18))
    }

    // MARK: - Apple Health

    private var healthCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Text("APPLE HEALTH")
                    .font(.caption2.weight(.heavy))
                    .tracking(1.4)
                    .foregroundStyle(AppTheme.forestGreen)
                Spacer()
                if hasOptedIn {
                    Label("Read-only", systemImage: "lock.shield.fill")
                        .labelStyle(.titleAndIcon)
                        .font(.caption2.weight(.heavy))
                        .foregroundStyle(.secondary)
                }
            }

            if hasOptedIn {
                HStack(spacing: 10) {
                    metricTile(
                        value: snapshot.avgStepsLast7Days.formatted(.number),
                        unit: "/ day",
                        label: "Steps",
                        icon: "figure.walk",
                        color: AppTheme.forestGreen
                    )
                    metricTile(
                        value: String(format: "%.1f", snapshot.avgSleepHoursLast7Days),
                        unit: "hrs",
                        label: "Sleep",
                        icon: "bed.double.fill",
                        color: .indigo
                    )
                    metricTile(
                        value: "\(snapshot.mindfulMinutesLast7Days)",
                        unit: "min",
                        label: "Mindful",
                        icon: "brain.head.profile",
                        color: AppTheme.gold
                    )
                }

                HStack(spacing: 10) {
                    Button {
                        Task { await refresh() }
                    } label: {
                        HStack(spacing: 6) {
                            if working {
                                ProgressView().tint(AppTheme.forestGreen)
                            } else {
                                Image(systemName: "arrow.clockwise")
                            }
                            Text(working ? "Refreshing…" : "Refresh")
                        }
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(AppTheme.forestGreen)
                        .frame(maxWidth: .infinity, minHeight: 42)
                        .background(AppTheme.forestGreen.opacity(0.1))
                        .clipShape(.rect(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                    .disabled(working)

                    Button(role: .destructive) {
                        HealthKitService.shared.setOptedIn(false)
                        hasOptedIn = false
                        snapshot = .empty
                    } label: {
                        Text("Disconnect")
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity, minHeight: 42)
                            .background(Color.red.opacity(0.08))
                            .clipShape(.rect(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                }

                Text("Last 7-day averages · updated \(snapshot.capturedAt, style: .relative) ago")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.tertiary)
            } else {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Connect Apple Health for a private 7-day snapshot of your steps, sleep, and mindful minutes.")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary.opacity(0.85))

                    Button {
                        Task { await connect() }
                    } label: {
                        HStack(spacing: 8) {
                            if working { ProgressView().tint(.white) }
                            Image(systemName: "heart.fill")
                                .font(.subheadline.weight(.bold))
                            Text(working ? "Connecting…" : "Connect Apple Health")
                                .font(.body.weight(.bold))
                        }
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .background(AppTheme.forestGreen)
                        .foregroundStyle(.white)
                        .clipShape(.rect(cornerRadius: 14))
                    }
                    .buttonStyle(.plain)
                    .disabled(working || !HealthKitService.shared.isAvailable)

                    if !HealthKitService.shared.isAvailable {
                        Label("Apple Health isn't available on this device.", systemImage: "info.circle")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 18))
    }

    private func metricTile(value: String, unit: String, label: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.caption.weight(.heavy))
                .foregroundStyle(color)
                .frame(width: 22, height: 22)
                .background(color.opacity(0.14))
                .clipShape(.rect(cornerRadius: 6))

            HStack(alignment: .firstTextBaseline, spacing: 3) {
                Text(value)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                Text(unit)
                    .font(.caption2.weight(.heavy))
                    .foregroundStyle(.secondary)
            }

            Text(label)
                .font(.caption2.weight(.heavy))
                .tracking(0.6)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color(.tertiarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 14))
    }

    // MARK: - Check-In

    private var checkInCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Text("WEEKLY CHECK-IN")
                    .font(.caption2.weight(.heavy))
                    .tracking(1.4)
                    .foregroundStyle(AppTheme.forestGreen)
                Spacer()
                if let last = lastCheckIn {
                    Text(last.date, format: .relative(presentation: .named))
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.secondary)
                }
            }

            if let last = lastCheckIn {
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .stroke(AppTheme.forestGreen.opacity(0.12), lineWidth: 6)
                        Circle()
                            .trim(from: 0, to: max(0, min(1, last.averageScore / 5.0)))
                            .stroke(AppTheme.forestGreen, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                        VStack(spacing: 0) {
                            Text(String(format: "%.1f", last.averageScore))
                                .font(.system(size: 18, weight: .heavy, design: .rounded))
                            Text("/ 5")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(width: 56, height: 56)

                    VStack(alignment: .leading, spacing: 3) {
                        Text("You're \(qualitative(last.averageScore))")
                            .font(.headline.weight(.bold))
                        Text("\(storage.weeklyCheckIns.count) check-in\(storage.weeklyCheckIns.count == 1 ? "" : "s") logged")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
            } else {
                HStack(spacing: 12) {
                    Image(systemName: "heart.text.square")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(AppTheme.forestGreen)
                        .frame(width: 44, height: 44)
                        .background(AppTheme.forestGreen.opacity(0.12))
                        .clipShape(.rect(cornerRadius: 12))
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Take 60 seconds")
                            .font(.headline.weight(.bold))
                        Text("Rate how you're trending across 5 areas")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
            }

            Button {
                showCheckIn = true
            } label: {
                HStack(spacing: 6) {
                    Text(lastCheckIn == nil ? "Start your check-in" : "Log this week")
                        .font(.subheadline.weight(.bold))
                    Image(systemName: "arrow.right")
                        .font(.caption.weight(.bold))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, minHeight: 44)
                .background(AppTheme.forestGreen)
                .clipShape(.rect(cornerRadius: 12))
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 18))
    }

    private func qualitative(_ score: Double) -> String {
        switch score {
        case ..<2: return "having a tough week"
        case ..<3: return "holding steady"
        case ..<4: return "doing well"
        default: return "thriving"
        }
    }

    // MARK: - Mindset

    private func mindsetCard(_ shift: MindsetShift) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Text("MINDSET MOMENT")
                    .font(.caption2.weight(.heavy))
                    .tracking(1.4)
                    .foregroundStyle(AppTheme.gold)
                Spacer()
                Button {
                    withAnimation(.spring(response: 0.4)) {
                        mindsetIndex = (mindsetIndex + 1) % max(shifts.count, 1)
                    }
                } label: {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Show another mindset shift")
            }

            Text(shift.title)
                .font(.headline.weight(.bold))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.leading)

            Text(shift.insight)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)

            Button {
                showMindset = true
            } label: {
                HStack(spacing: 6) {
                    Text("More mindset shifts")
                        .font(.subheadline.weight(.bold))
                    Image(systemName: "arrow.right")
                        .font(.caption.weight(.bold))
                }
                .foregroundStyle(AppTheme.darkGreen)
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 18))
    }

    // MARK: - Breathing

    private var breathingCard: some View {
        Button {
            showBreathing = true
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(
                            colors: [AppTheme.forestGreen.opacity(0.18), AppTheme.gold.opacity(0.18)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 52, height: 52)
                    Image(systemName: "wind")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(AppTheme.darkGreen)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text("Box Breathing")
                        .font(.headline.weight(.bold))
                    Text("60 seconds · 4-4-4-4 reset")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "play.circle.fill")
                    .font(.title)
                    .foregroundStyle(AppTheme.forestGreen)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(18)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 18))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Privacy footer

    private var privacyFooter: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "lock.shield.fill")
                .font(.caption.weight(.bold))
                .foregroundStyle(AppTheme.forestGreen)
            Text("Read-only · Never leaves your device. DashTen never writes to Apple Health and never shares your wellness data.")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 0)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.forestGreen.opacity(0.06))
        .clipShape(.rect(cornerRadius: 14))
    }

    // MARK: - Actions

    private func connect() async {
        working = true
        defer { working = false }
        let granted = await HealthKitService.shared.requestAuthorization()
        hasOptedIn = granted
        if granted {
            snapshot = await HealthKitService.shared.loadSnapshot()
        }
    }

    private func refresh() async {
        working = true
        defer { working = false }
        snapshot = await HealthKitService.shared.loadSnapshot()
    }
}

// MARK: - Box Breathing

struct BoxBreathingView: View {
    @Environment(\.dismiss) private var dismiss

    private enum Phase: Int, CaseIterable {
        case inhale, holdIn, exhale, holdOut

        var label: String {
            switch self {
            case .inhale: "Breathe in"
            case .holdIn: "Hold"
            case .exhale: "Breathe out"
            case .holdOut: "Hold"
            }
        }
    }

    @State private var isRunning: Bool = false
    @State private var phase: Phase = .inhale
    @State private var elapsed: Int = 0
    @State private var phaseTick: Int = 0
    @State private var timer: Timer?
    @State private var hapticTrigger: Int = 0

    private let totalSeconds: Int = 60
    private let phaseDuration: Int = 4

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [AppTheme.darkGreen, AppTheme.forestGreen],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 36) {
                HStack {
                    Spacer()
                    Button {
                        stop()
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(.white)
                            .frame(width: 36, height: 36)
                            .background(Color.white.opacity(0.18), in: Circle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)

                Spacer(minLength: 0)

                VStack(spacing: 8) {
                    Text(isRunning ? phase.label : "Box Breathing")
                        .font(.system(size: 30, weight: .heavy, design: .rounded))
                        .foregroundStyle(.white)
                        .contentTransition(.opacity)

                    Text(isRunning ? "\(max(0, totalSeconds - elapsed))s remaining" : "60-second reset · inhale, hold, exhale, hold")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.75))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }

                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                        .frame(width: 260, height: 260)
                    Circle()
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        .frame(width: 200, height: 200)

                    Circle()
                        .fill(LinearGradient(
                            colors: [AppTheme.gold.opacity(0.9), AppTheme.gold.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: circleSize, height: circleSize)
                        .shadow(color: AppTheme.gold.opacity(0.4), radius: 30)
                        .overlay {
                            Text("\(phaseDuration - phaseTick)")
                                .font(.system(size: 56, weight: .heavy, design: .rounded))
                                .foregroundStyle(AppTheme.darkGreen)
                                .opacity(isRunning ? 1 : 0)
                        }
                        .animation(.spring(response: 1.0, dampingFraction: 0.85), value: phase)
                        .animation(.easeInOut(duration: 0.4), value: isRunning)
                }

                Spacer(minLength: 0)

                Button {
                    isRunning ? stop() : start()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: isRunning ? "stop.fill" : "play.fill")
                        Text(isRunning ? "Stop" : "Begin")
                    }
                    .font(.body.weight(.heavy))
                    .foregroundStyle(AppTheme.darkGreen)
                    .frame(maxWidth: .infinity, minHeight: 54)
                    .background(.white)
                    .clipShape(Capsule())
                    .padding(.horizontal, 40)
                }
                .buttonStyle(.plain)
                .padding(.bottom, 28)
            }
        }
        .sensoryFeedback(.selection, trigger: hapticTrigger)
        .onDisappear { stop() }
    }

    private var circleSize: CGFloat {
        guard isRunning else { return 160 }
        switch phase {
        case .inhale: return 230
        case .holdIn: return 230
        case .exhale: return 130
        case .holdOut: return 130
        }
    }

    private func start() {
        elapsed = 0
        phaseTick = 0
        phase = .inhale
        isRunning = true
        hapticTrigger &+= 1
        AnalyticsService.shared.log(.featureUsed, properties: ["name": "box_breathing_start"])
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            Task { @MainActor in tick() }
        }
    }

    private func stop() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }

    private func tick() {
        guard isRunning else { return }
        elapsed += 1
        phaseTick += 1
        if phaseTick >= phaseDuration {
            phaseTick = 0
            let next = (phase.rawValue + 1) % Phase.allCases.count
            phase = Phase(rawValue: next) ?? .inhale
            hapticTrigger &+= 1
        }
        if elapsed >= totalSeconds {
            stop()
            hapticTrigger &+= 1
        }
    }
}

// MARK: - Helpers

private extension View {
    func delayedEntrance(_ appeared: Bool, delay: Double) -> some View {
        self
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 14)
            .animation(.spring(response: 0.65, dampingFraction: 0.85).delay(delay), value: appeared)
    }
}
