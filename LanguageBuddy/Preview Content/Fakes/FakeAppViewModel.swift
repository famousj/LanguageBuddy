import Foundation

class FakeAppViewModel: AppViewModeling {
    var appState: AppState = .notLoggedIn
    
    var messages: [Message] {
        Array(0...100)
            .map { Message(role: Role.allCases.randomElement()!, content: "\($0)", name: nil) }
    }
    
    func loginRequested() {}
    
}
