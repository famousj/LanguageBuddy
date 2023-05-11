import Foundation

typealias ChatResult = Result<ChatResponse, OpenAIError>
protocol OpenAIClientable {
    func sendChatRequest(messages: [Message],
                         urlSession: URLSessionable) async -> ChatResult
}

extension OpenAIClientable {
    func sendChatRequest(messages: [Message]) async -> ChatResult {
        return await sendChatRequest(messages: messages, urlSession: URLSession.shared)
    }
}
