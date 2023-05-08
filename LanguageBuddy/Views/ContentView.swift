import SwiftUI

struct ContentView<AppViewModel>: View where AppViewModel: AppViewModeling {
    @ObservedObject var appViewModel: AppViewModel
    
    var body: some View {
        VStack {
            MessagesView(messages: appViewModel.messages)
            PromptEntryView()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let appViewModel = FakeAppViewModel()
        
        return ContentView(appViewModel: appViewModel)
    }
}
