//
//  IntroContentTwo.swift
//  Quiddy
//
//  Created by stephan on 15/11/25.
//

import SwiftUI

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

#Preview {
    IntroContentTwo()
}
