import Foundation

struct UserSettings {
    var language: String
    var model: Model
    var messageHistory: [Message]
    
    static var defaultSettings: UserSettings {
        UserSettings(language: "European Portuguese", model: .gpt4, messageHistory: [])
    }
}

extension UserSettings: Codable {}
extension UserSettings: Equatable {}

extension UserSettings {
    static var empty: UserSettings {
        UserSettings(language: "", model: .gpt4, messageHistory: [])
    }
}
