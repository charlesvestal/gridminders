import EventKit
import Combine

final class ReminderFetcher: ObservableObject {
    @Published private(set) var reminders: [EKReminder] = []
    private let store = EKEventStore()
    private var changeCancellable: AnyCancellable?

    init() {
        changeCancellable = NotificationCenter.default.publisher(for: .EKEventStoreChanged, object: store)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.loadReminders()
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
                self.reminders = reminders ?? []
            }
        }
    }
}
