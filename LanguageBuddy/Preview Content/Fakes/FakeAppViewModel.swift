import Foundation

class FakeAppViewModel: AppViewModelable {
    @Published var showChatError: Bool = false
    var chatError: OpenAIError?
    
    @Published var messages = Array(0...100)
        .map { Message(role: Role.allCases.randomElement()!, content: "\($0)") }
    
    @Published var currentPrompt = "Here's what's on my mind.  Lots and lots.  Plenty of things."
    
    func newPrompt() {
        messages.append(Message(role: .user, content: currentPrompt))
        currentPrompt = ""
    }
}
