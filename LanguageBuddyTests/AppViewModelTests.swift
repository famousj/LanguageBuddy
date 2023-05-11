import XCTest
@testable import LanguageBuddy

final class AppViewModelTests: XCTestCase {
    private let sleepDuration = Duration.seconds(0.2)
    func test_doesNotRetain() async throws {
        var client: FakeOpenAIClient? = FakeOpenAIClient()
        var testObject: AppViewModel? = AppViewModel(openAIClient: client!)
        
        testObject?.currentPrompt = String.random
        client?.sendChatRequest_returnResult = failureResult

        testObject?.newPrompt()
        
        try await Task.sleep(for: sleepDuration)
                
        weak var weakTestObject = testObject
        testObject = nil
        client = nil
        XCTAssertNil(weakTestObject)
    }
    
    func test_newPrompt_addsNewMessage() {
        let testObject = AppViewModel(openAIClient: emptyClient)
        
        XCTAssertEqual(testObject.messages.count, 0)
        
        let prompt = String.random
        testObject.currentPrompt = prompt
        testObject.newPrompt()
        
        XCTAssertEqual(testObject.messages.count, 1)
        
        let message = testObject.messages.first
        let expectedMessage = Message(role: .user, content: prompt)
        expectedMessage.assertEqual(to: message)
    }
    
    func test_newPrompt_clearsCurrentPrompt() {
        let testObject = AppViewModel(openAIClient: emptyClient)

        testObject.currentPrompt = String.random
        
        testObject.newPrompt()
        
        XCTAssertEqual(testObject.currentPrompt, "")
    }
    
    func test_newPrompt_whenCurrentPromptIsEmpty_noAction() async throws {
        let client = FakeOpenAIClient()
        let testObject = AppViewModel(openAIClient: client)

        testObject.currentPrompt = ""
        
        testObject.newPrompt()
        
        try await Task.sleep(for: sleepDuration)
        
        XCTAssertEqual(testObject.messages.count, 0)
        XCTAssertEqual(client.sendChatRequest_calledCount, 0)
    }
    
    func test_newPrompt_sendsMessagesToClient() async throws {
        let client = FakeOpenAIClient()
        let language = UUID().uuidString
        let testObject = AppViewModel(openAIClient: client,
                                      language: language)

        let prompt = String.random
        testObject.currentPrompt = prompt
        
        client.sendChatRequest_returnResult = failureResult
        
        testObject.newPrompt()
        
        try await Task.sleep(for: sleepDuration)
        
        XCTAssertEqual(client.sendChatRequest_calledCount, 1)
        
        let expectedMessages = MessageCreator(language: language).messagesForPrompt(prompt)

        client.sendChatRequest_paramMessages?.assertEqual(to: expectedMessages)
    }
    
    func test_newPrompt_whenChatFails_displaysError() async throws {
        let client = FakeOpenAIClient()
        let testObject = AppViewModel(openAIClient: client)

        testObject.currentPrompt = String.random
        
        XCTAssertEqual(testObject.showChatError, false)

        let expectedDetails = OpenAIErrorDetails(message: String.random,
                                              type: "",
                                              param: nil,
                                              code: nil)
        let expectedError = OpenAIError.serverError(expectedDetails)
        client.sendChatRequest_returnResult = .failure(expectedError)
        
        testObject.newPrompt()
        
        try await Task.sleep(for: sleepDuration)

        XCTAssertEqual(testObject.showChatError, true)
        
        XCTAssertEqual(testObject.chatError?.localizedDescription,
                       expectedError.localizedDescription)
    }
    
    func test_newPrompt_addsSuccessfulMessageToList() async throws {
        let client = FakeOpenAIClient()
        let language = UUID().uuidString
        let testObject = AppViewModel(openAIClient: client,
                                      language: language)

        let prompt = String.random
        testObject.currentPrompt = prompt
        
        let newMessage = Message.random
        client.sendChatRequest_returnResult = successfulResult(message: newMessage)
        
        testObject.newPrompt()
        
        try await Task.sleep(for: sleepDuration)
        
        XCTAssertEqual(testObject.messages.count, 2)
        XCTAssertEqual(testObject.messages.last, newMessage)
    }
    
    private func successfulResult(message: Message) -> ChatResult {
        let choice = Choice(index: 0,
                            message: message,
                            finishReason: "")
        let usage = Usage(promptTokens: 0,
                          completionTokens: 0,
                          totalTokens: 0)
        let response = ChatResponse(id: "",
                            object: "",
                            created: 0,
                            choices: [choice],
                            usage: usage)
        return .success(response)
    }
    
    private var failureResult: ChatResult {
        return .failure(.decodingError(NSError(domain: "", code: 0)))
    }
    
    private var emptyClient: FakeOpenAIClient {
        let client = FakeOpenAIClient()
        client.sendChatRequest_returnResult = failureResult
        return client
    }
}

fileprivate extension FakeURLSession {
}
