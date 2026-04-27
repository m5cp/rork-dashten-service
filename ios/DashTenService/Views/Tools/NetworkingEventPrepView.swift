import SwiftUI

struct NetworkingEventPrepView: View {
    @Bindable var storage: StorageService
    @State private var showAddEvent: Bool = false
    @State private var selectedEvent: NetworkingEvent?

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if storage.networkingEvents.isEmpty {
                    emptyState
                } else {
                    upcomingSection
                    pastSection
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 100)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Event Prep")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { showAddEvent = true } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundStyle(AppTheme.forestGreen)
                }
                .accessibilityLabel("Add networking event")
            }
        }
        .sheet(isPresented: $showAddEvent) {
            AddNetworkingEventSheet(storage: storage)
        }
        .sheet(item: $selectedEvent) { event in
            EventDetailSheet(storage: storage, eventId: event.id)
        }
        .onAppear { storage.trackToolUsed("networking_event_prep") }
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.3.fill")
                .font(.system(size: 48))
                .foregroundStyle(AppTheme.forestGreen.opacity(0.3))
            Text("No Events Yet")
                .font(.title3.weight(.bold))
            Text("Prepare for networking events, career fairs, and informational interviews. Log your pitch, questions to ask, and follow-up actions.")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button { showAddEvent = true } label: {
                Label("Add Event", systemImage: "plus")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(AppTheme.forestGreen)
                    .clipShape(.rect(cornerRadius: 14))
            }
        }
        .padding(32)
    }

    private var upcomingSection: some View {
        let upcoming = storage.networkingEvents.filter { $0.eventDate >= Date() && !$0.isCompleted }.sorted { $0.eventDate < $1.eventDate }
        return Group {
            if !upcoming.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Upcoming")
                        .font(.headline.weight(.bold))
                    ForEach(upcoming) { event in
                        Button { selectedEvent = event } label: {
                            EventRow(event: event)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private var pastSection: some View {
        let past = storage.networkingEvents.filter { $0.eventDate < Date() || $0.isCompleted }.sorted { $0.eventDate > $1.eventDate }
        return Group {
            if !past.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Past Events")
                        .font(.headline.weight(.bold))
                    ForEach(past) { event in
                        Button { selectedEvent = event } label: {
                            EventRow(event: event)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}

private struct EventRow: View {
    let event: NetworkingEvent

    var body: some View {
        HStack(spacing: 14) {
            VStack(spacing: 2) {
                Text(event.eventDate.formatted(.dateTime.month(.abbreviated)))
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.secondary)
                Text(event.eventDate.formatted(.dateTime.day()))
                    .font(.title3.weight(.bold))
                    .foregroundStyle(AppTheme.forestGreen)
            }
            .frame(width: 44)

            VStack(alignment: .leading, spacing: 4) {
                Text(event.eventName)
                    .font(.subheadline.weight(.bold))
                HStack(spacing: 10) {
                    if !event.contactsLogged.isEmpty {
                        Label("\(event.contactsLogged.count) contacts", systemImage: "person.fill")
                            .font(.caption2.weight(.semibold))
                            .foregroundStyle(.secondary)
                    }
                    if !event.followUpActions.isEmpty {
                        Label("\(event.followUpActions.count) follow-ups", systemImage: "arrow.uturn.forward")
                            .font(.caption2.weight(.semibold))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            Spacer()
            if event.isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(AppTheme.forestGreen)
            }
            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(.tertiary)
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 14))
    }
}

struct AddNetworkingEventSheet: View {
    let storage: StorageService
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var date: Date = Date()

    var body: some View {
        NavigationStack {
            Form {
                TextField("Event Name", text: $name)
                DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
            }
            .navigationTitle("New Event")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let event = NetworkingEvent(eventName: name.trimmingCharacters(in: .whitespaces), eventDate: date)
                        storage.networkingEvents.append(event)
                        dismiss()
                    }
                    .font(.body.weight(.bold))
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
        .presentationDetents([.medium])
    }
}

struct EventDetailSheet: View {
    let storage: StorageService
    let eventId: String
    @Environment(\.dismiss) private var dismiss
    @State private var newQuestion: String = ""
    @State private var newContact: String = ""
    @State private var newFollowUp: String = ""

    private var eventIndex: Int? {
        storage.networkingEvents.firstIndex(where: { $0.id == eventId })
    }

    var body: some View {
        NavigationStack {
            Group {
                if let idx = eventIndex {
                    ScrollView {
                        VStack(spacing: 20) {
                            pitchSection(idx)
                            questionsSection(idx)
                            contactsSection(idx)
                            followUpSection(idx)

                            if !storage.networkingEvents[idx].isCompleted {
                                Button {
                                    storage.networkingEvents[idx].isCompleted = true
                                } label: {
                                    Text("Mark Event Complete")
                                        .font(.headline.weight(.bold))
                                        .foregroundStyle(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 14)
                                        .background(AppTheme.forestGreen)
                                        .clipShape(.rect(cornerRadius: 14))
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 40)
                    }
                } else {
                    ContentUnavailableView("Event not found", systemImage: "exclamationmark.triangle")
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(eventIndex.map { storage.networkingEvents[$0].eventName } ?? "Event")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .font(.body.weight(.bold))
                }
            }
        }
    }

    private func pitchSection(_ idx: Int) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Your Pitch")
                .font(.headline.weight(.bold))
            TextEditor(text: Binding(
                get: { storage.networkingEvents[idx].pitch },
                set: { storage.networkingEvents[idx].pitch = $0 }
            ))
            .font(.subheadline)
            .frame(minHeight: 80)
            .scrollContentBackground(.hidden)
            .padding(10)
            .background(Color(.tertiarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 10))
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 14))
    }

    private func questionsSection(_ idx: Int) -> some View {
        EventListSection(
            title: "Questions to Ask",
            icon: "questionmark.circle.fill",
            color: .blue,
            items: storage.networkingEvents[idx].questionsToAsk,
            newItemText: $newQuestion,
            placeholder: "Add a question...",
            onAdd: {
                guard !newQuestion.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                storage.networkingEvents[idx].questionsToAsk.append(newQuestion.trimmingCharacters(in: .whitespaces))
                newQuestion = ""
            },
            onDelete: { item in
                storage.networkingEvents[idx].questionsToAsk.removeAll { $0 == item }
            }
        )
    }

    private func contactsSection(_ idx: Int) -> some View {
        EventListSection(
            title: "Contacts Logged",
            icon: "person.fill",
            color: .purple,
            items: storage.networkingEvents[idx].contactsLogged,
            newItemText: $newContact,
            placeholder: "Add a contact...",
            onAdd: {
                guard !newContact.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                storage.networkingEvents[idx].contactsLogged.append(newContact.trimmingCharacters(in: .whitespaces))
                newContact = ""
            },
            onDelete: { item in
                storage.networkingEvents[idx].contactsLogged.removeAll { $0 == item }
            }
        )
    }

    private func followUpSection(_ idx: Int) -> some View {
        EventListSection(
            title: "Follow-Up Actions",
            icon: "arrow.uturn.forward.circle.fill",
            color: .teal,
            items: storage.networkingEvents[idx].followUpActions,
            newItemText: $newFollowUp,
            placeholder: "Add follow-up...",
            onAdd: {
                guard !newFollowUp.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                storage.networkingEvents[idx].followUpActions.append(newFollowUp.trimmingCharacters(in: .whitespaces))
                newFollowUp = ""
            },
            onDelete: { item in
                storage.networkingEvents[idx].followUpActions.removeAll { $0 == item }
            }
        )
    }
}

private struct EventListSection: View {
    let title: String
    let icon: String
    let color: Color
    let items: [String]
    @Binding var newItemText: String
    let placeholder: String
    let onAdd: () -> Void
    let onDelete: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(color)
                Text(title)
                    .font(.subheadline.weight(.bold))
                Spacer()
                Text("\(items.count)")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.tertiary)
            }

            ForEach(items, id: \.self) { item in
                HStack(spacing: 10) {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 5))
                        .foregroundStyle(color)
                    Text(item)
                        .font(.subheadline.weight(.medium))
                    Spacer()
                    Button { onDelete(item) } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    .accessibilityLabel("Remove item")
                }
            }

            HStack {
                TextField(placeholder, text: $newItemText)
                    .font(.subheadline)
                    .onSubmit { onAdd() }
                Button { onAdd() } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                        .foregroundStyle(color)
                }
                .disabled(newItemText.trimmingCharacters(in: .whitespaces).isEmpty)
                .accessibilityLabel("Add item")
            }
            .padding(10)
            .background(Color(.tertiarySystemGroupedBackground))
            .clipShape(.rect(cornerRadius: 10))
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(.rect(cornerRadius: 14))
    }
}
