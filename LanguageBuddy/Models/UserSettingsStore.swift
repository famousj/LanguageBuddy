import Foundation

struct UserSettingsStore: UserSettingsStorable {
    private let filename = "usersettings.json"
    private func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent(filename)
    }
    
    func save(userSettings: UserSettings) async throws {
         let task = Task {
            let data = try JSONEncoder().encode(userSettings)
            let fileURL = try fileURL()
            try data.write(to: fileURL)
        }
        
        try await task.value
    }
    
    func load() async throws -> UserSettings {
        let task = Task<UserSettings, Error> {
            let fileURL = try fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return UserSettings.defaultSettings
            }
            return try JSONDecoder().decode(UserSettings.self,
                                            from: data)
        }
        
        return try await task.value
    }
}
