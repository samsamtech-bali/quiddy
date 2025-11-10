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
            
            Text("IS SIGNED IN: \(cloudKitManager.isSignedInToiCloud)")
            Text("\(cloudKitManager.error)")
            
            Text("Permission Status: \(cloudKitManager.permissionStatus.description.uppercased())")
            Text("Name: \(cloudKitManager.username)")
            
            Button("Start", action: {
                router.path.append(Route.usernameView)
            })
            .navigationDestination(for: Route.self, destination: { route in
                switch route {
                case .usernameView:
                    OnboardingThree()
                        .environmentObject(router)
                        .environmentObject(registerViewModel)
                case .ciggerateView:
                    OnboardingFour()
                        .environmentObject(router)
                        .environmentObject(registerViewModel)
                case .priceView:
                    OnboardingFive()
                        .environmentObject(router)
                        .environmentObject(registerViewModel)
                case .successView:
                    OnboardingSix()
                        .environmentObject(registerViewModel)
                default:
                    OnboardingThree()
                        .environmentObject(router)
                        .environmentObject(registerViewModel)
                }
            }
            )
        }
        .padding()
    }
    
}

#Preview {
    
    ContentView()
        .environmentObject(Router.shared)
}
