import Foundation
@testable import LanguageBuddy

class FakeOpenAIClient: OpenAIClientable {
    var sendChatRequest_calledCount = 0
    var sendChatRequest_paramModel: Model?
    var sendChatRequest_paramMessages = [Message]()
    var sendChatRequest_returnResults = [ChatResult]()
    func sendChatRequest(model: Model,
                         messages: [LanguageBuddy.Message],
                         urlSession: URLSessionable) async -> ChatResult {
        sendChatRequest_paramModel = model
        sendChatRequest_paramMessages = messages
        
        let result = sendChatRequest_returnResults[sendChatRequest_calledCount]
        
        sendChatRequest_calledCount += 1
        
        return result
    }
}
