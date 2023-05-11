import Foundation

enum Model: String {
    case gpt3 = "gpt-3.5-turbo"
    case gpt4 = "gpt-4"
}

extension Model: Codable {}

extension Model: CaseIterable {}
