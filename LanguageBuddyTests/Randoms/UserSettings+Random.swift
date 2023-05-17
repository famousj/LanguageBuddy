import Foundation
@testable import LanguageBuddy

extension UserSettings {
    static var random: UserSettings {
        let messageHistory = (0...Int.random).map { _ in Message.random }
        return UserSettings(language: UUID().uuidString,
                     model: Model.random,
                     messageHistory: messageHistory)
    }
}
