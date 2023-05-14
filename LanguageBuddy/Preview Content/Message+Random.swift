import Foundation

extension Message {
    static var random: Message {
        Message(role: Role.allCases.randomElement()!,
                content: String.random, name: nil)
    }
}

extension Message {
    static func randomArray(count: Int) -> [Message] {
        Array(0..<count)
            .map { _ in Message.random }
    }
}
