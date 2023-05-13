import Foundation

protocol MessageCreatable {
    func messagesForPrompt(_ prompt: String) -> [Message]
    func messagesForLanguageLookup(_ message: Message) -> [Message]
}
