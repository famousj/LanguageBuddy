import Foundation

enum Role: String {
    case system, user, assistant
}

extension Role: Codable {}

extension Role: CaseIterable {}
