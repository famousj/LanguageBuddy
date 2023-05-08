import Foundation
@testable import LanguageBuddy

class FakeOpenAISession: OpenAISessioning {
    var loginRequested_calledCount = 0
    func loginRequested() {
        loginRequested_calledCount += 1
    }
}
