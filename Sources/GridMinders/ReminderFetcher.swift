import EventKit
import Combine

final class ReminderFetcher: ObservableObject {
    @Published private(set) var reminders: [EKReminder] = []
    private let store = EKEventStore()

    func requestAccess() {
        store.requestAccess(to: .reminder) { granted, _ in
            if granted {
                self.loadReminders()
            }
        }
    }

    private func loadReminders() {
        let predicate = store.predicateForReminders(in: nil)
        store.fetchReminders(matching: predicate) { reminders in
            DispatchQueue.main.async {
                self.reminders = reminders ?? []
            }
        }
    }
}
