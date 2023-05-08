import SwiftUI

struct MessagesView: View {
    let messages: [Message]
    
    var body: some View {
        List(messages) { message in
            MessageRowView(message: message)
        }
    }    
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView(messages: Message.previewArray(count: 100))
    }
}
