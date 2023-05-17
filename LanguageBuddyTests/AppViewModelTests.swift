import XCTest
@testable import LanguageBuddy

final class AppViewModelTests: XCTestCase {
    func test_doesNotRetain() async throws {
        var languageLookup: FakeLanguageLookup? = FakeLanguageLookup()
        var fileStore: FakeFileStore? = FakeFileStore()
        var testObject: AppViewModel? = AppViewModel(languageLookup: languageLookup!,
                                                     fileStore: fileStore!)

        fileStore?.load_returnObject = UserSettings.random
        await testObject?.handleViewAppeared()

        testObject?.currentPrompt = String.random
        languageLookup?.lookupPrompt_returnResult = .failureResult

        testObject?.handlePromptSubmitted()
        
        try await Task.sleep(for: .SleepDuration)
                
        weak var weakTestObject = testObject
        testObject = nil
        languageLookup = nil
        fileStore = nil
        XCTAssertNil(weakTestObject)
    }
    
    func test_handleViewAppeared_callsStoreForUserSettings() async {
        let fileStore = FakeFileStore()
        let testObject = AppViewModel(fileStore: fileStore)
        
        let userSettings = UserSettings(language: UUID().uuidString,
                                        model: Model.allCases.randomElement()!)
        fileStore.load_returnObject = userSettings
        
        XCTAssertEqual(testObject.isPromptDisabled, true)
        
        await testObject.handleViewAppeared()
        XCTAssertEqual(fileStore.load_calledCount, 1)
        XCTAssertEqual(testObject.userSettings, userSettings)
        XCTAssertEqual(testObject.isPromptDisabled, false)
    }

    func test_handleViewAppeared_onError_usesDefaultUserSettings() async {
        let fileStore = FakeFileStore()
        let testObject = AppViewModel(fileStore: fileStore)
        
        fileStore.load_error = NSError(domain: "", code: 0)
        
        await testObject.handleViewAppeared()
        
        XCTAssertEqual(testObject.userSettings,
                       UserSettings.defaultSettings)
        XCTAssertEqual(testObject.isPromptDisabled, false)
    }
    
    func test_handlePromptSubmitted_addsNewMessage() async {
        let testObject = AppViewModel(languageLookup: failureLookup)
        
        XCTAssertEqual(testObject.messages.count, 0)
        
        let prompt = String.random
        testObject.currentPrompt = prompt
        testObject.handlePromptSubmitted()
        
        XCTAssertEqual(testObject.messages.count, 1)
        
        let message = testObject.messages.first
        let expectedMessage = Message(role: .user, content: prompt)
        expectedMessage.assertEqual(to: message)
    }
    
    func test_handlePromptSubmitted_clearsCurrentPrompt() async {
        let testObject = AppViewModel(languageLookup: failureLookup)
        
        testObject.currentPrompt = String.random
        
        testObject.handlePromptSubmitted()
        
        XCTAssertEqual(testObject.currentPrompt, "")
    }
    
    func test_handlePromptSubmitted_whenCurrentPromptIsEmpty_noAction() async throws {
        let lookup = FakeLanguageLookup()
        let testObject = AppViewModel(languageLookup: lookup)

        testObject.currentPrompt = ""
        testObject.isPromptDisabled = false
        
        testObject.handlePromptSubmitted()
        
        try await Task.sleep(for: .SleepDuration)
        
        XCTAssertEqual(testObject.messages.count, 0)
        XCTAssertEqual(lookup.lookupPrompt_calledCount, 0)
        XCTAssertEqual(testObject.isPromptDisabled, false)
    }
    
    func test_handlePromptSubmitted_looksUpPrompt() async throws {
        let lookup = FakeLanguageLookup()
        let fileStore = FakeFileStore()
        let testObject = AppViewModel(languageLookup: lookup,
                                      fileStore: fileStore)
        
        let language = UUID().uuidString
        let userSettings = UserSettings(language: language,
                                        model: .gpt3)
        testObject.userSettings = userSettings
                
        let prompt = String.random
        testObject.currentPrompt = prompt
        
        lookup.lookupPrompt_returnResult = .failureResult

        testObject.handlePromptSubmitted()
        
        try await Task.sleep(for: .SleepDuration)
        
        XCTAssertEqual(lookup.lookupPrompt_calledCount, 1)
        XCTAssertEqual(lookup.lookupPrompt_paramLanguage, language)
        XCTAssertEqual(lookup.lookupPrompt_paramPrompt, prompt)
    }
    
