//
//  AppCoordinator.swift
//  MoviesBox
//
//  Created by George Magdy on 18/08/2025.
//

import Foundation
import SwiftUI

enum AppRoute: Hashable {
    case detail(id: Int)
}

class AppCoordinator: ObservableObject {
    @Published public var path = NavigationPath()

      public init() {}

      public func navigateToDetail(id: Int) {
          path.append(AppRoute.detail(id: id))
      }

      public func goBack() {
          if !path.isEmpty {
              path.removeLast()
          }
      }
}
