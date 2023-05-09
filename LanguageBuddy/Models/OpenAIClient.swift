import Foundation

struct OpenAIClient: OpenAIClienting {
    var clientCredential: String {
        // TODO: Use your own key here
        "OPENAI_API_KEY"
    }
    
    var defaultModel: String {
        "gpt-3.5-turbo"
    }
    
    var defaultTemperature: Double {
        1
    }
    
    // TODO: Test me
    func sendChatRequest(messages: [Message]) async throws -> Result<ChatCompletionResponse, OpenAIError> {
        var urlRequest = OpenAIRequest.chatCompletions.urlRequest
        
        urlRequest.setValue("Bearer \(clientCredential)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let model = defaultModel
        let temperature = defaultTemperature
        let chatRequest = ChatCompletionRequest(model: model,
                                                messages: messages,
                                                temperature: temperature)
        urlRequest.httpBody = try! JSONEncoder().encode(chatRequest)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            
            if let error = try? JSONDecoder().decode(OpenAIErrorResponse.self,
                                                     from: data) {
                return .failure(.serverError(error.error))
            }
            
            do {
                let response = try JSONDecoder().decode(ChatCompletionResponse.self, from: data)
                return .success(response)
            } catch {
                return .failure(.decodingError(error))
            }
        } catch {
            return .failure(.genericError(error))
        }
    }
}
