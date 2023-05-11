import Foundation

struct ChatResponse {
    let id, object: String
    let created: Int
    let choices: [Choice]
    let usage: Usage
}

extension ChatResponse: Codable {}
extension ChatResponse: Equatable {}
