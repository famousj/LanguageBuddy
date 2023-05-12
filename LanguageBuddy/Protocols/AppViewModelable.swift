import Foundation

protocol AppViewModelable: ObservableObject {
    var showChatError: Bool { get set }
    var chatError: OpenAIError? { get }
    
    var isPromptDisabled: Bool { get set }
    var isUserSettingsPresented: Bool { get set }
    
    var userSettings: UserSettings { get set }
    
    var messages: [Message] { get }
    var currentPrompt: String { get set }
    
    func newPrompt()

    func loadUserSettings() async
    
    var editingUserSettings: UserSettings { get set }
    func showEditUserSettings()
    func cancelEditUserSettings()
    func doneWithEditUserSettings()
}
