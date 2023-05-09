import Foundation
import SwiftUI

class AppViewModel: ObservableObject, AppViewModelable {
    @Published var messages = [Message]()
    @Published var currentPrompt: String = ""
    
    private let openAIClient: OpenAIClientable
    
    init(openAIClient: OpenAIClientable = OpenAIClient()) {
        self.openAIClient = openAIClient
    }
    
    func newPrompt() {
        guard currentPrompt != "" else { return }
        
        messages.append(Message(role: .user, content: currentPrompt))
        currentPrompt = ""
    }
}
