import Foundation
@testable import LanguageBuddy

extension Message {
    static var random: Message {
        Message(role: Role.allCases.randomElement()!, content: String.random, name: nil)
    }
}
