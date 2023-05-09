import Foundation

extension OpenAIRequest {
    
    private var hostname: String {
        "https://api.openai.com"
    }
    
    private var path: String {
        switch self {
        case .chatCompletions:
            return "/v1/chat/completions"
        }
    }
    
    private var method: String {
        switch self {
        case .chatCompletions:
            return "POST"
        }
    }
    
    var urlRequest: URLRequest {
        let urlString = hostname + path
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        request.httpMethod = method
        
        return request
    }
}
