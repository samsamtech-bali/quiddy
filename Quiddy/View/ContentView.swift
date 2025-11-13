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
                        
                    case .thankYouView:
                        OnboardingThankYou()
                        
                    case .priceView:
                        OnboardingFive()
                        
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
        .environmentObject(registerViewModel)
    }
}

#Preview {
    ContentView()
        .environmentObject(Router.shared)
}

//import SwiftUI
//
//struct ContentView: View {
//    @EnvironmentObject private var router: Router
//    @StateObject private var registerViewModel = RegisterViewModel()
//    @StateObject private var cloudKitManager = CloudKitManager()
//    
//    var body: some View {
//        NavigationStack(path: $router.path) {
//            // Start with OnboardingContainerView (the first 3 intro screens)
//            OnboardingContainerView()
//                .navigationBarHidden(true)
//                .navigationDestination(for: Route.self) { route in
//                    destinationView(for: route)
//                }
//        }
//        .environmentObject(registerViewModel)
//    }
//    
//    @ViewBuilder
//    private func destinationView(for route: Route) -> some View {
//        switch route {
//        case .onboarding:
//            OnboardingContainerView()
//            
//        case .usernameView:
//            OnboardingThree()
//            
//        case .ciggerateView:
//            OnboardingFour()
//            
//        case .priceView:
//            OnboardingFive()
//            
//        case .thankYouView:
//            OnboardingThankYou()
//            
//        case .costFeedbackView:
//            OnboardingCostFeedback()
//            
//        case .promiseView:
//            OnboardingSix()
//            
//        case .successView:
//            OnboardingSuccess()
//            
//        case .pageOne:
//            HomeView()
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//        .environmentObject(Router.shared)
//}
