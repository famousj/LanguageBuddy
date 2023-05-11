import Foundation

enum OpenAIError: LocalizedError {
    case serverError(OpenAIErrorDetails)
    case decodingError(Error)
    case genericError(Error)
}
