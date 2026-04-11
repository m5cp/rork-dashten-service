import SwiftUI

struct MentorTrackerView: View {
    let storage: StorageService
    @State private var showAddMentor: Bool = false
    @State private var newName: String = ""
    @State private var newRole: String = ""
    @State private var newIndustry: String = ""
    @State private var newNotes: String = ""

    private let tips = [
        "Identify 2-3 mentors in your target career field",
        "Prepare specific questions before each conversation",
        "Follow up with a thank-you message within 24 hours",
        "Update your mentors on your progress quarterly",
        "Ask mentors for introductions to their network",
    ]

    private let conversationStarters = [
        "What do you wish you knew when transitioning from the military?",
        "What skills from my background would be most valued in your industry?",
        "What certifications or training would make me more competitive?",
        "How did you build your professional network?",
        "What's the biggest misconception people have about this career field?",
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Mentors are consistently cited as one of the most important factors in a successful transition. Build your network intentionally.")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary.opacity(0.8))
                }
                .padding(14)
                .background(AppTheme.forestGreen.opacity(0.06))
                .clipShape(.rect(cornerRadius: 12))

                mentorTipsSection
                conversationStartersSection
                mentorListSection
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Mentor Tracker")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showAddMentor = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundStyle(AppTheme.forestGreen)
                }
            }
        }
        .sheet(isPresented: $showAddMentor) {
            addMentorSheet
        }
    }

    private var mentorTipsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader("Mentorship Tips", icon: "lightbulb.fill")
            CardView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(tips, id: \.self) { tip in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.caption)
                                .foregroundStyle(AppTheme.forestGreen)
                                .padding(.top, 2)
                            Text(tip)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.primary.opacity(0.8))
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    private var conversationStartersSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader("Conversation Starters", icon: "bubble.left.fill")
            CardView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(conversationStarters, id: \.self) { starter in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "quote.opening")
                                .font(.caption2)
                                .foregroundStyle(AppTheme.gold)
                                .padding(.top, 2)
                            Text(starter)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.primary.opacity(0.8))
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    private var mentorListSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader("Your Mentors", icon: "person.2.fill")

            if storage.mentors.isEmpty {
                CardView {
                    VStack(spacing: 12) {
                        Image(systemName: "person.badge.plus")
                            .font(.title)
                            .foregroundStyle(.primary.opacity(0.3))
                        Text("No mentors added yet")
                            .font(.subheadline.weight(.bold))
                        Text("Tap + to add your first mentor contact")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.primary.opacity(0.6))
                    }
                    .frame(maxWidth: .infinity)
                }
            } else {
                VStack(spacing: 8) {
                    ForEach(storage.mentors) { mentor in
                        MentorCard(mentor: mentor, onContact: {
                            storage.updateMentorLastContact(mentor.id)
                        }, onDelete: {
                            withAnimation(.spring(response: 0.3)) {
                                storage.removeMentor(mentor.id)
                            }
                        })
                    }
                }
            }
        }
    }

    private var addMentorSheet: some View {
        NavigationStack {
            Form {
                Section("Contact Info") {
                    TextField("Name", text: $newName)
                        .font(.body.weight(.semibold))
                    TextField("Role / Title", text: $newRole)
                        .font(.body.weight(.semibold))
                    TextField("Industry", text: $newIndustry)
                        .font(.body.weight(.semibold))
                }
                Section("Notes") {
                    TextField("How did you connect? What to discuss?", text: $newNotes, axis: .vertical)
                        .font(.body.weight(.semibold))
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Add Mentor")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showAddMentor = false
                        clearForm()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let mentor = MentorContact(
                            name: newName.trimmingCharacters(in: .whitespaces),
                            role: newRole.trimmingCharacters(in: .whitespaces),
                            industry: newIndustry.trimmingCharacters(in: .whitespaces),
                            notes: newNotes.trimmingCharacters(in: .whitespaces)
                        )
                        storage.addMentor(mentor)
                        showAddMentor = false
                        clearForm()
                    }
                    .disabled(newName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
        .presentationDetents([.medium])
    }

    private func clearForm() {
        newName = ""
        newRole = ""
        newIndustry = ""
        newNotes = ""
    }
}

struct MentorCard: View {
    let mentor: MentorContact
    let onContact: () -> Void
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(AppTheme.forestGreen.opacity(0.12))
                        .frame(width: 40, height: 40)
                    Text(String(mentor.name.prefix(1)).uppercased())
                        .font(.headline.weight(.bold))
                        .foregroundStyle(AppTheme.forestGreen)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(mentor.name)
                        .font(.subheadline.weight(.bold))
                    if !mentor.role.isEmpty {
                        Text(mentor.role)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.primary.opacity(0.7))
                    }
                }

                Spacer()

                if !mentor.industry.isEmpty {
                    StatusBadge(text: mentor.industry, color: .teal)
                }
            }

            if !mentor.notes.isEmpty {
                Text(mentor.notes)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary.opacity(0.7))
            }

            HStack(spacing: 10) {
                if let lastContact = mentor.lastContactDate {
                    Text("Last contact: \(lastContact, format: .dateTime.month(.abbreviated).day())")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.primary.opacity(0.5))
                }

                Spacer()

                Button {
                    onContact()
                } label: {
                    Label("Log Contact", systemImage: "phone.fill")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(AppTheme.forestGreen)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(AppTheme.forestGreen.opacity(0.12))
                        .clipShape(Capsule())
                }

                Button(role: .destructive) {
                    onDelete()
                } label: {
                    Image(systemName: "trash")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.red.opacity(0.7))
                }
            }
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 14))
    }
}
