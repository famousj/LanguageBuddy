import Foundation

typealias ChatResult = Result<ChatResponse, OpenAIError>
protocol OpenAIClientable {
    func sendChatRequest(model: Model,
                         messages: [Message],
                         urlSession: URLSessionable) async -> ChatResult
}

extension OpenAIClientable {
    func sendChatRequest(model: Model,
                         messages: [Message]) async -> ChatResult {
        return await sendChatRequest(model: model,
                                     messages: messages,
                                     urlSession: URLSession.shared)
    }
}
