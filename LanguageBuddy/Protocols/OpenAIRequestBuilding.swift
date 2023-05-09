import Foundation

protocol OpenAIRequestBuilding {
    func buildRequest(_ request: OpenAIRequest) -> URLRequest
}
