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
                        .padding(.bottom, 8)
                    
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

#Preview {
    IntroFlowContainer()
        .environmentObject(Router.shared)
}
