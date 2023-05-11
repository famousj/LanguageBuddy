import Foundation

protocol UserSettingsStorable {
    func save(userSettings: UserSettings) async throws
    func load() async throws -> UserSettings
}
