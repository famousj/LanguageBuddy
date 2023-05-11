import Foundation

struct OpenAIClient: OpenAIClientable {
    var clientCredential: String {
        // TODO: Use your own key here
        "OPENAI_API_KEY"
    }
    
    var defaultModel: String {
//        "gpt-3.5-turbo"
        "gpt-4"
    }
    
    func sendChatRequest(messages: [Message],
                         urlSession: URLSessionable = URLSession.shared) async -> ChatResult {
        var urlRequest = OpenAIRequest.chatCompletions.urlRequest
        
        urlRequest.setValue("Bearer \(clientCredential)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let model = defaultModel
        let openAIMessages = messages.map { OpenAIMessage(message: $0) }
        let chatRequest = ChatRequest(model: model,
                                      messages: openAIMessages)
        urlRequest.httpBody = try! JSONEncoder().encode(chatRequest)
        
        do {
            let (data, _) = try await urlSession.data(for: urlRequest)
            
            if let error = try? JSONDecoder().decode(OpenAIErrorResponse.self,
                                                     from: data) {
                return .failure(.serverError(error.error))
            }
            
            do {
                let response = try JSONDecoder().decode(ChatResponse.self, from: data)
                return .success(response)
            } catch {
                return .failure(.decodingError(error))
            }
        } catch {
            return .failure(.genericError(error))
        }
    }
}
