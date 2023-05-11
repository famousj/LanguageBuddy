import XCTest
@testable import LanguageBuddy

final class OpenAIClientTests: XCTestCase {
    func test_sendChatRequest_usesCorrectRequest() async throws {
        let testObject = OpenAIClient()
        
        let session = FakeURLSession()
        session.data_returnData = Data()
        session.data_returnURLResponse = URLResponse()
        
        let model = Model.allCases.randomElement()!
        let messageCount = Int.random(in: 5..<20)
        let messages = Array(0..<messageCount).map { _ in Message.random }
        let _ = await testObject.sendChatRequest(model: model,
                                                 messages: messages,
                                                 urlSession: session)
        
        XCTAssertEqual(session.data_calledCount, 1)
        
        let request = session.data_paramRequest
        
        let headerFields = request?.allHTTPHeaderFields!
        let actualHeaderKeys = Array(headerFields!.keys)
        let expectedHeaderKeys = ["Authorization", "Content-Type"]
        XCTAssertEqual(actualHeaderKeys.sorted(),
                       expectedHeaderKeys.sorted())
        
        let requestBody: Data = (request?.httpBody)!
        let actualChatRequest = try JSONDecoder().decode(ChatRequest.self, from: requestBody)
        
        XCTAssertEqual(actualChatRequest.model, model.rawValue)
        
        let expectedMessages = messages
            .map { OpenAIMessage(message: $0) }
        
        let actualMessages = actualChatRequest.messages
        XCTAssertEqual(actualMessages.count, expectedMessages.count)
        for (i, actualMessage) in actualMessages.enumerated() {
            XCTAssertEqual(actualMessage, expectedMessages[i])
        }
    }
    
    func test_sendChatRequest_passesThroughError() async throws {
        let testObject = OpenAIClient()
        
        let session = FakeURLSession()
        let expectedError = OpenAIErrorDetails(message: String.random,
                                               type: UUID().uuidString,
                                               param: nil,
                                               code: UUID().uuidString)
        let errorResponse = OpenAIErrorResponse(error: expectedError)
        session.data_returnData = try JSONEncoder().encode(errorResponse)
        session.data_returnURLResponse = URLResponse()
        
        let result = await testObject.sendChatRequest(model: .gpt3,
                                                      messages: [],
                                                      urlSession: session)
        guard case .failure(let error) = result,
              case .serverError(let serverError) = error else {
            XCTFail("Should have returned a server error result!")
            return
        }
        
        XCTAssertEqual(serverError, expectedError)
    }
    
    func test_sendChatRequest_whenDecodingFails_sendsParseError() async throws {
        let testObject = OpenAIClient()
        
        let session = FakeURLSession()
        let notChatResponse = Message.random
        session.data_returnData = try JSONEncoder().encode(notChatResponse)
        session.data_returnURLResponse = URLResponse()
        
        let result = await testObject.sendChatRequest(model: .gpt4,
                                                      messages: [],
                                                      urlSession: session)
        guard case .failure(let error) = result,
              case .decodingError = error else {
            XCTFail("Should have returned a decoding error result!")
            return
        }
    }
    
    func test_sendChatRequest_sendsSuccessWhenItWorks() async throws {
        let testObject = OpenAIClient()
        
        let session = FakeURLSession()
        
        let expectedResponse = ChatResponse(id: UUID().uuidString,
                                            object: "",
                                            created: 0,
                                            choices: [],
                                            usage: Usage(promptTokens: 0,
                                                         completionTokens: 0,
                                                         totalTokens: 0))
        session.data_returnData = try JSONEncoder().encode(expectedResponse)
        session.data_returnURLResponse = URLResponse()
        
        let result = await testObject.sendChatRequest(model: .gpt3,
                                                      messages: [],
                                                      urlSession: session)
        guard case .success(let actualResponse) = result else {
            XCTFail("Should have returned a success!")
            return
        }
        XCTAssertEqual(actualResponse, expectedResponse)
    }
}
