import XCTest
@testable import LanguageBuddy

fileprivate struct TestCodable: Codable, Equatable {
    let a: String
    let b: Int
}

final class FileStoreTests: XCTestCase {
    override func setUpWithError() throws {
        try deleteFile()
    }
    
    override func tearDownWithError() throws {
        try deleteFile()
    }
    
    func test_saveAndLoad() async throws {
        let testObject = FileStore()
        
        let codable = TestCodable(a: String.random, b: Int.random)
        
        try await testObject.save(codable)
        
        let loadedCodable: TestCodable? = try await testObject.load()
        XCTAssertEqual(loadedCodable, codable)
    }
    
    func test_saveCanOverwrite() async throws {
        let testObject = FileStore()
        let codable = TestCodable(a: String.random, b: Int.random)
        try await testObject.save(codable)
        
        let anotherCodable = TestCodable(a: String.random, b: Int.random)
        try await testObject.save(anotherCodable)
        
        let loadedCodable: TestCodable? = try await testObject.load()
        XCTAssertEqual(loadedCodable, anotherCodable)
    }
    
    private let filename = "TestCodable.json"
    
    private var fileURL: URL {
        try! FileManager.default.url(for: .documentDirectory,
                                     in: .userDomainMask,
                                     appropriateFor: nil,
                                     create: false)
        .appendingPathComponent(filename)
    }
    
    private func deleteFile() throws {
        try? FileManager.default.removeItem(at: fileURL)
    }
}
