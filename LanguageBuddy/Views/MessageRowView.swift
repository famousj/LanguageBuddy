import SwiftUI

struct MessageRowView: View {
    let message: Message
    
    var body: some View {
        HStack(alignment: .top) {
            Text(message.role.rawValue.capitalized)
                .bold()
            Spacer()
            Text(message.content)
        }
    }
}

struct MessageRowView_Previews: PreviewProvider {
    static var previews: some View {
        MessageRowView(message: Message.preview)
    }
}
