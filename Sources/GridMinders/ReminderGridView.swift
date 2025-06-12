import SwiftUI
import EventKit

struct ReminderGridView: View {
    var reminders: [EKReminder]

    private func categorize(_ reminder: EKReminder) -> (important: Bool, urgent: Bool) {
        let important = reminder.isFlagged || reminder.priority == 1
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
        let q1 = reminders.filter { quadrant($0) == 1 }
        let q2 = reminders.filter { quadrant($0) == 2 }
        let q3 = reminders.filter { quadrant($0) == 3 }
        let q4 = reminders.filter { quadrant($0) == 4 }

        return VStack {
            HStack {
                quadrantView(title: "Important & Urgent", reminders: q1)
                quadrantView(title: "Important & Not Urgent", reminders: q2)
            }
            HStack {
                quadrantView(title: "Not Important & Urgent", reminders: q3)
                quadrantView(title: "Not Important & Not Urgent", reminders: q4)
            }
        }
        .padding()
    }

    private func quadrantView(title: String, reminders: [EKReminder]) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            List(reminders, id: \.calendarItemIdentifier) { reminder in
                Text(reminder.title)
            }
        }
        .frame(maxWidth: .infinity)
        .border(Color.gray)
    }
}
