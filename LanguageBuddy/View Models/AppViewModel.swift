import Foundation
import SwiftUI

class AppViewModel: ObservableObject, AppViewModelable {
    @Published var currentPrompt: String = ""
    
    @Published var showChatError = false
    var chatError: OpenAIError?
    
    @Published var isPromptDisabled = true
    @Published var isUserSettingsPresented = false
    
    @Published var userSettings = UserSettings.empty
    @Published var editingUserSettings = UserSettings.empty
    
    var messages: [Message] {
        userSettings.messageHistory
    }
    
    private let languageLookup: LanguageLookupable
    private let fileStore: FileStorable
    
    private let modelForLanguageLookup = Model.gpt3
    
    init(languageLookup: LanguageLookupable = LanguageLookup(),
         fileStore: FileStorable = FileStore()) {
        self.languageLookup = languageLookup
        self.fileStore = fileStore
    }
    
    func handleViewAppeared() async {
        let userSettings: UserSettings = (try? await fileStore.load()) ?? UserSettings.defaultSettings
        await setUserSettings(userSettings)
        await setDisablePrompt(false)
    }
    
    private func saveUserSettings() async {
        try? await fileStore.save(userSettings)
    }
    
    func handlePromptSubmitted() {
        guard currentPrompt != "" else { return }
        
        isPromptDisabled = true
        
        userSettings.messageHistory.append(Message(role: .user, content: currentPrompt))

        let promptToSend = currentPrompt
        Task {
            await processPrompt(promptToSend)
        }
        
        currentPrompt = ""
    }
    
    private func processPrompt(_ prompt: String) async {
        let result = await languageLookup.lookupPrompt(model: userSettings.model,
                                                       language: userSettings.language,
                                                       prompt: prompt)
        
        switch result {
        case .failure(let error):
            await handlePromptError(error)
        case .success(let reply):
            if let replyMessage = reply.choices.first?.message {
                await addToMessages(message: replyMessage)
            }
        }
        
        await setDisablePrompt(false)
    }

    private func handlePromptError(_ error: OpenAIError) async {
        await setError(error)
        await setDisablePrompt(false)
    }
    
    func showEditUserSettings() {
        editingUserSettings = userSettings
        isUserSettingsPresented = true
    }

    func cancelEditUserSettings() {
        isUserSettingsPresented = false
    }

    func doneWithEditUserSettings() {
        userSettings = editingUserSettings
        Task {
            await saveUserSettings()
        }

        isUserSettingsPresented = false
    }
    
    func handleAppBecameInactive() async {
        try? await fileStore.save(userSettings)
    }
    
    @MainActor
    private func addToMessages(message: Message) {
        userSettings
            .messageHistory
            .append(message)
    }
    
    @MainActor
    private func setError(_ error: OpenAIError) {
        chatError = error
        showChatError = true
    }
    
    @MainActor
    private func setDisablePrompt(_ value: Bool) {
        isPromptDisabled = value
    }
    @MainActor
    private func setUserSettings(_ value: UserSettings) {
        userSettings = value
    }
}
