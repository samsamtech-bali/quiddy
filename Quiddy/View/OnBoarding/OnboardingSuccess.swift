//
//  OnboardingSuccess.swift
//  Quiddy
//
//  Created by Kelvin on 12/11/25.
//


import SwiftUI

struct OnboardingSuccess: View {
    @EnvironmentObject private var router: Router
    
    var body: some View {
        ZStack {
            Color(hex: "#0D0D11")
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(Color(hex: "#C1A7FF"))
                
                Text("You're all set!")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Let's start your journey together")
                    .font(.system(size: 17))
                    .foregroundColor(Color(hex: "#8E8E93"))
                
                Button(action: {
                    // Navigate directly to HomeView
                    router.path.append(Route.pageOne)
                }) {
                    Text("Get Started")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.white, lineWidth: 1)
                        )
                }
                .padding(.horizontal, 32)
                .padding(.top, 16)
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    OnboardingSuccess()
}
