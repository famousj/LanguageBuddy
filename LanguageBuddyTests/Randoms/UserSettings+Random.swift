import Foundation
@testable import LanguageBuddy

extension UserSettings {
    static var random: UserSettings {
        UserSettings(language: UUID().uuidString,
                     model: Model.allCases.randomElement()!)
    }
}
