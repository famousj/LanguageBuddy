import Foundation

struct UserSettings {
    let language: String
    let model: Model
    
    static var defaultSettings: UserSettings {
        UserSettings(language: "European Portuguese", model: .gpt4)
    }
}

extension UserSettings: Codable {}
extension UserSettings: Equatable {}
