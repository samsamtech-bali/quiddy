//
//  OnboardingThankyou.swift
//  Quiddy
//
//  Created by Kelvin on 11/11/25.
//

import SwiftUI

struct OnboardingThankYou: View {
    @EnvironmentObject private var router: Router
    
    var body: some View {
        ZStack {
            Color(hex: "#0D0D11")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        router.path.removeLast()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }
                    
                    ProgressBar(progress: 3, total: 6)
                        .padding(.leading, 12)
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)
                
                Spacer()
                
                Text("Thank you! This helps us to support\nyour journey better")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                router.path.append(Route.priceView)
            }
        }
    }
}

#Preview {
    OnboardingThankYou()
        .environmentObject(Router.shared)
}

