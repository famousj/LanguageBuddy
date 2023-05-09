import XCTest
@testable import LanguageBuddy

final class OpenAIRequestBuilderTests: XCTestCase {
    func test_buildRequest_chat() {
        let testObject = OpenAIRequestBuilder()
        
        let request = testObject.buildRequest(.chatCompletions)
        
        XCTAssertEqual(request.url?.absoluteString,
                       "https://api.openai.com/v1/chat/completions")
        XCTAssertEqual(request.httpMethod, "POST")
        let expectedHeaderKeys = ["Authorization", "Content-Type"]
        let actualHeaderKeys = Array(request.allHTTPHeaderFields!.keys)
        XCTAssertEqual(actualHeaderKeys, expectedHeaderKeys)
    }
}
