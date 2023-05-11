import XCTest
@testable import LanguageBuddy

final class OpenAIErrorResponseTests: XCTestCase {
    func test_parse() throws {
        let _: OpenAIErrorResponse = try JSONLoader.load("openai-error-response.json")
    }
}
