import Foundation

protocol AppViewModelable: ObservableObject {
    var messages: [Message] { get }
    var currentPrompt: String { get set }
    
    func newPrompt()
}
