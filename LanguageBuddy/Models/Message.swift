// To parse the JSON, add this file to your project and do:
//
//   let message = try? newJSONDecoder().decode(Message.self, from: jsonData)

import Foundation

struct Message {
    let role: Role
    let content: String
    let name: String?
}

extension Message: Codable {}
