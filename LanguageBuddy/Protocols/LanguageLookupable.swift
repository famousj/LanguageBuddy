import Foundation

protocol LanguageLookupable {
    func lookupPrompt(model: Model,
                      language: String,
                      prompt: String) async -> ChatResult
}
