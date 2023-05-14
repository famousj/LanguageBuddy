import Foundation
@testable import LanguageBuddy

extension Message {
    static var random: Message {
        Message(role: Role.random, content: String.random, name: nil)
    }
}
