import Foundation

extension Message {
    static var preview: Message {
        Message(role: Role.allCases.randomElement()!, content: String.random, name: nil)
    }
}

extension Message {
    static func previewArray(count: Int) -> [Message] {
        Array(0..<count)
            .map { _ in Message.preview }
    }
}
