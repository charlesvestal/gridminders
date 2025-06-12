import EventKit
import Combine

final class ReminderFetcher: ObservableObject {
    @Published private(set) var reminders: [EKReminder] = []
    private let store = EKEventStore()
    private var changeCancellable: AnyCancellable?

    init() {
        changeCancellable = NotificationCenter.default.publisher(for: .EKEventStoreChanged, object: nil)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.store.reset()
                self.loadReminders()
            }
    }

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
                let incomplete = reminders?.filter { !$0.isCompleted } ?? []
                self.reminders = incomplete
            }
        }
    }

    func complete(_ reminder: EKReminder) {
        reminder.isCompleted = true
        do {
            try store.save(reminder, commit: true)
            loadReminders()
        } catch {
            print("Failed to complete reminder", error)
        }
    }

    /// Update a reminder's importance and urgency based on drag and drop.
    /// - Parameters:
    ///   - reminder: The reminder to modify.
    ///   - important: If true, the reminder is given the highest priority.
    ///   - urgent: If true, the reminder is assigned a due date of today.
    func modify(_ reminder: EKReminder, important: Bool, urgent: Bool) {
        if important {
            reminder.priority = 1
        }

        if urgent {
            let comps = Calendar.current.dateComponents([.year, .month, .day], from: Date())
            reminder.dueDateComponents = comps
        }

        do {
            try store.save(reminder, commit: true)
            loadReminders()
        } catch {
            print("Failed to modify reminder", error)
        }
    }
}
