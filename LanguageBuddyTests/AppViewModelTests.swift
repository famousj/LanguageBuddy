import XCTest
@testable import LanguageBuddy

final class AppViewModelTests: XCTestCase {
    func test_doesNotRetain() async throws {
        var languageLookup: FakeLanguageLookup? = FakeLanguageLookup()
        var userSettingsStore: FakeUserSettingsStore? = FakeUserSettingsStore()
        var testObject: AppViewModel? = AppViewModel(languageLookup: languageLookup!,
                                                     userSettingsStore: userSettingsStore!)

        userSettingsStore?.load_returnUserSettings = UserSettings.random
        await testObject?.loadUserSettings()

        testObject?.currentPrompt = String.random
        languageLookup?.lookupPrompt_returnResult = .failureResult

        testObject?.newPrompt()
        
        try await Task.sleep(for: .SleepDuration)
                
        weak var weakTestObject = testObject
        testObject = nil
        languageLookup = nil
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
        let testObject = AppViewModel(languageLookup: failureLookup,
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
        let testObject = AppViewModel(languageLookup: failureLookup,
                                      userSettingsStore: userSettingsStoreWithSettings)
        await testObject.loadUserSettings()

        testObject.currentPrompt = String.random
        
        testObject.newPrompt()
        
        XCTAssertEqual(testObject.currentPrompt, "")
    }
    
    func test_newPrompt_whenCurrentPromptIsEmpty_noAction() async throws {
        let lookup = FakeLanguageLookup()
        let testObject = AppViewModel(languageLookup: lookup,
                                      userSettingsStore: userSettingsStoreWithSettings)
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
        let userSettingsStore = FakeUserSettingsStore()
        let testObject = AppViewModel(languageLookup: lookup,
                                      userSettingsStore: userSettingsStore)
        
        
        let language = UUID().uuidString
        let userSettings = UserSettings(language: language,
                                        model: .gpt3)
        userSettingsStore.load_returnUserSettings = userSettings
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
                                      userSettingsStore: userSettingsStoreWithSettings)
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
                                      userSettingsStore: userSettingsStoreWithSettings)
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
                                      userSettingsStore: userSettingsStoreWithSettings)
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
                                      userSettingsStore: userSettingsStoreWithSettings)
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
        let userSettingsStore = FakeUserSettingsStore()
        let testObject = AppViewModel(languageLookup: FakeLanguageLookup(),
                                      userSettingsStore: userSettingsStore)
        
        let userSettings = UserSettings.random
        userSettingsStore.load_returnUserSettings = userSettings
        await testObject.loadUserSettings()
        
        testObject.editingUserSettings = UserSettings.random
        testObject.isUserSettingsPresented = false
        
        testObject.showEditUserSettings()
        
        XCTAssertEqual(testObject.editingUserSettings, userSettings)
        XCTAssertEqual(testObject.isUserSettingsPresented, true)

    }
    
    func test_cancelEditUserSettings_cancelsUserSettingsEdit() async {
        let userSettingsStore = FakeUserSettingsStore()
        let testObject = AppViewModel(languageLookup: FakeLanguageLookup(),
                                      userSettingsStore: userSettingsStore)
        
        let userSettings = UserSettings.random
        userSettingsStore.load_returnUserSettings = userSettings
        await testObject.loadUserSettings()
        
        testObject.editingUserSettings = UserSettings.random
        testObject.isUserSettingsPresented = true
        
        testObject.cancelEditUserSettings()
        
        XCTAssertEqual(testObject.userSettings, userSettings)
        XCTAssertEqual(testObject.isUserSettingsPresented, false)
    }
    
    func test_doneWithEditUserSettings_savesAndExits() async throws {
        let userSettingsStore = FakeUserSettingsStore()
        let testObject = AppViewModel(languageLookup: FakeLanguageLookup(),
                                      userSettingsStore: userSettingsStore)
        
        userSettingsStore.load_returnUserSettings = UserSettings.random
        await testObject.loadUserSettings()
        
        let updatedUserSettings = UserSettings.random
        testObject.editingUserSettings = updatedUserSettings
        testObject.isUserSettingsPresented = true
        
        testObject.doneWithEditUserSettings()

        try await Task.sleep(for: .SleepDuration)
        
        XCTAssertEqual(userSettingsStore.save_calledCount, 1)
        XCTAssertEqual(userSettingsStore.save_paramUserSettings, updatedUserSettings)
        
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
    
    private var userSettingsStoreWithSettings: UserSettingsStorable {
        let store = FakeUserSettingsStore()
        store.load_returnUserSettings = UserSettings.random
        return store
    }
}

fileprivate extension FakeURLSession {
}
