import SwiftUI

struct PersonalBrandAuditView: View {
    @Bindable var storage: StorageService

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                scoreCard
                auditChecklist
                improvementTips
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 100)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Brand Audit")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { storage.trackToolUsed("brand_audit") }
    }

    private var scoreCard: some View {
        VStack(spacing: 16) {
            ProgressRing(progress: Double(storage.brandAudit.score) / Double(storage.brandAudit.totalItems), size: 80, lineWidth: 7, color: scoreColor)
                .overlay {
                    VStack(spacing: 0) {
                        Text("\(storage.brandAudit.percentage)")
                            .font(.title2.bold())
                            .foregroundStyle(scoreColor)
                        Text("%")
                            .font(.caption2.bold())
                            .foregroundStyle(scoreColor.opacity(0.7))
                    }
                }

            Text("Brand Score")
                .font(.headline.weight(.bold))

            Text(scoreMessage)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Text("\(storage.brandAudit.score) of \(storage.brandAudit.totalItems) items complete")
                .font(.caption.weight(.bold))
                .foregroundStyle(.tertiary)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 18))
    }

    private var scoreColor: Color {
        let pct = storage.brandAudit.percentage
        if pct >= 75 { return AppTheme.forestGreen }
        if pct >= 50 { return .blue }
        if pct >= 25 { return .orange }
        return .red
    }

    private var scoreMessage: String {
        let pct = storage.brandAudit.percentage
        if pct >= 88 { return "Outstanding! Your personal brand is strong and professional." }
        if pct >= 63 { return "Good progress. A few more items and you'll stand out." }
        if pct >= 38 { return "Getting there. Focus on the unchecked items below." }
        return "Just getting started. Each item you complete strengthens your presence."
    }

    private var auditChecklist: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Your Brand Checklist")
                .font(.headline.weight(.bold))

            AuditRow(
                title: "LinkedIn Profile Complete",
                subtitle: "Professional photo, headline, summary, experience, skills, 500+ connections target",
                isChecked: $storage.brandAudit.linkedInComplete,
                icon: "person.crop.circle.fill",
                color: .blue
            )
            AuditRow(
                title: "Resume Ready",
                subtitle: "Civilian-translated, tailored to target role, reviewed by someone in your target field",
                isChecked: $storage.brandAudit.resumeReady,
                icon: "doc.text.fill",
                color: .teal
            )
            AuditRow(
                title: "Online Presence Clean",
                subtitle: "Google yourself — remove or adjust any unprofessional content across all platforms",
                isChecked: $storage.brandAudit.onlinePresenceClean,
                icon: "globe",
                color: .purple
            )
            AuditRow(
                title: "Networking Active",
                subtitle: "Attending events, doing informational interviews, following up with contacts regularly",
                isChecked: $storage.brandAudit.networkingActive,
                icon: "person.3.fill",
                color: .pink
            )
            AuditRow(
                title: "Elevator Pitch Ready",
                subtitle: "Can confidently introduce yourself in 30-60 seconds to any audience",
                isChecked: $storage.brandAudit.elevatorPitchReady,
                icon: "mic.fill",
                color: AppTheme.forestGreen
            )
            AuditRow(
                title: "Professional Email",
                subtitle: "Using a clean, professional email address (not a military one you'll lose access to)",
                isChecked: $storage.brandAudit.professionalEmail,
                icon: "envelope.fill",
                color: .orange
            )
            AuditRow(
                title: "Portfolio / Work Samples",
                subtitle: "Have examples of your work, certifications, or projects ready to share",
                isChecked: $storage.brandAudit.portfolioExists,
                icon: "folder.fill",
                color: .indigo
            )
            AuditRow(
                title: "Endorsements Collected",
                subtitle: "LinkedIn recommendations or reference letters from supervisors and peers",
                isChecked: $storage.brandAudit.endorsementsCollected,
                icon: "hand.thumbsup.fill",
                color: AppTheme.gold
            )
        }
        .onChange(of: storage.brandAudit.score) { _, newValue in
            if newValue == storage.brandAudit.totalItems {
                storage.unlockBadge("brand_audited")
            }
        }
    }

    private var improvementTips: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Quick Wins")
                .font(.caption.weight(.heavy))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)

            if !storage.brandAudit.linkedInComplete {
                ImprovementTip(text: "Update your LinkedIn headline to include your target role and key skill", color: .blue)
            }
            if !storage.brandAudit.resumeReady {
                ImprovementTip(text: "Use the Resume Translator tool to convert military jargon to civilian language", color: .teal)
            }
            if !storage.brandAudit.elevatorPitchReady {
                ImprovementTip(text: "Use the Elevator Pitch Builder to craft your introduction", color: AppTheme.forestGreen)
            }
            if !storage.brandAudit.professionalEmail {
                ImprovementTip(text: "Create a Gmail or Outlook email with your name — avoid nicknames or numbers", color: .orange)
            }
            if storage.brandAudit.score == storage.brandAudit.totalItems {
                HStack(spacing: 8) {
                    Image(systemName: "trophy.fill")
                        .foregroundStyle(AppTheme.gold)
                    Text("Your personal brand is fully audited. Keep it updated as you progress.")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(AppTheme.gold)
                }
            }
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 14))
    }
}

private struct AuditRow: View {
    let title: String
    let subtitle: String
    @Binding var isChecked: Bool
    let icon: String
    let color: Color

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3)) { isChecked.toggle() }
        } label: {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(isChecked ? color : .primary.opacity(0.25))
                    .symbolEffect(.bounce, value: isChecked)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subheadline.weight(.bold))
                        .strikethrough(isChecked)
                        .foregroundStyle(isChecked ? Color.primary.opacity(0.5) : Color.primary)
                    Text(subtitle)
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundStyle(color.opacity(0.4))
            }
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.success, trigger: isChecked)
        .padding(12)
        .background(isChecked ? color.opacity(0.04) : Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 12))
    }
}

private struct ImprovementTip: View {
    let text: String
    let color: Color

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "arrow.right.circle.fill")
                .font(.caption)
                .foregroundStyle(color)
                .padding(.top, 2)
            Text(text)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.primary.opacity(0.8))
        }
    }
}
