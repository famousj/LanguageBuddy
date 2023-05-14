import Foundation
@testable import LanguageBuddy

class FakeLanguageLookup: LanguageLookupable {
    var lookupPrompt_calledCount = 0
    var lookupPrompt_paramModel: Model?
    var lookupPrompt_paramLanguage: String?
    var lookupPrompt_paramPrompt: String?
    var lookupPrompt_returnResult: ChatResult?
    func lookupPrompt(model: Model,
                      language: String,
                      prompt: String) async -> ChatResult {
        lookupPrompt_calledCount += 1
        lookupPrompt_paramModel = model
        lookupPrompt_paramLanguage = language
        lookupPrompt_paramPrompt = prompt
        
        return lookupPrompt_returnResult!
    }
}
