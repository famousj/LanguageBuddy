import Foundation

extension OpenAIRequest {
    private var path: String {
        switch self {
        case .chatCompletions:
            return "/chat/completions"
        }
    }
    
    private var method: String {
        switch self {
        case .chatCompletions:
            return "POST"
        }
    }
    
    var urlRequest: URLRequest {
        let prefix = "https://api.openai.com/v1"
        
        let urlString = prefix + self.path
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        request.httpMethod = method
        
        return request
        
    }
}
