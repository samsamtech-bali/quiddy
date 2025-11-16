//
//  OnboardingContentSix.swift
//  Quiddy
//
//  Created by stephan on 16/11/25.
//

import SwiftUI

struct OnboardingContentSix: View {
    @State private var hasDrawn = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .center, spacing: 8) {
                Text("Just a small promise")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Not to be perfect but to just keep trying.")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(Color(hex: "#8E8E93"))
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 24)
            .padding(.top, 40)
            
            Spacer()
            
            DrawingCanvasView(hasDrawn: $hasDrawn)
                .padding(.horizontal, 24)
            
            Text("Draw the check when you're ready.")
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(Color(hex: "#8E8E93"))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 24)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingContentSix()
}
