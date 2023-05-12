import Foundation
import SwiftUI

class AppViewModel: ObservableObject, AppViewModelable {
    @Published var messages = [Message]()
    @Published var currentPrompt: String = ""
    
    @Published var showChatError = false
    var chatError: OpenAIError?
    
    @Published var isPromptDisabled = true
    
    @Published var userSettings: UserSettings?
    
    private let openAIClient: OpenAIClientable
    private let userSettingsStore: UserSettingsStorable
    
    init(openAIClient: OpenAIClientable = OpenAIClient(),
         userSettingsStore: UserSettingsStorable = UserSettingsStore()) {
        self.openAIClient = openAIClient
        self.userSettingsStore = userSettingsStore
    }
    
    func loadUserSettings() async {
        let userSettings = (try? await userSettingsStore.load()) ??
        UserSettings.defaultSettings
        await setUserSettings(userSettings)
        await setDisablePrompt(false)
    }
    
    func saveUserSettings() async {
        guard let userSettings = userSettings else {
            return
        }
        
        try? await userSettingsStore.save(userSettings: userSettings)
    }
    
    func newPrompt() {
        guard let userSettings = userSettings else {
            print("Trying to send a prompt before we've loaded the user settings!")
            return
        }
        
        guard currentPrompt != "" else { return }
        
        isPromptDisabled = true
        
        messages.append(Message(role: .user, content: currentPrompt))

        let promptToSend = currentPrompt
        Task {
            let messages = MessageCreator(language: userSettings.language)
                .messagesForPrompt(promptToSend)
            await sendMessagesToClient(userSettings: userSettings,
                                       messages: messages)
        }
        
        currentPrompt = ""
    }
        
    private func sendMessagesToClient(userSettings: UserSettings,
                                      messages: [Message]) async {
        let result = await openAIClient.sendChatRequest(model: userSettings.model,
                                                        messages: messages)
        
        print(result)
        switch result {
        case .failure(let error):
            await setError(error)
        case .success(let result):
            if let replyMessage = result.choices.first?.message  {
                await addToMessages(message: replyMessage)
            }
        }
        await setDisablePrompt(false)
    }
    
    @MainActor
    private func addToMessages(message: Message) {
        messages.append(message)
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
