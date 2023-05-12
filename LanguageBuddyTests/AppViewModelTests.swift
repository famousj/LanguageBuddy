import XCTest
@testable import LanguageBuddy

final class AppViewModelTests: XCTestCase {
    private let sleepDuration = Duration.seconds(0.3)
    func test_doesNotRetain() async throws {
        var client: FakeOpenAIClient? = FakeOpenAIClient()
        var userSettingsStore: FakeUserSettingsStore? = FakeUserSettingsStore()
        var testObject: AppViewModel? = AppViewModel(openAIClient: client!,
                                                     userSettingsStore: userSettingsStore!)

        userSettingsStore?.load_returnUserSettings = UserSettings.random
        await testObject?.loadUserSettings()

        testObject?.currentPrompt = String.random
        client?.sendChatRequest_returnResult = failureResult

        testObject?.newPrompt()
        
        try await Task.sleep(for: sleepDuration)
                
        weak var weakTestObject = testObject
        testObject = nil
        client = nil
        userSettingsStore = nil
        XCTAssertNil(weakTestObject)
    }
    
    func test_loadUserSettings_callsStore() async {
        let userSettingsStore = FakeUserSettingsStore()
        let testObject = AppViewModel(userSettingsStore: userSettingsStore)
        
        let userSettings = UserSettings(language: UUID().uuidString,
                                        model: Model.allCases.randomElement()!)
        userSettingsStore.load_returnUserSettings = userSettings
        
        XCTAssertEqual(testObject.isPromptDisabled, true)
        
        await testObject.loadUserSettings()
        XCTAssertEqual(userSettingsStore.load_calledCount, 1)
        XCTAssertEqual(testObject.userSettings, userSettings)
        XCTAssertEqual(testObject.isPromptDisabled, false)
    }

    func test_loadUserSettings_onError_usesDefault() async {
        let userSettingsStore = FakeUserSettingsStore()
        let testObject = AppViewModel(userSettingsStore: userSettingsStore)
        
        userSettingsStore.load_error = NSError(domain: "", code: 0)
        
        await testObject.loadUserSettings()
        XCTAssertEqual(testObject.userSettings,
                       UserSettings.defaultSettings)
        XCTAssertEqual(testObject.isPromptDisabled, false)
    }
    
    func test_newPrompt_addsNewMessage() async {
        let testObject = AppViewModel(openAIClient: emptyClient,
                                      userSettingsStore: userSettingsStoreWithSettings)
        
        XCTAssertEqual(testObject.messages.count, 0)
        await testObject.loadUserSettings()
        
        let prompt = String.random
        testObject.currentPrompt = prompt
        testObject.newPrompt()
        
        XCTAssertEqual(testObject.messages.count, 1)
        
        let message = testObject.messages.first
        let expectedMessage = Message(role: .user, content: prompt)
        expectedMessage.assertEqual(to: message)
    }
    
    func test_newPrompt_clearsCurrentPrompt() async {
        let testObject = AppViewModel(openAIClient: emptyClient,
                                      userSettingsStore: userSettingsStoreWithSettings)
        await testObject.loadUserSettings()

        testObject.currentPrompt = String.random
        
        testObject.newPrompt()
        
        XCTAssertEqual(testObject.currentPrompt, "")
    }
    
    func test_newPrompt_whenCurrentPromptIsEmpty_noAction() async throws {
        let client = FakeOpenAIClient()
        let testObject = AppViewModel(openAIClient: client,
                                      userSettingsStore: userSettingsStoreWithSettings)
        await testObject.loadUserSettings()

        testObject.currentPrompt = ""
        
        testObject.newPrompt()
        
        try await Task.sleep(for: sleepDuration)
        
        XCTAssertEqual(testObject.messages.count, 0)
        XCTAssertEqual(client.sendChatRequest_calledCount, 0)
        XCTAssertEqual(testObject.isPromptDisabled, false)
    }
    
    func test_newPrompt_sendsMessagesToClient() async throws {
        let client = FakeOpenAIClient()
        let userSettingsStore = FakeUserSettingsStore()
        let testObject = AppViewModel(openAIClient: client,
                                      userSettingsStore: userSettingsStore)
        
        let userSettings = UserSettings.random
        userSettingsStore.load_returnUserSettings = userSettings
        await testObject.loadUserSettings()

        let prompt = String.random
        testObject.currentPrompt = prompt
        
        client.sendChatRequest_returnResult = failureResult
        
        testObject.newPrompt()
        
        try await Task.sleep(for: sleepDuration)
        
        XCTAssertEqual(client.sendChatRequest_calledCount, 1)
        
        let expectedMessages = MessageCreator(language: userSettings.language)
            .messagesForPrompt(prompt)

        client.sendChatRequest_paramMessages?.assertEqual(to: expectedMessages)
    }
    
    func test_newPrompt_whenChatFails_displaysError() async throws {
        let client = FakeOpenAIClient()
        let testObject = AppViewModel(openAIClient: client,
                                      userSettingsStore: userSettingsStoreWithSettings)
        await testObject.loadUserSettings()

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
        let testObject = AppViewModel(openAIClient: client,
                                      userSettingsStore: userSettingsStoreWithSettings)
        await testObject.loadUserSettings()

        let prompt = String.random
        testObject.currentPrompt = prompt
        
        let newMessage = Message.random
        client.sendChatRequest_returnResult = successfulResult(message: newMessage)
        
        testObject.newPrompt()
        
        try await Task.sleep(for: sleepDuration)
        
        XCTAssertEqual(testObject.messages.count, 2)
        XCTAssertEqual(testObject.messages.last, newMessage)
    }
    
    func test_newPrompt_disablesAndEnablesOnError() async throws {
        let client = FakeOpenAIClient()
        let testObject = AppViewModel(openAIClient: client,
                                      userSettingsStore: userSettingsStoreWithSettings)
        await testObject.loadUserSettings()

        testObject.currentPrompt = String.random
        
        XCTAssertEqual(testObject.isPromptDisabled, false)

        client.sendChatRequest_returnResult = failureResult
        
        testObject.newPrompt()
        
        XCTAssertEqual(testObject.isPromptDisabled, true)
        
        try await Task.sleep(for: sleepDuration)

        XCTAssertEqual(testObject.isPromptDisabled, false)
    }
    
    func test_newPrompt_disablesAndEnablesOnSuccess() async throws {
        let client = FakeOpenAIClient()
        let testObject = AppViewModel(openAIClient: client,
                                      userSettingsStore: userSettingsStoreWithSettings)
        await testObject.loadUserSettings()

        testObject.currentPrompt = String.random
        
        XCTAssertEqual(testObject.isPromptDisabled, false)

        client.sendChatRequest_returnResult = successfulResult(message: emptyMessage)
        
        testObject.newPrompt()
        
        XCTAssertEqual(testObject.isPromptDisabled, true)
        
        try await Task.sleep(for: sleepDuration)

        XCTAssertEqual(testObject.isPromptDisabled, false)
    }
    
    private var emptyMessage: Message {
        Message(role: .assistant, content: "")
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
    
    private var userSettingsStoreWithSettings: UserSettingsStorable {
        let store = FakeUserSettingsStore()
        store.load_returnUserSettings = UserSettings.random
        return store
    }
}

fileprivate extension FakeURLSession {
}
