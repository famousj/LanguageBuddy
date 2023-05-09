import Foundation
@testable import LanguageBuddy

class FakeOpenAIRequester: OpenAIRequesting {
    func createChatCompletionRequest(prompt: String) -> URLRequest {
        URLRequest(url: URL(string: "")!)
    }
}
