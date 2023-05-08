import Foundation

protocol AppViewModeling: ObservableObject {
    var appState: AppState { get }
    var messages: [Message] { get }
    
    func loginRequested()
}
