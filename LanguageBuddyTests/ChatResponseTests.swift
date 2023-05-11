import XCTest
@testable import LanguageBuddy

final class ChatResponseTests: XCTestCase {
    func test_parse() throws {
        let _: ChatResponse = try JSONLoader.load("chat-response.json")
    }
}
