import Foundation

struct OpenAIErrorResponse {
    let error: OpenAIErrorDetails
}

extension OpenAIErrorResponse: Codable {}
