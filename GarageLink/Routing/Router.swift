//
//  Router.swift
//  GarageLink
//
//  Created by Hamza Hashmi on 04/01/2025.
//

import Foundation

final class Router: ObservableObject {
    
    @Published var onboardingPath: [OnboardingPath] = []
    
    static let shared = Router()
    
    init() {
        NotificationCenter.default.addObserver(
            forName: .onboardingPathChanged,
            object: nil,
            queue: .main) { notification in
                if let object = notification.object as? OnboardingPath {
                    self.onboardingPath.append(object)
                }
                else {
                    _ = self.onboardingPath.popLast()
                }
            }
    }
}

extension Notification.Name {
    static let onboardingPathChanged = Notification.Name("onboardingPathChanged")
}

enum OnboardingPath: Hashable {
    case signup
    case forgotPassword
}
