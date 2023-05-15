import Foundation

struct FileStore: FileStorable {
    private func fileURL(_ type: Any.Type) throws -> URL {
        let className = String(describing: type)
        
        return try FileManager.default.url(for: .documentDirectory,
                                           in: .userDomainMask,
                                           appropriateFor: nil,
                                           create: false)
        .appendingPathComponent("\(className).json")
    }
    
    func save<T: Codable>(_ object: T) async throws {
        let data = try JSONEncoder().encode(object)
        let fileURL = try fileURL(type(of: object))
        try data.write(to: fileURL)
    }
    
    func load<T: Codable>() async throws -> T? {
        let task: Task<T?, Error> = Task {
            let fileURL = try fileURL(T.self)
            guard let data = try? Data(contentsOf: fileURL) else {
                return nil
            }
            return try JSONDecoder().decode(T.self,
                                            from: data)
        }
        
        return try await task.value
    }
}
