//
//  File.swift
//  Utilities
//
//  Created by George Magdy on 18/08/2025.
//

import Foundation
import SwiftUI

public struct AlertItem: Identifiable, Sendable {
    public let id = UUID()
    public let title: Text
    public let message: Text
    public let dismissButtonTitle: String = "OK"
    
    public var dismissButton: Alert.Button {
        .default(Text(dismissButtonTitle))
    }
}

public struct AlertContext {
    public static let fileNotFound      = AlertItem(title: Text("Error"),
                                            message: Text("fileNotFound"))
    
    public static let decodingFailed  = AlertItem(title: Text("Error"),
                                            message: Text("decodingFailed"))
    
    public static let encodingFailed       = AlertItem(title: Text("Error"),
                                            message: Text("encodingFailed"))
    
    public static let unknown = AlertItem(title: Text("Error"),
                                            message: Text("unknown"))
    
    public static let unableToComplete = AlertItem(title: Text("Server Error"),
                                            message: Text("Unable to complete your request at this time"))
    
}
