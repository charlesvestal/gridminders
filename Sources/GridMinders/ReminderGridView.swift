import SwiftUI
import EventKit
import AppKit
import UniformTypeIdentifiers

struct ReminderGridView: View {
    @ObservedObject var fetcher: ReminderFetcher

    private func categorize(_ reminder: EKReminder) -> (important: Bool, urgent: Bool) {
        // EventKit does not expose the "flagged" state, so we only
        // treat reminders with the highest priority as important.
        let important = reminder.priority == 1
        var urgent = false
        if let due = reminder.dueDateComponents?.date {
            urgent = Calendar.current.isDateInToday(due) || due < Date().addingTimeInterval(24*60*60)
        }
        return (important, urgent)
    }

    private func quadrant(_ reminder: EKReminder) -> Int {
        let result = categorize(reminder)
        switch (result.important, result.urgent) {
        case (true, true): return 1
        case (true, false): return 2
        case (false, true): return 3
        default: return 4
        }
    }

    var body: some View {
        let list = fetcher.reminders
        let q1 = list.filter { quadrant($0) == 1 }
        let q2 = list.filter { quadrant($0) == 2 }
        let q3 = list.filter { quadrant($0) == 3 }
        let q4 = list.filter { quadrant($0) == 4 }

        return VStack {
            HStack {
                quadrantView(title: "Important & Urgent", reminders: q1, important: true, urgent: true)
                quadrantView(title: "Important & Not Urgent", reminders: q2, important: true, urgent: false)
            }
            HStack {
                quadrantView(title: "Not Important & Urgent", reminders: q3, important: false, urgent: true)
                quadrantView(title: "Not Important & Not Urgent", reminders: q4, important: false, urgent: false)
            }
        }
        .padding()
    }

    private func quadrantView(title: String, reminders: [EKReminder], important: Bool, urgent: Bool) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            List(reminders, id: \.calendarItemIdentifier) { reminder in
                HStack {
                    Button(action: {
                        fetcher.complete(reminder)
                    }) {
                        Image(systemName: "checkmark.circle")
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    Text(reminder.title)
                        .onDrag {
                            NSItemProvider(object: reminder.calendarItemIdentifier as NSString)
                        }
                }
                .onTapGesture(count: 2) {
                    if let url = URL(string: "x-apple-reminder://\(reminder.calendarItemIdentifier)") {
                        NSWorkspace.shared.open(url)
                    }
                }
            }
            .onDrop(of: [UTType.text], isTargeted: nil) { providers in
                handleDrop(providers: providers, important: important, urgent: urgent)
            }
        }
        .frame(maxWidth: .infinity)
        .border(Color.gray)
    }

    private func handleDrop(providers: [NSItemProvider], important: Bool, urgent: Bool) -> Bool {
        for provider in providers {
            _ = provider.loadObject(ofClass: NSString.self) { object, _ in
                guard let id = object as String? else { return }
                DispatchQueue.main.async {
                    if let reminder = fetcher.reminders.first(where: { $0.calendarItemIdentifier == id }) {
                        fetcher.modify(reminder, important: important, urgent: urgent)
                    }
                }
            }
        }
        return true
    }
}
