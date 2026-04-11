import SwiftUI

struct TransitionJournalView: View {
    let storage: StorageService
    @State private var currentPrompt: String = ""
    @State private var responseText: String = ""
    @State private var showNewEntry: Bool = false

    private let prompts = [
        "What's one thing you're proud of today?",
        "What's your biggest worry right now about transition?",
        "What did you learn about civilian life this week?",
        "Who helped you this week, and how?",
        "What's one thing you'd tell yourself 6 months ago?",
        "What does a successful day look like for you now?",
        "What's something you miss about service? What don't you miss?",
        "What's one new skill you want to develop this month?",
        "How are you feeling about your financial situation right now?",
        "What's one connection you made this week that could help your career?",
        "What's the hardest part of transition right now?",
        "What are you most excited about for your civilian future?",
        "What would you do differently if you were starting transition over?",
        "How did you take care of yourself today?",
        "What's one goal you're closer to achieving than last week?",
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerCard

                if showNewEntry {
                    newEntrySection
                } else {
                    Button {
                        currentPrompt = prompts.randomElement() ?? prompts[0]
                        withAnimation(.spring(response: 0.3)) { showNewEntry = true }
                    } label: {
                        Label("New Journal Entry", systemImage: "plus.circle.fill")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(AppTheme.forestGreen)
                            .clipShape(.rect(cornerRadius: 14))
                    }
                }

                if !storage.journalEntries.isEmpty {
                    pastEntriesSection
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Transition Journal")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "book.fill")
                    .foregroundStyle(.purple)
                Text("Your Private Space")
                    .font(.subheadline.weight(.bold))
            }
            Text("Journaling helps you process the transition. Entries are stored on your device only — completely private. Take a few minutes to reflect.")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.primary.opacity(0.8))

            HStack(spacing: 16) {
                VStack(spacing: 2) {
                    Text("\(storage.journalEntries.count)")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.purple)
                    Text("entries")
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(.primary.opacity(0.5))
                }
                if let last = storage.journalEntries.first {
                    VStack(spacing: 2) {
                        Text(last.date, format: .dateTime.month(.abbreviated).day())
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.purple)
                        Text("last entry")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(.primary.opacity(0.5))
                    }
                }
            }
            .padding(.top, 4)
        }
        .padding(14)
        .background(.purple.opacity(0.06))
        .clipShape(.rect(cornerRadius: 14))
    }

    private var newEntrySection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Today's Prompt")
                    .font(.headline.weight(.bold))
                Spacer()
                Button {
                    currentPrompt = prompts.randomElement() ?? prompts[0]
                } label: {
                    Label("New Prompt", systemImage: "arrow.clockwise")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.purple)
                }
            }

            Text(currentPrompt)
                .font(.title3.weight(.bold))
                .foregroundStyle(.purple)
                .fixedSize(horizontal: false, vertical: true)

            TextEditor(text: $responseText)
                .font(.body)
                .frame(minHeight: 150)
                .scrollContentBackground(.hidden)
                .padding(12)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(.rect(cornerRadius: 12))

            HStack(spacing: 12) {
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        showNewEntry = false
                        responseText = ""
                    }
                } label: {
                    Text("Cancel")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.primary.opacity(0.6))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(.rect(cornerRadius: 12))
                }

                Button {
                    guard !responseText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
                    let entry = JournalEntry(prompt: currentPrompt, response: responseText)
                    storage.addJournalEntry(entry)
                    withAnimation(.spring(response: 0.3)) {
                        showNewEntry = false
                        responseText = ""
                    }
                } label: {
                    Text("Save Entry")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(responseText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .gray : AppTheme.forestGreen)
                        .clipShape(.rect(cornerRadius: 12))
                }
                .disabled(responseText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .transition(.move(edge: .top).combined(with: .opacity))
    }

    private var pastEntriesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Past Entries")
                .font(.headline.weight(.bold))

            ForEach(storage.journalEntries.prefix(20)) { entry in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(entry.date, format: .dateTime.month(.abbreviated).day().year())
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.purple)
                        Spacer()
                        Text(entry.date, format: .dateTime.weekday(.wide))
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(.primary.opacity(0.4))
                    }

                    Text(entry.prompt)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.primary.opacity(0.6))
                        .italic()

                    Text(entry.response)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.primary.opacity(0.8))
                        .lineLimit(4)
                }
                .padding(14)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(.rect(cornerRadius: 12))
            }
        }
    }
}
