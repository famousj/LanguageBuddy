import SwiftUI

struct MessagesView<AppViewModel>: View where AppViewModel: AppViewModelable {
    @ObservedObject var appViewModel: AppViewModel
    
    var body: some View {
        VStack {
            MessagesList(appViewModel: appViewModel)
            PromptEntryView(appViewModel: appViewModel)
        }
        .padding()
    }
}

struct PromptView_Previews: PreviewProvider {
    static var previews: some View {
        let appViewModel = FakeAppViewModel()
        
        return MessagesView(appViewModel: appViewModel)
    }
}
