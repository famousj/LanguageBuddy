import SwiftUI

struct MessagesView<AppViewModel>: View where AppViewModel: AppViewModelable {
    @ObservedObject var appViewModel: AppViewModel
    
    var body: some View {
        VStack {
            MessagesList(appViewModel: appViewModel)
            PromptEntryView(appViewModel: appViewModel)
        }
        .padding()
        .alert(isPresented: $appViewModel.showChatError,
               error: appViewModel.chatError,
               actions: {})
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
