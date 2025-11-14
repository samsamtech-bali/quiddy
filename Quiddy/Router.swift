//
//  Router.swift
//  Quiddy
//
//  Updated by Kelvin on 12/11/25.
//

import Foundation
import SwiftUI

enum Route: Hashable {
    case intro1               // NEW: Welcome screen
    case intro2               // NEW: Hard to quit screen
    case intro3               // NEW: Together screen
    case usernameView         // OnboardingThree
    case ciggerateView        // OnboardingFour
    case thankYouView         // Thank you screen
    case priceView            // OnboardingFive
    case costFeedbackView     // Cost feedback
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
