import Foundation

struct Choice {
    let index: Int
    let message: Message
    let finishReason: String
}

extension Choice: Codable {
    enum CodingKeys: String, CodingKey {
        case index, message
        case finishReason = "finish_reason"
    }
}
