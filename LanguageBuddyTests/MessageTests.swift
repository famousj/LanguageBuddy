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
        }
    }
}
