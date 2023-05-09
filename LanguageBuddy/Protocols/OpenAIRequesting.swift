import Foundation

protocol OpenAIRequesting {
    func createChatCompletionRequest(messages: [Message]) -> URLRequest
}
