import Foundation

class FakeAppViewModel: AppViewModelable {
    var isPromptDisabled = false
    var isUserSettingsPresented = false
    
    var userSettings = UserSettings.defaultSettings
    
    @Published var showChatError: Bool = false
    var chatError: OpenAIError?
    
    @Published var messages = Array(0...100)
        .map { Message(role: Role.allCases.randomElement()!, content: "\($0)") }
    
    @Published var currentPrompt = "Here's what's on my mind.  Lots and lots.  Plenty of things."
    
    func handlePromptSubmitted() {
        messages.append(Message(role: .user, content: currentPrompt))
        currentPrompt = ""
    }
    
    func handleViewAppeared() async {}
    func saveHistory() async {}
    

    var editingUserSettings = UserSettings.empty
    
    func showEditUserSettings() {
        isUserSettingsPresented = true
    }

    func cancelEditUserSettings() {
        isUserSettingsPresented = false
    }
    
    func doneWithEditUserSettings() {
        isUserSettingsPresented = false
    }
}
