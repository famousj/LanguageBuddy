import Foundation

class FakeAppViewModel: AppViewModelable {
    var messages: [Message] {
        Array(0...100)
            .map { Message(role: Role.allCases.randomElement()!, content: "\($0)", name: nil) }
    }
}
