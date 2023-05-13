import XCTest
@testable import LanguageBuddy

final class MessageCreatorTests: XCTestCase {
    func test_messagesForPrompt_returnsCorrectMessages() {
        let language = "Tagalog"
        let testObject = MessageCreator(language: language)
        
        let prompt = String.random
        let messages = testObject.messagesForPrompt(prompt)
        
        XCTAssertEqual(messages.count, 2)
        
        let preface = messages.first
        let expectedPreface = Message(role: .user, content: "I am learning \(language)")
        expectedPreface.assertEqual(to: preface)
        
        let message = messages.last
        let expectedMessage = Message(role: .user, content: prompt)
        expectedMessage.assertEqual(to: message)
    }
}
