import SwiftUI

struct ContentView<AppViewModel>: View where AppViewModel: AppViewModeling {
    @ObservedObject var appViewModel: AppViewModel

    var body: some View {
        Group {
            if case AppState.notLoggedIn = appViewModel.appState {
                Text("Not logged in")
            } else {
                PromptView(appViewModel: appViewModel)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let loggedInVM = FakeAppViewModel()
        loggedInVM.appState = .loggedIn
        
        let notLoggedInVM = FakeAppViewModel()
        notLoggedInVM.appState = .notLoggedIn
        
        return Group {
            ContentView(appViewModel: notLoggedInVM)
            ContentView(appViewModel: loggedInVM)
        }
    }
}
