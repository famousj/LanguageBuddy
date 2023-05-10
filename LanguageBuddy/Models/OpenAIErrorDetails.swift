import Foundation

struct OpenAIErrorDetails {
    let message, type: String
    let param: String?
    let code: String
}

extension OpenAIErrorDetails: Codable {}
