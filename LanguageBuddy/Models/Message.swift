import Foundation

struct Message {
    let role: Role
    let content: String
    let name: String?
}

extension Message: Codable {}
