import Foundation

protocol MessageCreatable {
    func messagesForPrompt(_ prompt: String) -> [Message]
}
