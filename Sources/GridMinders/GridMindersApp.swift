import SwiftUI
import EventKit

@main
struct GridMindersApp: App {
    @StateObject private var fetcher = ReminderFetcher()

    var body: some Scene {
        WindowGroup {
            ReminderGridView(fetcher: fetcher)
                .onAppear {
                    fetcher.requestAccess()
                }
        }
    }
}
