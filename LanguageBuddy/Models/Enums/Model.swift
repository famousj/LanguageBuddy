import Foundation

enum Model: String {
    case gpt3 = "gpt-3.5-turbo"
    case gpt4 = "gpt-4"
}

extension Model: Codable {}

extension Model: CaseIterable {}

extension Model: Identifiable {
    var id: String {
        self.rawValue
    }
}

extension Model {
    var name: String {
        switch self {
        case .gpt3:
            return "GPT-3"
        case .gpt4:
            return "GPT-4"
            
        }
    }
}

