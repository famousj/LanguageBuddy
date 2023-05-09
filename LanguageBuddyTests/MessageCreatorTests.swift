import XCTest
@testable import LanguageBuddy

final class MessageCreatorTests: XCTestCase {
    func test_messagesForPrompt_returnsCorrectMessages() {
        let testObject = MessageCreator()
        
        let prompt = String.random
        let messages = testObject.messagesForPrompt(prompt)
        
        XCTAssertEqual(messages.count, 1)
        
        let message = messages.first
        let expectedMessage = Message(role: .user, content: prompt)
        XCTAssert(message!.isEqualTo(expectedMessage))
    }
}
