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
    
    var defaultTemperature: Double {
        1
    }
    
    // TODO: Test me
    func sendChatRequest(messages: [Message],
                         urlSession: URLSessionable = URLSession.shared) async -> Result<ChatResponse, OpenAIError> {
        var urlRequest = OpenAIRequest.chatCompletions.urlRequest
        
        urlRequest.setValue("Bearer \(clientCredential)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let model = defaultModel
        let openAIMessages = messages.map { OpenAIMessage(message: $0) }
        let temperature = defaultTemperature
        let chatRequest = ChatRequest(model: model,
                                      messages: openAIMessages,
                                                temperature: temperature)
        urlRequest.httpBody = try! JSONEncoder().encode(chatRequest)
        print("BODY: \(String(data: urlRequest.httpBody!, encoding: .utf8)!)")
        
        do {
            let (data, _) = try await urlSession.data(for: urlRequest)
            print("RESPONSE: \(String(data: data, encoding: .utf8) ?? "???")")
            
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
