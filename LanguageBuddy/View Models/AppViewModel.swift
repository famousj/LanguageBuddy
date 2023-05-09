import Foundation

class AppViewModel: ObservableObject, AppViewModeling {
    @Published var messages = [Message]()
    
    private let openAISession: OpenAIRequesting
    
    init(openAISession: OpenAIRequesting = OpenAIRequester()) {
        self.openAISession = openAISession
    }    
}
