import Foundation

struct ChatCompletionRequest {
    let model: String
    let messages: [Message]
    let temperature: Double?
    let topP: Double?
    let n: Int?
    let stream: Bool?
    let stop: [String]?
    let maxTokens: Int?
    let presencePenalty: Double?
    let frequencyPenalty: Double?
    let logitBias: [String: Int]?
    let user: String?
}

extension ChatCompletionRequest: Codable {
    enum CodingKeys: String, CodingKey {
        case model, messages, temperature
        case topP = "top_p"
        case n, stream, stop
        case maxTokens = "max_tokens"
        case presencePenalty = "presence_penalty"
        case frequencyPenalty = "frequency_penalty"
        case logitBias = "logit_bias"
        case user
    }
}

extension ChatCompletionRequest {
    init(model: String, messages: [Message], temperature: Double) {
        self.model = model
        self.messages = messages
        self.temperature = temperature
        self.topP = nil
        self.n = nil
        self.stream = nil
        self.stop = nil
        self.maxTokens = nil
        self.presencePenalty = nil
        self.frequencyPenalty = nil
        self.logitBias = nil
        self.user = nil

    }
}
