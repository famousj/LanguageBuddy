import Foundation

fileprivate extension OpenAIRequest {
    private var path: String {
        switch self {
        case .chatCompletions:
            return "/chat/completions"
        }
    }
    
    var url: URL {
        let prefix = "https://api.openai.com/v1"
        
        let urlString = prefix + self.path
        return URL(string: urlString)!
    }
}

struct OpenAIRequester: OpenAIRequesting {
    var clientCredential: String {
        "OPENAI_API_KEY"
    }
    
    var defaultModel: String {
        "gpt-3.5-turbo"
    }
    
    var defaultTemperature: Double {
        1
    }
    
    func createChatCompletionRequest(messages: [Message]) -> URLRequest {
        let url = OpenAIRequest.chatCompletions.url
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        request.setValue("Bearer \(clientCredential)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let chatRequest = ChatCompletionRequest(model: defaultModel, messages: messages, temperature: defaultTemperature)
        request.httpBody = try! JSONEncoder().encode(chatRequest)
                                                      
        return request
    }
}
