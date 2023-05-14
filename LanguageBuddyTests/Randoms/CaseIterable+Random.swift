import Foundation
@testable import LanguageBuddy

extension CaseIterable {
    static var random: Self.AllCases.Element {
        Self.allCases.randomElement()!
    }
}
