import Foundation

class AppViewModel: ObservableObject, AppViewModelable {
    @Published var messages = [Message]()
    
    private let openAIClient: OpenAIClientable
    
    init(openAIClient: OpenAIClientable = OpenAIClient()) {
        self.openAIClient = openAIClient
    }    
}
