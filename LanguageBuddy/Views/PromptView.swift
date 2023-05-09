import SwiftUI

struct PromptView<AppViewModel>: View where AppViewModel: AppViewModelable {
    @ObservedObject var appViewModel: AppViewModel
    
    var body: some View {
        VStack {
            MessagesView(messages: appViewModel.messages)
            PromptEntryView()
        }
        .padding()
    }
}

struct PromptView_Previews: PreviewProvider {
    static var previews: some View {
        let appViewModel = FakeAppViewModel()
        
        return PromptView(appViewModel: appViewModel)
    }
}
