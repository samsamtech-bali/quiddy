//
//  Router.swift
//  Quiddy
//
//  Updated by Kelvin on 12/11/25.
//

import Foundation
import SwiftUI

enum Route: Hashable {
    case onboarding           // NEW: Initial onboarding container
    case usernameView         // OnboardingThree
    case ciggerateView        // OnboardingFour
    case priceView            // OnboardingFive
    case thankYouView         // NEW: Thank you screen
    case costFeedbackView     // NEW: Cost feedback
    case promiseView          // OnboardingSix
    case successView          // Final success
    case pageOne              // Home/Main app
}

final class Router: ObservableObject {
    @Published var path = NavigationPath()
    
    static let shared = Router()
    
    private init() {
        
    }
    
    func resetToOnboarding() {
        path = NavigationPath()
    }
    
    func navigateToHome() {
        path = NavigationPath()
        path.append(Route.pageOne)
    }
}
