import Foundation
@testable import LanguageBuddy

class FakeUserSettingsStore: UserSettingsStorable {
    var save_calledCount = 0
    var save_paramUserSettings: UserSettings?
    func save(userSettings: UserSettings) async throws {
        save_calledCount += 1
        save_paramUserSettings = userSettings
    }
    
    var load_calledCount = 0
    var load_returnUserSettings: UserSettings?
    var load_error: Error?
    func load() async throws -> LanguageBuddy.UserSettings {
        load_calledCount += 1
        
        if let load_error = load_error {
            throw load_error
        }
        
        return load_returnUserSettings!
    }
}
