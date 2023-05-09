import Foundation

class AppViewModel: ObservableObject, AppViewModeling {
    @Published var messages = [Message]()
    
    private let openAIClient: OpenAIClienting
    
    init(openAIClient: OpenAIClienting = OpenAIClient()) {
        self.openAIClient = openAIClient
    }    
}
