//
//  OnboardingOne.swift
//  Quiddy
//
//  Created by Kelvin on 11/11/25.
//

import SwiftUI

struct OnboardingOne: View {
    @Binding var currentPage: Int
    
    var body: some View {
        ZStack {
            Color(hex: "#0D0D11")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                Circle()
                    .fill(Color(hex: "#D9D9D9"))
                    .frame(width: 120, height: 120)
                
                Spacer()
                
                VStack(spacing: 12) {
                    Text("Welcome. We're glad you're here.")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                    
                    Text("Just opening this app is already a step forward.")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(Color(hex: "#8E8E93"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .padding(.bottom, 24)
                    
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentPage = 1
                        }
                    }) {
                        Text("Get started")
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
                    
                    PageIndicator(currentPage: 0, totalPages: 3)
                        .padding(.top, 16)
                        .padding(.bottom, 32)
                }
            }
        }
    }
}

#Preview {
    OnboardingOne(currentPage: .constant(0))
}
