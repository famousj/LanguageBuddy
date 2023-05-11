import Foundation

struct ChatRequest {
    let model: String
    let messages: [OpenAIMessage]
    let temperature: Double?
    let topProbabilityMass: Double?
    let n: Int?
    let stream: Bool?
    let stop: [String]?
    let maxTokens: Int?
    let presencePenalty: Double?
    let frequencyPenalty: Double?
    let logitBias: [String: Int]?
    let user: String?
}

extension ChatRequest: Codable {
    enum CodingKeys: String, CodingKey {
        case model, messages, temperature
        case topProbabilityMass = "top_p"
        case n, stream, stop
        case maxTokens = "max_tokens"
        case presencePenalty = "presence_penalty"
        case frequencyPenalty = "frequency_penalty"
        case logitBias = "logit_bias"
        case user
    }
}

extension ChatRequest {
    init(model: String, messages: [OpenAIMessage]) {
        self.model = model
        self.messages = messages
        self.temperature = nil
        self.topProbabilityMass = nil
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
