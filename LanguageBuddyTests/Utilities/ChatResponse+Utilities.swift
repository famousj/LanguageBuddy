import Foundation
@testable import LanguageBuddy

extension ChatResponse {
    static func random(with message: Message) -> ChatResponse {
        let choice = Choice(index: 0,
                            message: message,
                            finishReason: UUID().uuidString)
        let usage = Usage(promptTokens: Int.random,
                          completionTokens: Int.random,
                          totalTokens: Int.random)
        return ChatResponse(id: UUID().uuidString,
                            object: UUID().uuidString,
                            created: Int.random,
                            choices: [choice],
                            usage: usage)
    }
}
