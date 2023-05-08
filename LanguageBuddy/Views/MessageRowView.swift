import SwiftUI

struct MessageRowView: View {
    let message: Message
    
    var name: String {
        message.name ?? message.role.rawValue.capitalized
    }
    
    var body: some View {
        HStack {
            HStack(alignment: .top) {
                Text(name)
                    .bold()
                Text(message.content)
            }
            Spacer()
        }
    }
    
    
}

struct MessageRowView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            MessageRowView(message: Message.preview)
            MessageRowView(message: Message(role: .assistant,
                                            content: "Some content",
                                            name: "Frank"))
        }
    }
}
