//
//  File.swift
//  CachingHandler
//
//  Created by George Magdy on 17/08/2025.
//

import Foundation

public enum CError: Error, Equatable, Identifiable {
    case fileNotFound
    case decodingFailed
    case encodingFailed
    case unknown(Error)
    
    public var id: String {
        switch self {
        case .fileNotFound:
            return "fileNotFound"
        case .decodingFailed:
            return "decodingFailed"
        case .encodingFailed:
            return "encodingFailed"
        case .unknown(let error):
            return "unknown \(error.localizedDescription)"
        }
    }
    
    public static func == (lhs: CError, rhs: CError) -> Bool {
        switch (lhs, rhs) {
        case (.fileNotFound, .fileNotFound),
            (.decodingFailed, .decodingFailed),
            (.encodingFailed, .encodingFailed) :
            return true
        case (.unknown, .unknown):
            return false
        default :
            return false
        }
    }
}

public final class CachingHandler: @unchecked Sendable  {
    
    private let queue = DispatchQueue(label: "CachingHandler.queue", attributes: .concurrent)
    
    public init() {}
    
    private func getFileURL(_ fileName: String) -> URL {
        let fileWithExtension = fileName.hasSuffix(".json") ? fileName : fileName + ".json"
        let fileManager = FileManager.default
        let dirURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return dirURL.appendingPathComponent(fileWithExtension)
    }
    
    public func saveToFile<T: Codable & Sendable>(_ response: T, fileName: String) {
        queue.async(group: nil, qos: .default, flags: .barrier) { [weak self] in
            guard let self else { return }
            let fileURL = self.getFileURL(fileName)
            do {
                let data = try JSONEncoder().encode(response)
                try data.write(to: fileURL)
            } catch {
                print("Failed to save dictionary:", error)
            }
            print("saved to \(fileURL)")
        }
    }
    
    public func loadFromFile<T: Codable>(_ type: T.Type, fileName: String) -> Result<T, CError> {
        
        var result: Result<T, CError>!
        
        queue.sync {
            let fileURL = getFileURL(fileName)

            guard FileManager.default.fileExists(atPath: fileURL.path) else {
                result = .failure(.fileNotFound)
                return
            }
            do {
                let data = try Data(contentsOf: fileURL)
                let decoded = try JSONDecoder().decode(T.self, from: data)
                print("Loaded file successfully from \(fileURL)")
                result = .success(decoded)
            } catch is DecodingError {
                result = .failure(.decodingFailed)
            } catch {
                result = .failure(.unknown(error))
            }
        }
        
        switch result {
        case .success(let decoded):
            return .success(decoded)
        case .failure(let error):
            return .failure(error)
        case .none:
            // This should never happen but just in case
            return .failure(.unknown(NSError(domain: "", code: 0, userInfo: nil)))
        }
    }
    
    public func removeFile(fileName: String) throws {
        let fileURL = getFileURL(fileName)
        try FileManager.default.removeItem(at: fileURL)
        print("File removed successfully at \(fileURL)")
    }
}
