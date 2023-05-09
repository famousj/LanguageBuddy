import SwiftUI

struct MessagesList<AppViewModel>: View
where AppViewModel: AppViewModelable {
    @ObservedObject var appViewModel: AppViewModel
    
    private var messages: [Message] {
        appViewModel.messages
    }
    var body: some View {
        ScrollViewReader { proxy in
            List(messages) { message in
                MessageRowView(message: message)
            }
            .onAppear {
                if messages.count > 0 {
                    proxy.scrollTo(messages[messages.endIndex - 1].id)
                }
            }
        }
    }    
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesList(appViewModel: FakeAppViewModel())
    }
}
