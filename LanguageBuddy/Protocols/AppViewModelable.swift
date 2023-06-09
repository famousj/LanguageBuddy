import Foundation

protocol AppViewModelable: ObservableObject {
    var showChatError: Bool { get set }
    var chatError: OpenAIError? { get }
    
    var isPromptDisabled: Bool { get set }
    var isUserSettingsPresented: Bool { get set }
    
    var userSettings: UserSettings { get }
    
    var messages: [Message] { get }
    var currentPrompt: String { get set }
    
    func handleViewAppeared() async
    func handleAppBecameInactive() async

    func handlePromptSubmitted()

    var editingUserSettings: UserSettings { get set }
    func showEditUserSettings()
    func cancelEditUserSettings()
    func doneWithEditUserSettings()
    
}
