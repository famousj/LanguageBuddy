import Foundation

class AppViewModel: ObservableObject, AppViewModeling {
    @Published var messages = [Message]()
    @Published var appState: AppState = .notLoggedIn
    
    
}
