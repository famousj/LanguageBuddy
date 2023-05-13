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
    
    func test_messagesForLanguageLookup_returnsCorrectMessages() {
        let language = "Urdu"
        let testObject = MessageCreator(language: language)
        
        let content = String.random
        let message = Message(role: .assistant, content: content)
        
        let messages = testObject.messagesForLanguageLookup(message)
        
        let expectedContent = "List the phrases in this message that are \(language):\n\(content)"
        let expectedMessage = Message(role: .user, content: expectedContent)
        
        [expectedMessage].assertEqual(to: messages)
    }
}
