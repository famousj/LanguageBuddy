import SwiftUI

struct MessagesView: View {
    let messages: [Message]
    
    var body: some View {
        ScrollViewReader { proxy in
            List(messages) { message in
                MessageRowView(message: message)
            }
            .onAppear {
                proxy.scrollTo(messages[messages.endIndex - 1].id)
            }
        }
    }    
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView(messages: Message.previewArray(count: 100))
    }
}
