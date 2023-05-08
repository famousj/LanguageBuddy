import Foundation

class AppViewModel: ObservableObject, AppViewModeling {
    @Published var messages = [Message]()
    @Published var appState: AppState = .notLoggedIn
    
    private let openAISession: OpenAISessioning
    
    init(openAISession: OpenAISessioning = OpenAISession()) {
        self.openAISession = openAISession
    }
    
    func loginRequested() {
        openAISession.loginRequested()
    }
}
