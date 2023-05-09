import Foundation

struct Usage {
    let promptTokens, completionTokens, totalTokens: Int
}

extension Usage: Codable {
    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}
