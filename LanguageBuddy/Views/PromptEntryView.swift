import SwiftUI

struct PromptEntryView<AppViewModel>: View
where AppViewModel: AppViewModelable {
    @ObservedObject var appViewModel: AppViewModel
    @FocusState var promptIsFocused: Bool
    
    var body: some View {
        HStack {
            TextField("Your question here...",
                      text: $appViewModel.currentPrompt)
                .padding(15)
                .border(Color.gray, width: 2)
                .cornerRadius(4)
                .focused($promptIsFocused)
                .onSubmit { promptSubmitted() }
            Button(action: { promptSubmitted() }) {
                Image(systemName: "paperplane.fill")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
            }
        }
        .padding(10)
        .disabled(appViewModel.isPromptDisabled)
        .onAppear {
            promptIsFocused = true
        }
    }
    
    private func promptSubmitted() {
        appViewModel.handlePromptSubmitted()
        promptIsFocused = true
    }
}

struct PromptEntryView_Previews: PreviewProvider {
    static var previews: some View {
        PromptEntryView(appViewModel: FakeAppViewModel())
            .previewLayout(.sizeThatFits)

    }
}
