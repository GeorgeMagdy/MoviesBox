//
//  Mock.swift
//  MovieHomeView
//
//  Created by George Magdy on 19/08/2025.
//

import Foundation

protocol Mocable: AnyObject {
    var bundle: Bundle { get }
    
    func loadJson<T: Decodable>(_ fileName: String, type: T.Type) -> T
}

extension Mocable {
    var bundle: Bundle {
        Bundle(for: type(of: self))
    }
    
    func loadJson<T: Decodable>(_ fileName: String, type: T.Type) -> T {
        guard let path = bundle.url(forResource: fileName, withExtension: "json"), let data = try? Data(contentsOf: path) else {
            fatalError()
        }
        do {
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            return decodedObject
        } catch {
            fatalError()
        }
    }
}
