import SwiftUI

@main
struct LanguageBuddyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(appViewModel: AppViewModel())
        }
    }
}
