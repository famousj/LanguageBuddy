import Foundation

struct OpenAIErrorDetails {
    let message, type: String
    let param, code: JSONNull?
}

extension OpenAIErrorDetails: Codable {}
