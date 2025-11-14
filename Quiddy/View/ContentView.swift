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
            // Start with first intro screen
            IntroScreenOne()
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
            case .intro1:
                IntroScreenOne()
                
            case .intro2:
                IntroScreenTwo()
                
            case .intro3:
                IntroScreenThree()
                
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
                HomeView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(Router.shared)
}
