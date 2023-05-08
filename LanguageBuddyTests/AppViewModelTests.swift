import XCTest
@testable import LanguageBuddy

final class AppViewModelTests: XCTestCase {
    func test_loginRequested_callsOpenAISession() {
        let session = FakeOpenAISession()
        
        let testObject = AppViewModel(openAISession: session)
        
        testObject.loginRequested()
        
        XCTAssertEqual(session.loginRequested_calledCount, 1)
    }
}
