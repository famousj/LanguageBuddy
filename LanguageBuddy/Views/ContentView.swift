import SwiftUI

struct ContentView<AppViewModel>: View where AppViewModel: AppViewModelable {
    @ObservedObject var appViewModel: AppViewModel

    var body: some View {
        PromptView(appViewModel: appViewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(appViewModel: FakeAppViewModel())
    }
}
