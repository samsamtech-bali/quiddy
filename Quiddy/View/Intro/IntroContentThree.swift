//
//  IntroContentThree.swift
//  Quiddy
//
//  Created by stephan on 15/11/25.
//

import SwiftUI

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
    IntroContentThree()
}
