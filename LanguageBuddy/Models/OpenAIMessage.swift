import Foundation

struct OpenAIMessage {
    let role: Role
    let content: String
    let name: String?
}

extension OpenAIMessage: Codable {}

extension OpenAIMessage {
    init(message: Message) {
        self.role = message.role
        self.content = message.content
        self.name = message.name
    }
}
