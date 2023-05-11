import XCTest
@testable import LanguageBuddy

final class OpenAIClientTests: XCTestCase {
    func test_sendChatRequest_usesCorrectRequestHeaders() async {
        let testObject = OpenAIClient()
        
        let session = FakeURLSession()
        session.data_returnData = Data()
        session.data_returnURLResponse = URLResponse()
        
        let _ = await testObject.sendChatRequest(messages: [], urlSession: session)
        
        XCTAssertEqual(session.data_calledCount, 1)
        
        let request = session.data_paramRequest
        
        let headerFields = request?.allHTTPHeaderFields!
        let actualHeaderKeys = Array(headerFields!.keys)
        let expectedHeaderKeys = ["Authorization", "Content-Type"]
        XCTAssertEqual(actualHeaderKeys, expectedHeaderKeys)
        
        let actualBody = request?.httpBody
        
        
    }

    func test_sendChatRequest_usesCorrectRequestBody() async {
        let testObject = OpenAIClient()
        
        let session = FakeURLSession()
        session.data_returnData = Data()
        session.data_returnURLResponse = URLResponse()
        
        let _ = await testObject.sendChatRequest(messages: [], urlSession: session)
        
        XCTAssertEqual(session.data_calledCount, 1)
        
        let request = session.data_paramRequest
        
        let headerFields = request?.allHTTPHeaderFields!
        let actualHeaderKeys = Array(headerFields!.keys)
        let expectedHeaderKeys = ["Authorization", "Content-Type"]
        XCTAssertEqual(actualHeaderKeys, expectedHeaderKeys)
    }

}
