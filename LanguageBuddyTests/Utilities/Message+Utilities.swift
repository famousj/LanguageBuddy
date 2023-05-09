import Foundation
@testable import LanguageBuddy

extension Message {
    func isEqualTo(_ message: Message) -> Bool {
        self.role == message.role &&
        self.content == message.content &&
        self.name == message.name
    }
}
