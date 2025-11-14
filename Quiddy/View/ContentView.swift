//
//  ContentView.swift
//  Quiddy
//
//  REFACTORED by Kelvin on 14/11/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var router: Router
    @StateObject private var registerViewModel = RegisterViewModel()
//    @StateObject private var cloudKitManager = CloudKitManager()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            // Start with intro flow container
            IntroFlowContainer()
                .navigationBarHidden(true)
                .navigationDestination(for: Route.self) { route in
                    destinationView(for: route)
                }
        }
        .environmentObject(registerViewModel)
    }
    
    @ViewBuilder
    private func destinationView(for route: Route) -> some View {
        Group {
            switch route {
            case .intro1, .intro2, .intro3:
                // These are handled by IntroFlowContainer
                IntroFlowContainer()
                
            case .usernameView, .ciggerateView, .thankYouView, .priceView, .costFeedbackView, .promiseView:
                // All onboarding handled by OnboardingFlowContainer
                OnboardingFlowContainer()
                
            case .successView:
                OnboardingSuccess()
                
            case .pageOne:
                MainTabView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(Router.shared)
}
