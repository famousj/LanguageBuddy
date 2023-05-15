import XCTest
@testable import LanguageBuddy

final class AppViewModelTests: XCTestCase {
    func test_doesNotRetain() async throws {
        var languageLookup: FakeLanguageLookup? = FakeLanguageLookup()
        var fileStore: FakeFileStore? = FakeFileStore()
        var testObject: AppViewModel? = AppViewModel(languageLookup: languageLookup!,
                                                     fileStore: fileStore!)

        fileStore?.load_returnObject = UserSettings.random
        await testObject?.loadUserSettings()

        testObject?.currentPrompt = String.random
        languageLookup?.lookupPrompt_returnResult = .failureResult

        testObject?.newPrompt()
        
        try await Task.sleep(for: .SleepDuration)
                
        weak var weakTestObject = testObject
        testObject = nil
        languageLookup = nil
        fileStore = nil
        XCTAssertNil(weakTestObject)
    }
    
    func test_loadUserSettings_callsStore() async {
        let fileStore = FakeFileStore()
        let testObject = AppViewModel(fileStore: fileStore)
        
        let userSettings = UserSettings(language: UUID().uuidString,
                                        model: Model.allCases.randomElement()!)
        fileStore.load_returnObject = userSettings
        
        XCTAssertEqual(testObject.isPromptDisabled, true)
        
        await testObject.loadUserSettings()
        XCTAssertEqual(fileStore.load_calledCount, 1)
        XCTAssertEqual(testObject.userSettings, userSettings)
        XCTAssertEqual(testObject.isPromptDisabled, false)
    }

    func test_loadUserSettings_onError_usesDefault() async {
        let fileStore = FakeFileStore()
        let testObject = AppViewModel(fileStore: fileStore)
        
        fileStore.load_error = NSError(domain: "", code: 0)
        
        await testObject.loadUserSettings()
        XCTAssertEqual(testObject.userSettings,
                       UserSettings.defaultSettings)
        XCTAssertEqual(testObject.isPromptDisabled, false)
    }
    
    func test_newPrompt_addsNewMessage() async {
        let testObject = AppViewModel(languageLookup: failureLookup,
                                      fileStore: fileStoreWithSettings)
        
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
        let testObject = AppViewModel(languageLookup: failureLookup,
                                      fileStore: fileStoreWithSettings)
        await testObject.loadUserSettings()

        testObject.currentPrompt = String.random
        
        testObject.newPrompt()
        
        XCTAssertEqual(testObject.currentPrompt, "")
    }
    
    func test_newPrompt_whenCurrentPromptIsEmpty_noAction() async throws {
        let lookup = FakeLanguageLookup()
        let testObject = AppViewModel(languageLookup: lookup,
                                      fileStore: fileStoreWithSettings)
        await testObject.loadUserSettings()

        testObject.currentPrompt = ""
        
        testObject.newPrompt()
        
        try await Task.sleep(for: .SleepDuration)
        
        XCTAssertEqual(testObject.messages.count, 0)
        XCTAssertEqual(lookup.lookupPrompt_calledCount, 0)
        XCTAssertEqual(testObject.isPromptDisabled, false)
    }
    
    func test_newPrompt_looksUpPrompt() async throws {
        let lookup = FakeLanguageLookup()
        let fileStore = FakeFileStore()
        let testObject = AppViewModel(languageLookup: lookup,
                                      fileStore: fileStore)
        
        
        let language = UUID().uuidString
        let userSettings = UserSettings(language: language,
                                        model: .gpt3)
        fileStore.load_returnObject = userSettings
        await testObject.loadUserSettings()
                
        let prompt = String.random
        testObject.currentPrompt = prompt
        
        lookup.lookupPrompt_returnResult = .failureResult

        testObject.newPrompt()
        
        try await Task.sleep(for: .SleepDuration)
        
        XCTAssertEqual(lookup.lookupPrompt_calledCount, 1)
        XCTAssertEqual(lookup.lookupPrompt_paramLanguage, language)
        XCTAssertEqual(lookup.lookupPrompt_paramPrompt, prompt)
    }
    
    func test_newPrompt_whenChatFails_displaysError() async throws {
        let lookup = FakeLanguageLookup()
        let testObject = AppViewModel(languageLookup: lookup,
                                      fileStore: fileStoreWithSettings)
        await testObject.loadUserSettings()

        testObject.currentPrompt = String.random
        
        XCTAssertEqual(testObject.showChatError, false)

        let expectedDetails = OpenAIErrorDetails(message: String.random,
                                              type: "",
                                              param: nil,
                                              code: nil)
        let expectedError = OpenAIError.serverError(expectedDetails)
        lookup.lookupPrompt_returnResult = .failure(expectedError)
        
        testObject.newPrompt()
        
        try await Task.sleep(for: .SleepDuration)

        XCTAssertEqual(testObject.showChatError, true)
        
        XCTAssertEqual(testObject.chatError?.localizedDescription,
                       expectedError.localizedDescription)
    }
    
