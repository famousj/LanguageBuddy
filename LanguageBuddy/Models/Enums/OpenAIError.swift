import Foundation

enum OpenAIError: Error {
    case serverError(String)
    case decodingError(String)
}
