//
//  OnboardingContainer.swift
//  Quiddy
//
//  Created by Kelvin on 11/11/25.
//

import SwiftUI

struct OnboardingContainerView: View {
    @EnvironmentObject private var router: Router
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            Color(hex: "#0D0D11")
                .ignoresSafeArea()
            
            TabView(selection: $currentPage) {
                OnboardingOne(currentPage: $currentPage)
                    .tag(0)
                
                OnboardingTwo(currentPage: $currentPage)
                    .tag(1)
                
                OnboardingTwoPointFive(currentPage: $currentPage)
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            // Skip button only on first screen
            VStack {
                HStack {
                    Spacer()
                    if currentPage == 0 {
                        Button("Skip") {
                            router.path.append(Route.usernameView)
                        }
                        .foregroundColor(.white)
                        .padding(.trailing, 24)
                        .padding(.top, 8)
                        .transition(.opacity)
                    }
                }
                Spacer()
            }
            .animation(.easeInOut(duration: 0.3), value: currentPage)
        }
    }
}

#Preview {
    OnboardingContainerView()
        .environmentObject(Router.shared)
}

