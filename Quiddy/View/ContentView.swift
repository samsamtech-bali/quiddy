//
//  ContentView.swift
//  Quiddy
//
//  REFACTORED by Kelvin on 14/11/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var router: Router
    @EnvironmentObject private var registerVM: RegisterViewModel
    
    @State private var hasAccount: Bool = false
    
    var body: some View {
        Group {
            if hasAccount {
                MainTabView()
            } else {
                NavigationStack(path: $router.path) {
                    // Start with intro flow container
                    IntroFlowContainer()
                        .navigationBarHidden(true)
                        .navigationDestination(for: Route.self) { route in
                            destinationView(for: route)
                        }
                }
            }
        }
        .onAppear {
            Task {
                let currentRecord = try await registerVM.fetchByRecordName()
                
                print("current record: \(String(describing: currentRecord))")
                
                if currentRecord != nil {
                    print("user already has data...")
                    hasAccount = true
                    print("has account: \(hasAccount)")
                } else {
                    hasAccount = false
                    print("has account: \(hasAccount)")
                }
            }
        }
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
        .environmentObject(RegisterViewModel())
}
