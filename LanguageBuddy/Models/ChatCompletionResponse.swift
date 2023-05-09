import Foundation

struct ChatCompletionResponse {
    let id, object: String
    let created: Int
    let choices: [Choice]
    let usage: Usage
}

extension ChatCompletionResponse: Codable {}
