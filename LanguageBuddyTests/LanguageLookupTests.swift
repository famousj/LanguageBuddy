import XCTest
@testable import LanguageBuddy

final class LanguageLookupTests: XCTestCase {
    func test_lookupPrompt_sendsMessagesToClient() async throws {
        let client = FakeOpenAIClient()
        let testObject = LanguageLookup(client: client)

        let model = Model.random
        let language = UUID().uuidString
        let prompt = String.random
        
        client.sendChatRequest_returnResults = [.failureResult]

        let _ = await testObject.lookupPrompt(model: model,
                                              language: language,
                                              prompt: prompt)

        try await Task.sleep(for: .SleepDuration)

        XCTAssertEqual(client.sendChatRequest_calledCount, 1)

        let expectedMessages = MessageCreator(language: language)
            .messagesForPrompt(prompt)

        expectedMessages.assertEqual(to: client.sendChatRequest_paramMessages)
    }
    
    func test_lookupPrompt_whenPromptRequestFails_returnsFailure() async throws {
        let client = FakeOpenAIClient()
        let testObject = LanguageLookup(client: client)

        let expectedDetails = OpenAIErrorDetails(message: String.random,
                                               type: UUID().uuidString,
                                               param: nil,
                                               code: nil)
        let expectedError = OpenAIError.serverError(expectedDetails)
        let expectedResult = ChatResult.failure(expectedError)
        client.sendChatRequest_returnResults = [expectedResult]

        let result = await testObject.lookupPrompt(model: Model.random,
                                                   language: UUID().uuidString,
                                                   prompt: String.random)
        
        guard case .failure(.serverError(let actualDetails)) = result else {
            XCTFail("Expected server error result.  Got: \(result)")
            return
        }
        XCTAssertEqual(actualDetails, expectedDetails)
    }
    
    func test_lookupPrompt_whenRequestSucceeds_returnsSuccess() async throws {
        let client = FakeOpenAIClient()
        let testObject = LanguageLookup(client: client)

        let expectedResponse = ChatResponse.random(with: Message.random)
        let expectedResult = ChatResult.success(expectedResponse)
        client.sendChatRequest_returnResults = [expectedResult]

        let result = await testObject.lookupPrompt(model: Model.random,
                                                   language: UUID().uuidString,
                                                   prompt: String.random)
        
        guard case .success(let actualResponse) = result else {
            XCTFail("Expected success result.  Got: \(result)")
            return
        }
        XCTAssertEqual(actualResponse, expectedResponse)
    }
}
