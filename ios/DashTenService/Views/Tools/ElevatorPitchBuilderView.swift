import SwiftUI

struct ElevatorPitchBuilderView: View {
    @Bindable var storage: StorageService
    @State private var currentStep: Int = 0
    @State private var background: String = ""
    @State private var targetRole: String = ""
    @State private var valueProp1: String = ""
    @State private var valueProp2: String = ""
    @State private var valueProp3: String = ""
    @State private var generatedPitch: String = ""
    @State private var selectedDuration: PitchDuration = .thirty

    private let steps = ["Background", "Target", "Value Props", "Your Pitch"]

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                stepIndicator

                switch currentStep {
                case 0: backgroundStep
                case 1: targetStep
                case 2: valuePropsStep
                default: pitchResultStep
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 100)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Elevator Pitch")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let existing = storage.elevatorPitch {
                background = existing.background
                targetRole = existing.targetRole
                if existing.valueProps.count > 0 { valueProp1 = existing.valueProps[0] }
                if existing.valueProps.count > 1 { valueProp2 = existing.valueProps[1] }
                if existing.valueProps.count > 2 { valueProp3 = existing.valueProps[2] }
                if !existing.pitch30.isEmpty {
                    generatedPitch = existing.pitch30
                    currentStep = 3
                }
            }
            storage.trackToolUsed("elevator_pitch")
        }
    }

    private var stepIndicator: some View {
        HStack(spacing: 6) {
            ForEach(0..<steps.count, id: \.self) { index in
                VStack(spacing: 6) {
                    Circle()
                        .fill(index <= currentStep ? AppTheme.forestGreen : AppTheme.forestGreen.opacity(0.15))
                        .frame(width: 28, height: 28)
                        .overlay {
                            if index < currentStep {
                                Image(systemName: "checkmark")
                                    .font(.caption2.weight(.bold))
                                    .foregroundStyle(.white)
                            } else {
                                Text("\(index + 1)")
                                    .font(.caption2.weight(.bold))
                                    .foregroundStyle(index == currentStep ? .white : AppTheme.forestGreen)
                            }
                        }
                    Text(steps[index])
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(index <= currentStep ? .primary : .tertiary)
                }
                if index < steps.count - 1 {
                    Rectangle()
                        .fill(index < currentStep ? AppTheme.forestGreen : AppTheme.forestGreen.opacity(0.15))
                        .frame(height: 2)
                        .padding(.bottom, 16)
                }
            }
        }
        .padding(.top, 8)
    }

    private var backgroundStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Your Background")
                    .font(.title3.weight(.bold))
                Text("Briefly describe your military experience and key skills. This is the foundation of your pitch.")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)
            }

            TextEditor(text: $background)
                .font(.body)
                .frame(minHeight: 120)
                .scrollContentBackground(.hidden)
                .padding(12)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(.rect(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 8) {
                Text("Examples:")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)
                Text("\"8 years in Army logistics managing supply chains for 500+ personnel\"")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
                    .italic()
                Text("\"Navy corpsman with 6 years of emergency medical experience\"")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
                    .italic()
            }
            .padding(12)
            .background(AppTheme.forestGreen.opacity(0.06))
            .clipShape(.rect(cornerRadius: 10))

            Button {
                withAnimation(.spring(response: 0.4)) { currentStep = 1 }
            } label: {
                Text("Next")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(background.trimmingCharacters(in: .whitespaces).isEmpty ? Color.gray : AppTheme.forestGreen)
                    .clipShape(.rect(cornerRadius: 14))
            }
            .disabled(background.trimmingCharacters(in: .whitespaces).isEmpty)
        }
    }

    private var targetStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Target Role")
                    .font(.title3.weight(.bold))
                Text("What civilian role or industry are you targeting?")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)
            }

            TextField("e.g. Project Manager, IT Security, Healthcare Admin", text: $targetRole)
                .font(.body.weight(.medium))
                .padding(14)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(.rect(cornerRadius: 12))

            HStack(spacing: 12) {
                Button {
                    withAnimation(.spring(response: 0.4)) { currentStep = 0 }
                } label: {
                    Text("Back")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(AppTheme.forestGreen)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(AppTheme.forestGreen.opacity(0.1))
                        .clipShape(.rect(cornerRadius: 14))
                }
                Button {
                    withAnimation(.spring(response: 0.4)) { currentStep = 2 }
                } label: {
                    Text("Next")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(targetRole.trimmingCharacters(in: .whitespaces).isEmpty ? Color.gray : AppTheme.forestGreen)
                        .clipShape(.rect(cornerRadius: 14))
                }
                .disabled(targetRole.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
    }

    private var valuePropsStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Your Value Propositions")
                    .font(.title3.weight(.bold))
                Text("List 3 key strengths you bring to the table. Think: what makes you uniquely valuable?")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 10) {
                ValuePropField(number: 1, text: $valueProp1, placeholder: "e.g. Led teams of 30+ in high-pressure environments")
                ValuePropField(number: 2, text: $valueProp2, placeholder: "e.g. Managed $2M+ budgets with zero overruns")
                ValuePropField(number: 3, text: $valueProp3, placeholder: "e.g. PMP certified with proven project delivery")
            }

            HStack(spacing: 12) {
                Button {
                    withAnimation(.spring(response: 0.4)) { currentStep = 1 }
                } label: {
                    Text("Back")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(AppTheme.forestGreen)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(AppTheme.forestGreen.opacity(0.1))
                        .clipShape(.rect(cornerRadius: 14))
                }
                Button {
                    generatePitch()
                    withAnimation(.spring(response: 0.4)) { currentStep = 3 }
                } label: {
                    Text("Generate Pitch")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(!valueProp1.isEmpty ? AppTheme.forestGreen : Color.gray)
                        .clipShape(.rect(cornerRadius: 14))
                }
                .disabled(valueProp1.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
    }

    private var pitchResultStep: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 10) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(AppTheme.forestGreen)
                Text("Your Pitch is Ready!")
                    .font(.title3.weight(.bold))
            }

            Picker("Duration", selection: $selectedDuration) {
                ForEach(PitchDuration.allCases) { dur in
                    Text(dur.rawValue).tag(dur)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: selectedDuration) { _, _ in
                generatePitch()
            }

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(selectedDuration.rawValue)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(AppTheme.forestGreen)
                    Spacer()
                    Text("\(generatedPitch.split(separator: " ").count) words")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.tertiary)
                }
                Text(generatedPitch)
                    .font(.body.weight(.medium))
                    .foregroundStyle(.primary.opacity(0.9))
                    .lineSpacing(4)
            }
            .padding(16)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 14))

            Button {
                UIPasteboard.general.string = generatedPitch
            } label: {
                Label("Copy to Clipboard", systemImage: "doc.on.doc")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(AppTheme.forestGreen)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(AppTheme.forestGreen.opacity(0.1))
                    .clipShape(.rect(cornerRadius: 12))
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Practice Tips")
                    .font(.subheadline.weight(.bold))
                PracticeTip(text: "Practice in front of a mirror — watch your body language")
                PracticeTip(text: "Record yourself and listen back for filler words")
                PracticeTip(text: "Adjust your pitch for each audience")
                PracticeTip(text: "End with a question to start a conversation")
            }
            .padding(14)
            .background(AppTheme.gold.opacity(0.08))
            .clipShape(.rect(cornerRadius: 12))

            Button {
                withAnimation(.spring(response: 0.4)) { currentStep = 0 }
            } label: {
                Text("Edit Pitch")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(AppTheme.forestGreen)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(AppTheme.forestGreen.opacity(0.1))
                    .clipShape(.rect(cornerRadius: 14))
            }
        }
    }

    private func generatePitch() {
        let props = [valueProp1, valueProp2, valueProp3].filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        let propsText = props.joined(separator: ". ")

        switch selectedDuration {
        case .thirty:
            generatedPitch = "Hi, I'm transitioning from a career in \(background.trimmingCharacters(in: .whitespacesAndNewlines)). I'm looking to bring my experience in \(propsText) to a \(targetRole) role. I'd love to learn more about opportunities in your organization."
        case .sixty:
            generatedPitch = "Hi, I'm transitioning from a career in \(background.trimmingCharacters(in: .whitespacesAndNewlines)). Throughout my service, I developed strong skills in \(propsText). I'm now pursuing a career as a \(targetRole) where I can apply these strengths to drive results. I'm particularly interested in organizations that value leadership, accountability, and mission-driven work. I'd appreciate any insights you might have."
        case .ninety:
            generatedPitch = "Hi, I'm transitioning from a career in \(background.trimmingCharacters(in: .whitespacesAndNewlines)). Over the course of my service, I've built deep experience in \(propsText). These skills have been tested in high-stakes environments where precision and teamwork are non-negotiable. I'm now transitioning into the \(targetRole) space because I believe my background directly translates to delivering value in this field. I'm actively networking and learning from professionals like you to make a strong start. What advice would you give someone making this transition?"
        }

        var pitch = ElevatorPitch()
        pitch.background = background
        pitch.targetRole = targetRole
        pitch.valueProps = [valueProp1, valueProp2, valueProp3].filter { !$0.isEmpty }
        pitch.pitch30 = generatedPitch
        pitch.lastEdited = Date()
        storage.elevatorPitch = pitch
        storage.unlockBadge("pitch_crafted")
    }
}

nonisolated enum PitchDuration: String, CaseIterable, Identifiable, Sendable {
    case thirty = "30 seconds"
    case sixty = "60 seconds"
    case ninety = "90 seconds"
    var id: String { rawValue }
}

private struct ValuePropField: View {
    let number: Int
    @Binding var text: String
    let placeholder: String

    var body: some View {
        HStack(spacing: 10) {
            Text("\(number)")
                .font(.caption.weight(.heavy))
                .foregroundStyle(.white)
                .frame(width: 24, height: 24)
                .background(AppTheme.forestGreen)
                .clipShape(Circle())
            TextField(placeholder, text: $text)
                .font(.subheadline.weight(.medium))
        }
        .padding(12)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 10))
    }
}

private struct PracticeTip: View {
    let text: String
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "lightbulb.fill")
                .font(.caption2)
                .foregroundStyle(AppTheme.gold)
                .padding(.top, 2)
            Text(text)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.primary.opacity(0.8))
        }
    }
}