    func test_handlePromptSubmitted_whenChatFails_displaysError() async throws {
        let lookup = FakeLanguageLookup()
        let testObject = AppViewModel(languageLookup: lookup)

        testObject.currentPrompt = String.random
        
        XCTAssertEqual(testObject.showChatError, false)

        let expectedDetails = OpenAIErrorDetails(message: String.random,
                                              type: "",
                                              param: nil,
                                              code: nil)
        let expectedError = OpenAIError.serverError(expectedDetails)
        lookup.lookupPrompt_returnResult = .failure(expectedError)
        
        testObject.handlePromptSubmitted()
        
        try await Task.sleep(for: .SleepDuration)

        XCTAssertEqual(testObject.showChatError, true)
        
        XCTAssertEqual(testObject.chatError?.localizedDescription,
                       expectedError.localizedDescription)
    }
    
    func test_handlePromptSubmitted_addsSuccessfulMessageToList() async throws {
        let lookup = FakeLanguageLookup()
        let testObject = AppViewModel(languageLookup: lookup)

        let prompt = String.random
        testObject.currentPrompt = prompt
        
        let newMessage = Message.random
        lookup.lookupPrompt_returnResult = .successResult(message: newMessage)
        
        testObject.handlePromptSubmitted()
        
        try await Task.sleep(for: .SleepDuration)
        
        XCTAssertEqual(testObject.messages.count, 2)
        XCTAssertEqual(testObject.messages.last, newMessage)
    }
    
    func test_handlePromptSubmitted_disablesAndEnablesOnError() async throws {
        let lookup = FakeLanguageLookup()
        let testObject = AppViewModel(languageLookup: lookup)

        testObject.currentPrompt = String.random
        testObject.isPromptDisabled = false

        lookup.lookupPrompt_returnResult = .failureResult
        
        testObject.handlePromptSubmitted()
        
        XCTAssertEqual(testObject.isPromptDisabled, true)
        
        try await Task.sleep(for: .SleepDuration)

        XCTAssertEqual(testObject.isPromptDisabled, false)
    }
    
    func test_handlePromptSubmitted_disablesAndEnablesOnSuccess() async throws {
        let lookup = FakeLanguageLookup()
        let testObject = AppViewModel(languageLookup: lookup)

        testObject.currentPrompt = String.random
        testObject.isPromptDisabled = false

        lookup.lookupPrompt_returnResult = .successResult(message: emptyMessage)
        
        testObject.handlePromptSubmitted()
        
        XCTAssertEqual(testObject.isPromptDisabled, true)
        
        try await Task.sleep(for: .SleepDuration)

        XCTAssertEqual(testObject.isPromptDisabled, false)
    }
    
    func test_showEditUserSettings_showsUserSettingsEdit() async {
        let testObject = AppViewModel(languageLookup: FakeLanguageLookup())
        
        let userSettings = UserSettings.random
        testObject.userSettings = userSettings
        
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
        await testObject.handleViewAppeared()
        
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
        
        testObject.userSettings = UserSettings.random
        
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
    
    func test_saveHistory_storesTheHistoryToFile() async {
        let fileStore = FakeFileStore()
        let testObject = AppViewModel(fileStore: fileStore)
        
        let messages = (0...Int.random).map { _ in Message.random }
        testObject.messages = messages
        
        await testObject.saveHistory()
        
        XCTAssertEqual(fileStore.save_calledCount, 1)
        XCTAssertEqual(fileStore.save_paramObject as! [Message], messages)
    }
    
    func test_saveHistory_ignoresErrors() async {
        let fileStore = FakeFileStore()
        let testObject = AppViewModel(fileStore: fileStore)

        fileStore.save_error = NSError(domain: "", code: 0)
        
        await testObject.saveHistory()
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
