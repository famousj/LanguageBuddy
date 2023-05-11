import Foundation

protocol AppViewModelable: ObservableObject {
    var showChatError: Bool { get set }
    var chatError: OpenAIError? { get }
    
    var messages: [Message] { get }
    var currentPrompt: String { get set }
    
    func newPrompt()
}
