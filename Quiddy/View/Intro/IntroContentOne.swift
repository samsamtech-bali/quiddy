//
//  IntroContentOne.swift
//  Quiddy
//
//  Created by stephan on 15/11/25.
//

import SwiftUI 

struct IntroContentOne: View {
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Image("QuibyLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
            
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

#Preview {
    IntroContentOne()
}
