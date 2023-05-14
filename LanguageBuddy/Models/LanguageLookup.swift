import Foundation

struct LanguageLookup: LanguageLookupable {
    private let client: OpenAIClientable
    init(client: OpenAIClientable = OpenAIClient()) {
        self.client = client
    }
    
    func lookupPrompt(model: Model,
                      language: String,
                      prompt: String) async -> ChatResult {
        let messages = MessageCreator(language: language)
            .messagesForPrompt(prompt)
        let result = await client.sendChatRequest(model: model, messages: messages)

        return result
    }
}
