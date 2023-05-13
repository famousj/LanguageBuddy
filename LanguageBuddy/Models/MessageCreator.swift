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
    
    func messagesForLanguageLookup(_ message: Message) -> [Message] {
        let content = "List the phrases in this message that are \(language):\n\(message.content)"
        return [Message(role: .user, content: content)]
    }
}
