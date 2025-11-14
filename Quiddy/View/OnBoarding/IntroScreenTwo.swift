//
//  IntroScreenTwo.swift
//  Quiddy
//
//  Created by Kelvin on 13/11/25.
//


import SwiftUI

struct IntroScreenTwo: View {
    @EnvironmentObject private var router: Router
    @State private var circleOpacity: Double = 0
    
    var body: some View {
        ZStack {
            Color(hex: "#0D0D11")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                Circle()
                    .fill(Color(hex: "#C1A7FF"))
                    .frame(width: 50, height: 50)
                    .opacity(circleOpacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.2)) {
                            circleOpacity = 1.0
                        }
                    }
                
                Spacer()
                
                VStack(spacing: 12) {
                    Text("Quitting smoking is hard.")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                    
                    Text("Nobody should have to do it alone.")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(Color(hex: "#8E8E93"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .padding(.bottom, 24)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                                impactFeedback.impactOccurred()
                            }
                        }
                    
                    Button(action: {
                        router.path.append(Route.intro3)
                    }) {
                        Text("I'm with you")
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
                    
                    PageIndicatorStatic(currentPage: 1, totalPages: 3)
                        .padding(.top, 16)
                        .padding(.bottom, 32)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    IntroScreenTwo()
        .environmentObject(Router.shared)
}

