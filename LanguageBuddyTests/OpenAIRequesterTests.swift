import XCTest
@testable import LanguageBuddy

final class OpenAIRequesterTests: XCTestCase {
    func test_openAIRequester() {
        let testObject = OpenAIRequester()
        
        let role = Role.allCases.randomElement()!
        let prompt = UUID().uuidString
        let name = UUID().uuidString
        let message = Message(role: role, content: prompt, name: name)
        let request = testObject.createChatCompletionRequest(messages: [message])
        
        XCTAssertEqual(request.url?.absoluteString,
                       "https://api.openai.com/v1/chat/completions")
        XCTAssertEqual(request.httpMethod, "POST")
        let expectedHeaderKeys = ["Authorization", "Content-Type"]
        let actualHeaderKeys = Array(request.allHTTPHeaderFields!.keys)
        XCTAssertEqual(actualHeaderKeys, expectedHeaderKeys)
        
        let chatRequest: ChatCompletionRequest = try! JSONDecoder().decode(ChatCompletionRequest.self, from: request.httpBody!)
        XCTAssertEqual(chatRequest.model, testObject.defaultModel)
        XCTAssertEqual(chatRequest.temperature, testObject.defaultTemperature)
        XCTAssertEqual(chatRequest.messages.count, 1)
        XCTAssertEqual(chatRequest.messages[0].content, prompt)
    }
    
}
