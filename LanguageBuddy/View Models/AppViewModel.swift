import Foundation
import SwiftUI

class AppViewModel: ObservableObject, AppViewModelable {
    @Published var messages = [Message]()
    @Published var currentPrompt: String = ""
    
    private let language = "European Portuguese"
    
    private let openAIClient: OpenAIClientable
    
    init(openAIClient: OpenAIClientable = OpenAIClient()) {
        self.openAIClient = openAIClient
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
        let client = OpenAIClient()
        let result = await client.sendChatRequest(messages: messages)
        
        print(result)
        if case .failure(let error) = result {
            // TODO: handle the error here
            print("Dang, got an error: \(error)")
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
}
