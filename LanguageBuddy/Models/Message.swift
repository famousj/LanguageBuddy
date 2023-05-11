import Foundation

struct Message {
    let id: UUID
    let role: Role
    let content: String
    let name: String?
}

extension Message: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.role = try container.decode(Role.self, forKey: .role)
        self.content = try container.decode(String.self, forKey: .content)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
    }
}

extension Message: Identifiable {}
extension Message: Hashable {}

extension Message {
    init(role: Role, content: String, name: String? = nil) {
        self.id = UUID()
        self.role = role
        self.content = content
        self.name = name
    }
}

extension Message {
    private static let thinkingText = "..."
    static var assistantThinking: Message {
        Message(role: .assistant, content: thinkingText)
    }
    
    var isAssistantThinking: Bool {
        role == .assistant && content == Message.thinkingText
    }
}
