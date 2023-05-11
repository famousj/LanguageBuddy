import XCTest
@testable import LanguageBuddy

final class OpenAIClientTests: XCTestCase {
    func test_sendChatRequest_usesCorrectRequest() async throws {
        let testObject = OpenAIClient()
        
        let session = FakeURLSession()
        session.data_returnData = Data()
        session.data_returnURLResponse = URLResponse()
        
        let messageCount = Int.random(in: 5..<20)
        let messages = Array(0..<messageCount).map { _ in Message.random }
        let _ = await testObject.sendChatRequest(messages: messages,
                                                 urlSession: session)
        
        XCTAssertEqual(session.data_calledCount, 1)
        
        let request = session.data_paramRequest
        
        let headerFields = request?.allHTTPHeaderFields!
        let actualHeaderKeys = Array(headerFields!.keys)
        let expectedHeaderKeys = ["Authorization", "Content-Type"]
        XCTAssertEqual(actualHeaderKeys, expectedHeaderKeys)
        
        let requestBody: Data = (request?.httpBody)!
        let actualChatRequest = try JSONDecoder().decode(ChatRequest.self, from: requestBody)
        
        XCTAssertEqual(actualChatRequest.model, testObject.defaultModel)
        
        let expectedMessages = messages
            .map { OpenAIMessage(message: $0) }
        
        let actualMessages = actualChatRequest.messages
        XCTAssertEqual(actualMessages.count, expectedMessages.count)
        for (i, actualMessage) in actualMessages.enumerated() {
            XCTAssertEqual(actualMessage, expectedMessages[i])
        }
    }
}
