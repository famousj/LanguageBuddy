import Foundation

struct MessageCreator: MessageCreatable {
    let language: String
    
    var languageIntroduction: String {
        "I am learning \(language)"
    }
    
    private var promptSetupMessages: [Message] {
        [Message(role: .user, content: languageIntroduction)]
    }
    
    func messagesForPrompt(_ prompt: String) -> [Message] {
        promptSetupMessages + [Message(role: .user, content: prompt)]
    }
}
