import SwiftUI

struct PlanTabView: View {
    let storage: StorageService

    private var readiness: ReadinessCalculator.ReadinessScore {
        ReadinessCalculator.calculate(checklist: storage.checklistItems, documents: storage.documents, benefits: storage.benefitCategories)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    readinessHeader

                    planningGrid

                    documentsCard

                    toolsList
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 100)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Plan")
            .navigationDestination(for: PlanningRoute.self) { route in
                routeDestination(route)
            }
        }
    }

    @ViewBuilder
    private func routeDestination(_ route: PlanningRoute) -> some View {
        switch route {
        case .career: CareerPlanningView(storage: storage)
        case .education: EducationPlanningView(storage: storage)
        case .family: FamilyPlanningView()
        case .financial: FinancialPlanningView()
        case .readiness: ReadinessDashboardView(storage: storage)
        case .crisis: CrisisResourcesView()
        case .firstThirtyDays: FirstThirtyDaysView()
        case .mindsetShifts: MindsetShiftsView()
        case .civilianPlaybook: CivilianPlaybookView()
        case .selfAssessment: SelfAssessmentView(storage: storage)
        case .finalGearCheck: FinalGearCheckView(storage: storage)
        case .mentorTracker: MentorTrackerView(storage: storage)
        case .documents: DocumentsView(storage: storage)
        case .tspRollover: TSPRolloverView()
        case .salaryNegotiation: SalaryNegotiationView()
        case .costOfLiving: CostOfLivingView()
        case .resumeTranslator: ResumeTranslatorView()
        case .interviewPrep: InterviewPrepView(storage: storage)
        case .networkingScorecard: NetworkingScorecardView(storage: storage)
        case .skillsInventory: SkillsInventoryView()
        case .giBillBAH: GIBillBAHCalculatorView()
        case .educationComparison: EducationBenefitComparisonView()
        case .relocationCost: RelocationCostView()
        case .stateBenefits: StateBenefitsFinderView()
        case .transitionJournal: TransitionJournalView(storage: storage)
        case .goalTracker: GoalTrackerView(storage: storage)
        case .weeklyCheckIn: WeeklyCheckInView(storage: storage)
        case .elevatorPitch: ElevatorPitchBuilderView(storage: storage)
        case .jargonTranslator: CivilianJargonTranslatorView()
        case .jobOfferCompare: JobOfferComparisonView(storage: storage)
        case .decisionMatrix: DecisionMatrixView(storage: storage)
        case .ninetyDayPlanner: NinetyDayPlannerView(storage: storage)
        case .weeklyChallenges: WeeklyChallengesView(storage: storage)
        case .dailyPowerUp: DailyPowerUpView(storage: storage)
        case .networkingEventPrep: NetworkingEventPrepView(storage: storage)
        case .personalBrandAudit: PersonalBrandAuditView(storage: storage)
        case .benefitsCountdown: BenefitsEnrollmentCountdownView(storage: storage)
        case .achievementBadges: AchievementBadgesView(storage: storage)
        case .firstYearGuide: FirstYearGuideView()
        case .aiCoach: AICoachView()
        }
    }

    private var readinessHeader: some View {
        NavigationLink(value: PlanningRoute.readiness) {
            HStack(spacing: 16) {
                ProgressRing(progress: readiness.overall, size: 64, lineWidth: 6)
                    .overlay {
                        Text("\(readiness.overallPercent)%")
                            .font(.subheadline.bold())
                            .foregroundStyle(AppTheme.forestGreen)
                    }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Transition Readiness")
                        .font(.headline.weight(.bold))
                    Text(readinessMessage)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.primary.opacity(0.7))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.primary.opacity(0.4))
            }
            .padding(16)
            .background(AppTheme.forestGreen.opacity(0.06))
            .clipShape(.rect(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }

    private var readinessMessage: String {
        let pct = readiness.overallPercent
        if pct >= 75 { return "Excellent progress. Keep it up!" }
        if pct >= 50 { return "Halfway there. Stay consistent." }
        if pct >= 25 { return "Good start. Focus on key areas." }
        return "Every step counts. Let's go."
    }

    private var planningGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Planning Areas")
                .font(.headline.weight(.bold))

            LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                PlanGridCard(title: "Career", icon: "briefcase.fill", color: .teal, route: .career)
                PlanGridCard(title: "Education", icon: "graduationcap.fill", color: .blue, route: .education)
                PlanGridCard(title: "Family", icon: "figure.2.and.child.holdinghands", color: .pink, route: .family)
                PlanGridCard(title: "Financial", icon: "dollarsign.circle.fill", color: AppTheme.gold, route: .financial)
            }
        }
    }

    private var documentsCard: some View {
        NavigationLink(value: PlanningRoute.documents) {
            let missingCount = storage.documents.filter { $0.status == .missing }.count
            let verifiedCount = storage.documents.filter { $0.status == .verified || $0.status == .received }.count
            let total = storage.documents.count
            let progress = total > 0 ? Double(verifiedCount) / Double(total) : 0

            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    Image(systemName: "doc.text.fill")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.orange)
                        .frame(width: 40, height: 40)
                        .background(.orange.opacity(0.12))
                        .clipShape(.rect(cornerRadius: 10))

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Documents")
                            .font(.headline.weight(.bold))
                        Text("\(verifiedCount) of \(total) secured")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.primary.opacity(0.7))
                    }

                    Spacer()

                    if missingCount > 0 {
                        Text("\(missingCount) missing")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.orange)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(.orange.opacity(0.12))
                            .clipShape(Capsule())
                    }

                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.primary.opacity(0.4))
                }

                ProgressView(value: progress)
                    .tint(.orange)
            }
            .padding(16)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }

    private var toolsList: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tools & Resources")
                .font(.headline.weight(.bold))

            VStack(spacing: 8) {
                PlanListRow(title: "First 30 Days", subtitle: "Week-by-week survival guide", icon: "flag.fill", color: .purple, route: .firstThirtyDays)
                PlanListRow(title: "Mindset Shifts", subtitle: "Navigate the mental side", icon: "brain.fill", color: .purple, route: .mindsetShifts)
                PlanListRow(title: "Civilian Playbook", subtitle: "Unwritten rules of civilian life", icon: "book.closed.fill", color: .blue, route: .civilianPlaybook)
                PlanListRow(title: "Readiness Check-In", subtitle: "Quick self-assessment", icon: "checklist.checked", color: .teal, route: .selfAssessment)
                PlanListRow(title: "Final Gear Check", subtitle: "Pre-separation review", icon: "checkmark.shield.fill", color: .orange, route: .finalGearCheck)
                PlanListRow(title: "Mentor Tracker", subtitle: "Build your civilian network", icon: "person.2.fill", color: .pink, route: .mentorTracker)
            }
        }
    }
}

struct PlanGridCard: View {
    let title: String
    let icon: String
    let color: Color
    let route: PlanningRoute

    var body: some View {
        NavigationLink(value: route) {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: icon)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(color)
                    .clipShape(.rect(cornerRadius: 12))

                Text(title)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }
}

struct PlanListRow: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let route: PlanningRoute

    var body: some View {
        NavigationLink(value: route) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(color)
                    .frame(width: 36, height: 36)
                    .background(color.opacity(0.12))
                    .clipShape(.rect(cornerRadius: 8))

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline.weight(.bold))
                    Text(subtitle)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.primary.opacity(0.6))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.primary.opacity(0.4))
            }
            .padding(14)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}
