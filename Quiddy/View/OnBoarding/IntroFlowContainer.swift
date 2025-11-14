//
//  IntroFlowContainer.swift
//  Quiddy
//
//  Created by Kelvin on 14/11/25.
//

import SwiftUI

struct IntroFlowContainer: View {
    @EnvironmentObject private var router: Router
    @State private var currentPage: Int = 0
    
    var body: some View {
        ZStack {
            Color(hex: "#0D0D11")
                .ignoresSafeArea()
            
            VStack {
                // Header with Back and Skip buttons
                HStack {
                    // Back button - only on screens 1 and 2
                    if currentPage > 0 {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentPage -= 1
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        }
                        .padding(.leading, 24)
                        .transition(.opacity)
                    }
                    
                    Spacer()
                    
                    // Skip button - only on first screen
                    if currentPage == 0 {
                        Button("Skip") {
                            router.path.append(Route.usernameView)
                        }
                        .foregroundColor(.white)
                        .padding(.trailing, 24)
                        .transition(.opacity)
                    }
                }
                .frame(height: 44)
                .padding(.top, 8)
                .animation(.easeInOut(duration: 0.3), value: currentPage)
                
                Spacer()
                
                // Dynamic Content Area
                Group {
                    switch currentPage {
                    case 0:
                        IntroContentOne()
                    case 1:
                        IntroContentTwo()
                    case 2:
                        IntroContentThree()
                    default:
                        IntroContentOne()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Spacer()
                
                // Fixed Bottom Section
                VStack(spacing: 16) {
                    // Page Indicators - Fixed Position
                    PageIndicatorStatic(currentPage: currentPage, totalPages: 3)
                        .padding(.top, 24)
                        .padding(.bottom, 16)
                    
                    // Button - Fixed Position
                    Button(action: {
                        if currentPage < 2 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentPage += 1
                            }
                        } else {
                            router.path.append(Route.usernameView)
                        }
                    }) {
                        Text(currentPage == 0 ? "Get started" : currentPage == 1 ? "I'm with you" : "Sounds good")
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
                    .padding(.bottom, 32)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Content Components (Only visual content, no buttons/indicators)

struct IntroContentOne: View {
    var body: some View {
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
            }
        }
    }
}

struct IntroContentTwo: View {
    @State private var circleOpacity: Double = 0
    
    var body: some View {
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()
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
            }
        }
    }
}

struct IntroContentThree: View {
    @State private var circleOffset: CGFloat = 120
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            HStack(spacing: 0) {
                Circle()
                    .fill(Color(hex: "#C1A7FF"))
                    .frame(width: 50, height: 50)
                    .offset(x: circleOffset)
                
                Circle()
                    .fill(Color(hex: "#8CBFFF"))
                    .frame(width: 50, height: 50)
                    .offset(x: -circleOffset)
            }
            .onAppear {
                withAnimation(.easeOut(duration: 1.5)) {
                    circleOffset = 48
                }
            }
            
            Spacer()
            
            VStack(spacing: 12) {
                Text("Here, you don't quit by yourself.")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                
                Text("You'll choose someone to walk this with you a friend, partner, sibling, anyone you trust.")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(Color(hex: "#8E8E93"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
        }
    }
}

#Preview {
    IntroFlowContainer()
        .environmentObject(Router.shared)
}
