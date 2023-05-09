import Foundation

protocol URLSessionable {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}
