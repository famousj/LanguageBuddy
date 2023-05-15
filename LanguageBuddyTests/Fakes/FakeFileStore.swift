import Foundation
@testable import LanguageBuddy

class FakeFileStore: FileStorable {
    var save_calledCount = 0
    var save_paramObject: Any?
    func save<T: Codable>(_ object: T) async throws {
        save_calledCount += 1
        save_paramObject = object
    }
    
    var load_calledCount = 0
    var load_returnObject: Any?
    var load_error: Error?
    func load<T: Codable>() async throws -> T? {
        load_calledCount += 1
        
        if let load_error = load_error {
            throw load_error
        }
        
        return load_returnObject as! T?
    }
}
