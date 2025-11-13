//
//  ContentView.swift
//  Quiddy
//
//  Created by stephan on 05/11/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var router: Router
    @StateObject private var registerViewModel = RegisterViewModel()
    @StateObject private var cloudKitManager = CloudKitManager()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            // Start with OnboardingContainerView (the first 3 intro screens)
            OnboardingContainerView()
                .navigationBarHidden(true)
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .onboarding:
                        OnboardingContainerView()
                        
                    case .usernameView:
                        OnboardingThree()
                        
                    case .ciggerateView:
                        OnboardingFour()
                        
                    case .priceView:
                        OnboardingFive()
                        
                    case .thankYouView:
                        OnboardingThankYou()
                        
                    case .costFeedbackView:
                        OnboardingCostFeedback()
                        
                    case .promiseView:
                        OnboardingSix()
                        
                    case .successView:
                        OnboardingSuccess()
                        
                    case .pageOne:
                        MainTabView()
                            .environmentObject(registerViewModel)
                    }
                }
        }
        .environmentObject(registerViewModel)
    }
}

#Preview {
    ContentView()
        .environmentObject(Router.shared)
}
