import SwiftUI

struct ContentView<AppViewModel>: View where AppViewModel: AppViewModelable {
    @StateObject var appViewModel: AppViewModel

    var body: some View {
        MessagesView(appViewModel: appViewModel)
            .task {
                await appViewModel.loadUserSettings()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(appViewModel: FakeAppViewModel())
    }
}