    func test_newPrompt_addsSuccessfulMessageToList() async throws {
        let lookup = FakeLanguageLookup()
        let testObject = AppViewModel(languageLookup: lookup,
                                      fileStore: fileStoreWithSettings)
        await testObject.loadUserSettings()

        let prompt = String.random
        testObject.currentPrompt = prompt
        
        let newMessage = Message.random
        lookup.lookupPrompt_returnResult = .successResult(message: newMessage)
        
        testObject.newPrompt()
        
        try await Task.sleep(for: .SleepDuration)
        
        XCTAssertEqual(testObject.messages.count, 2)
        XCTAssertEqual(testObject.messages.last, newMessage)
    }
    
    func test_newPrompt_disablesAndEnablesOnError() async throws {
        let lookup = FakeLanguageLookup()
        let testObject = AppViewModel(languageLookup: lookup,
                                      fileStore: fileStoreWithSettings)
        await testObject.loadUserSettings()

        testObject.currentPrompt = String.random
        
        XCTAssertEqual(testObject.isPromptDisabled, false)

        lookup.lookupPrompt_returnResult = .failureResult
        
        testObject.newPrompt()
        
        XCTAssertEqual(testObject.isPromptDisabled, true)
        
        try await Task.sleep(for: .SleepDuration)

        XCTAssertEqual(testObject.isPromptDisabled, false)
    }
    
    func test_newPrompt_disablesAndEnablesOnSuccess() async throws {
        let lookup = FakeLanguageLookup()
        let testObject = AppViewModel(languageLookup: lookup,
                                      fileStore: fileStoreWithSettings)
        await testObject.loadUserSettings()

        testObject.currentPrompt = String.random
        
        XCTAssertEqual(testObject.isPromptDisabled, false)

        lookup.lookupPrompt_returnResult = .successResult(message: emptyMessage)
        
        testObject.newPrompt()
        
        XCTAssertEqual(testObject.isPromptDisabled, true)
        
        try await Task.sleep(for: .SleepDuration)

        XCTAssertEqual(testObject.isPromptDisabled, false)
    }
    
    func test_showEditUserSettings_showsUserSettingsEdit() async {
        let fileStore = FakeFileStore()
        let testObject = AppViewModel(languageLookup: FakeLanguageLookup(),
                                      fileStore: fileStore)
        
        let userSettings = UserSettings.random
        fileStore.load_returnObject = userSettings
        await testObject.loadUserSettings()
        
        testObject.editingUserSettings = UserSettings.random
        testObject.isUserSettingsPresented = false
        
        testObject.showEditUserSettings()
        
        XCTAssertEqual(testObject.editingUserSettings, userSettings)
        XCTAssertEqual(testObject.isUserSettingsPresented, true)

    }
    
    func test_cancelEditUserSettings_cancelsUserSettingsEdit() async {
        let fileStore = FakeFileStore()
        let testObject = AppViewModel(languageLookup: FakeLanguageLookup(),
                                      fileStore: fileStore)
        
        let userSettings = UserSettings.random
        fileStore.load_returnObject = userSettings
        await testObject.loadUserSettings()
        
        testObject.editingUserSettings = UserSettings.random
        testObject.isUserSettingsPresented = true
        
        testObject.cancelEditUserSettings()
        
        XCTAssertEqual(testObject.userSettings, userSettings)
        XCTAssertEqual(testObject.isUserSettingsPresented, false)
    }
    
    func test_doneWithEditUserSettings_savesAndExits() async throws {
        let fileStore = FakeFileStore()
        let testObject = AppViewModel(languageLookup: FakeLanguageLookup(),
                                      fileStore: fileStore)
        
        fileStore.load_returnObject = UserSettings.random
        await testObject.loadUserSettings()
        
        let updatedUserSettings = UserSettings.random
        testObject.editingUserSettings = updatedUserSettings
        testObject.isUserSettingsPresented = true
        
        testObject.doneWithEditUserSettings()

        try await Task.sleep(for: .SleepDuration)
        
        XCTAssertEqual(fileStore.save_calledCount, 1)
        XCTAssertEqual(fileStore.save_paramObject as? UserSettings, updatedUserSettings)
        
        XCTAssertEqual(testObject.userSettings, updatedUserSettings)
        XCTAssertEqual(testObject.isUserSettingsPresented, false)
    }
    
    private var emptyMessage: Message {
        Message(role: .assistant, content: "")
    }
    
    private var failureLookup: FakeLanguageLookup {
        let lookup = FakeLanguageLookup()
        lookup.lookupPrompt_returnResult = .failureResult
        return lookup
    }
    
    private var fileStoreWithSettings: FileStorable {
        let store = FakeFileStore()
        store.load_returnObject = UserSettings.random
        return store
    }
}

fileprivate extension FakeURLSession {
}
