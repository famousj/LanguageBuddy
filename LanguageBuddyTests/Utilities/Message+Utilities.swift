import XCTest
@testable import LanguageBuddy

extension Message {
    func assertEqual(to message: Message?) {
        XCTAssertEqual(self.role, message?.role)
        XCTAssertEqual(self.content, message?.content)
        XCTAssertEqual(self.name, message?.name)
    }
}

extension [Message] {
    func assertEqual(to messages: [Message]) {
        for (i, message) in self.enumerated() {
            message.assertEqual(to: messages[i])
        }
    }
}
