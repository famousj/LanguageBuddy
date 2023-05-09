import Foundation



struct OpenAIClient: OpenAIClienting {
    var defaultModel: String {
        "gpt-3.5-turbo"
    }
    
    var defaultTemperature: Double {
        1
    }
    
    let requestBuilder: OpenAIRequestBuilding
    
    init(requestBuilder: OpenAIRequestBuilding) {
        self.requestBuilder = requestBuilder
    }
    
    func sendChatRequest(messages: [Message],
                         model: String?,
                         temperature: Double?) async throws -> Result<ChatCompletionResponse, Error> {
        
        let model = model ?? defaultModel
        let temperature = temperature ?? defaultTemperature
        
        var urlRequest = requestBuilder.buildRequest(.chatCompletions)
        
        let chatRequest = ChatCompletionRequest(model: defaultModel,
                                                messages: messages,
                                                temperature: defaultTemperature)
        urlRequest.httpBody = try! JSONEncoder().encode(chatRequest)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    print("Success!")
                } else {
                    print("Error: \(httpResponse.statusCode)")
                }
            }
        } catch {
            return Result.failure(error)
        }
    }
}
