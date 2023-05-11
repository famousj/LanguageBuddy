import Foundation
@testable import LanguageBuddy

class FakeURLSession: URLSessionable {
    var data_calledCount = 0
    var data_paramRequest: URLRequest?
    var data_returnData: Data?
    var data_returnURLResponse: URLResponse?
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        data_calledCount += 1
        data_paramRequest = request
        
        return (data_returnData!, data_returnURLResponse!)
    }
    
    
}
