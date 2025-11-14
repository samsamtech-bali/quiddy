//
//  IntroScreenThree.swift
//  Quiddy
//
//  Created by Kelvin on 13/11/25.
//


import SwiftUI

struct IntroScreenThree: View {
    @EnvironmentObject private var router: Router
    @State private var circleOffset: CGFloat = 120
    
    var body: some View {
        ZStack {
            Color(hex: "#0D0D11")
                .ignoresSafeArea()
            
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
                        .padding(.bottom, 24)
                    
                    Button(action: {
                        router.path.append(Route.usernameView)
                    }) {
                        Text("Sounds good")
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
                    
                    PageIndicatorStatic(currentPage: 2, totalPages: 3)
                        .padding(.top, 16)
                        .padding(.bottom, 32)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    IntroScreenThree()
        .environmentObject(Router.shared)
}
