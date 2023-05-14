import Foundation
@testable import LanguageBuddy

class FakeOpenAIClient: OpenAIClientable {
    var sendChatRequest_calledCount = 0
    var sendChatRequest_paramModel: Model?
    var sendChatRequest_paramMessages = [Message]()
    var sendChatRequest_returnResult: ChatResult?
    func sendChatRequest(model: Model,
                         messages: [LanguageBuddy.Message],
                         urlSession: URLSessionable) async -> ChatResult {
        sendChatRequest_calledCount += 1
        sendChatRequest_paramModel = model
        sendChatRequest_paramMessages = messages
        
        return sendChatRequest_returnResult!
    }
}
