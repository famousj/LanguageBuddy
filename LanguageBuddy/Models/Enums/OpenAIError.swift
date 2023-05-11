import Foundation

enum OpenAIError: Error {
    case serverError(OpenAIErrorDetails)
    case decodingError(Error)
    case genericError(Error)
}

extension OpenAIError: LocalizedError {
    var errorDescription: String? {
        var message: String
        switch self {
        case .serverError(let details):
            message = details.message
        case .decodingError(let error):
            message = error.localizedDescription
        case .genericError(let error):
            message = error.localizedDescription
        }
        return "Error connecting to ChatGPT: \(message)"
    }
}
