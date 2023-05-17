import SwiftUI

struct ContentView<AppViewModel>: View where AppViewModel: AppViewModelable {
    @StateObject var appViewModel: AppViewModel
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        NavigationStack {
            MessagesView(appViewModel: appViewModel)
                .task {
                    await appViewModel.handleViewAppeared()
                }
                .onChange(of: scenePhase) { phase in
                    if phase == .inactive {
                        Task {
                            await appViewModel.handleAppBecameInactive()
                        }
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(appViewModel: FakeAppViewModel())
    }
}
