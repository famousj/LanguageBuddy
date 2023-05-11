import XCTest
@testable import LanguageBuddy

extension Message {
    func assertEqual(to message: Message?) {
        XCTAssertEqual(self.role, message?.role)
        XCTAssertEqual(self.content, message?.content)
        XCTAssertEqual(self.name, message?.name)
    }
}
