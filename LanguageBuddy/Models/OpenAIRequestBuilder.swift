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

struct OpenAIRequestBuilder: OpenAIRequestBuilding {
    var clientCredential: String {
        // TODO: Use your own key here
        "OPENAI_API_KEY"
    }
    
    func buildRequest(_ request: OpenAIRequest) -> URLRequest {
        let url = request.url
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        request.setValue("Bearer \(clientCredential)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
}
