import Foundation
@testable import LanguageBuddy

extension ChatResult {
    static func successResult(message: Message) -> ChatResult {
        return .success(ChatResponse.random(with: message))
    }
    
    static var failureResult: ChatResult {
        return .failure(.decodingError(NSError(domain: UUID().uuidString,
                                               code: Int.random)))
    }

}
