import Foundation

protocol FileStorable {
    func save<T: Codable>(_ object: T) async throws
    func load<T: Codable>() async throws -> T?
}
