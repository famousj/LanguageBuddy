import Foundation
import SwiftUI

class AppViewModel: ObservableObject, AppViewModelable {
    @Published var messages = [Message]()
    @Published var currentPrompt: String = ""
    
    @Published var showChatError = false
    var chatError: OpenAIError?
    
    private static let defaultLanguage = "European Portuguese"
    let language: String
    
    private let openAIClient: OpenAIClientable
    
    init(openAIClient: OpenAIClientable = OpenAIClient(),
         language: String = defaultLanguage) {
        self.openAIClient = openAIClient
        self.language = language
    }
    
    func newPrompt() {
        guard currentPrompt != "" else { return }
        
        messages.append(Message(role: .user, content: currentPrompt))

        let promptToSend = currentPrompt
        Task {
            let messages = MessageCreator(language: language).messagesForPrompt(promptToSend)
            await sendMessagesToClient(messages: messages)
        }
        
        currentPrompt = ""
    }
        
    private func sendMessagesToClient(messages: [Message]) async {
        let result = await openAIClient.sendChatRequest(messages: messages)
        
        print(result)
        if case .failure(let error) = result {
            await setError(error)
            return
        }
        
        guard case let .success(result) = result,
            let replyMessage = result.choices.first?.message else { return }
        
        await addToMessages(message: replyMessage)
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
}
