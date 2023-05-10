import XCTest
@testable import LanguageBuddy

final class AppViewModelTests: XCTestCase {
    func test_newPrompt_addsNewMessage() {
        let testObject = AppViewModel()
        
        XCTAssertEqual(testObject.messages.count, 0)
        
        let prompt = String.random
        testObject.currentPrompt = prompt
        testObject.newPrompt()
        
        XCTAssertEqual(testObject.messages.count, 1)
        
        let message = testObject.messages.first
        let expectedMessage = Message(role: .user, content: prompt)
        XCTAssert(message!.isEqualTo(expectedMessage))
    }
    
    func test_newPrompt_clearsCurrentPrompt() {
        let testObject = AppViewModel()

        testObject.currentPrompt = String.random
        
        testObject.newPrompt()
        
        XCTAssertEqual(testObject.currentPrompt, "")
    }
    
    func test_newPrompt_whenCurrentPromptIsEmpty_noAction() {
        let testObject = AppViewModel()

        testObject.currentPrompt = ""
        
        testObject.newPrompt()
        
        XCTAssertEqual(testObject.messages.count, 0)
    }
}
