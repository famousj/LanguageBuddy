import Foundation

struct MessageCreator: MessageCreatable {
    private var promptSetupMessages: [Message] {
        []
    }
    
    func messagesForPrompt(_ prompt: String) -> [Message] {
        promptSetupMessages + [Message(role: .user, content: prompt)]
    }
}
