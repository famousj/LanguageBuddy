import XCTest
@testable import LanguageBuddy

final class MessageTests: XCTestCase {    
    func test_messagesParse() throws {
        let messages: [Message] = try JSONLoader.load("messages.json")
        
        XCTAssertEqual(messages.count, Role.allCases.count)
        
        for role in Role.allCases {
            guard let message = messages
                .filter({ $0.role == role })
                .first else {
                XCTFail("Missing role in the JSON file: \(role)")
                return
            }
            
            XCTAssertEqual(message.content, role.rawValue)
            
            if message.name != nil {
                XCTAssertEqual(message.name, role.rawValue)
            }
        }
    }
    
    func test_isAssistantThinking() {
        let assistantThinking = Message(role: .assistant, content: "...")
        let notAssistant = Message(role: .user, content: "...")
        let notThinking = Message(role: .assistant, content: "something that isn't ellipses")
        
        XCTAssertEqual(assistantThinking.isAssistantThinking, true)
        XCTAssertEqual(notAssistant.isAssistantThinking, false)
        XCTAssertEqual(notThinking.isAssistantThinking, false)
    }
}
