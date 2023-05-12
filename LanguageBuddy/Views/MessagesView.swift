import SwiftUI

struct MessagesView<AppViewModel>: View where AppViewModel: AppViewModelable {
    @ObservedObject var appViewModel: AppViewModel
    @State private var editingUserSettings: UserSettings
    
    init(appViewModel: AppViewModel) {
        self.appViewModel = appViewModel
        self.editingUserSettings = appViewModel.userSettings
    }
    
    var body: some View {
        VStack {
            MessagesList(appViewModel: appViewModel)
            PromptEntryView(appViewModel: appViewModel)
        }
        .padding()
        .toolbar {
            Button(action: {
                appViewModel.showEditUserSettings()
            }) {
                Image(systemName: "person.circle")
            }
        }
        .alert(isPresented: $appViewModel.showChatError,
               error: appViewModel.chatError,
               actions: {})
        .sheet(isPresented: $appViewModel.isUserSettingsPresented) {
            NavigationStack {
                UserSettingsView(userSettings: $appViewModel.editingUserSettings)
                    .navigationTitle("Settings")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                appViewModel.cancelEditUserSettings()
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                appViewModel.doneWithEditUserSettings()
                            }
                        }
                    }
            }
        }
    }
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        let appViewModel = FakeAppViewModel()
        let errorDetails = OpenAIErrorDetails(message: "This is an error",
                                              type: "Type here",
                                              param: nil,
                                              code: "PC-Load-Ltr")
        appViewModel.chatError = OpenAIError.serverError(errorDetails)
        
        appViewModel.showChatError = false

        return MessagesView(appViewModel: appViewModel)
    }
}
