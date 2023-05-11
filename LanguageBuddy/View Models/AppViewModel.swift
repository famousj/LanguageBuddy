import Foundation
import SwiftUI

class AppViewModel: ObservableObject, AppViewModelable {
    @Published var messages = [Message]()
    @Published var currentPrompt: String = ""
    
    @Published var showChatError = false
    var chatError: OpenAIError?
    
    @Published var disablePrompt = false
    
    private static let defaultLanguage = "European Portuguese"
    private let userSettings: UserSettings
    
    private let openAIClient: OpenAIClientable
    
    init(openAIClient: OpenAIClientable = OpenAIClient(),
         language: String = defaultLanguage) {
        self.openAIClient = openAIClient
        self.userSettings = UserSettings(language: language,
                                         model: .gpt4)
    }
    
    func newPrompt() {
        guard currentPrompt != "" else { return }
        
        disablePrompt = true
        
        messages.append(Message(role: .user, content: currentPrompt))

        let promptToSend = currentPrompt
        Task {
            let messages = MessageCreator(language: userSettings.language)
                .messagesForPrompt(promptToSend)
            await sendMessagesToClient(messages: messages)
        }
        
        currentPrompt = ""
    }
        
    private func sendMessagesToClient(messages: [Message]) async {
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
        disablePrompt = value
    }
}
