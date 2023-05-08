import SwiftUI

struct PromptEntryView: View {
    @State private var prompt: String = ""
    var body: some View {
        ZStack(alignment: .trailing) {
            TextField("Your question here...", text: $prompt)
                .padding(15)
                .border(Color.gray, width: 2)
                .cornerRadius(4)
            Image(systemName: "paperplane")
                .imageScale(.large)
                .foregroundColor(.accentColor)
                .padding(.trailing, 10)
        }
        .padding(10)
    }
}

struct PromptEntryView_Previews: PreviewProvider {
    static var previews: some View {
        PromptEntryView()
            .previewLayout(.fixed(width: 500, height: 60))

    }
}
