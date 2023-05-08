import SwiftUI

struct ContentView: View {
    let messages: [Message]
    
    var body: some View {
        VStack {
            MessagesView(messages: messages)
            PromptEntryView()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        ContentView(messages: Message.previewArray(count: 100))
        ContentView(messages: Message.previewArray(count: 100))
    }
}
