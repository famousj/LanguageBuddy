import Foundation

enum OpenAIError: Error {
    case serverError(OpenAIErrorDetails)
    case decodingError(Error)
    case genericError(Error)
}
