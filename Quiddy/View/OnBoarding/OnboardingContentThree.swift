//
//  OnboardingContentThree.swift
//  Quiddy
//
//  Created by stephan on 16/11/25.
//

import SwiftUI

struct OnboardingContentThree: View {
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Text("Thank you! This helps us to support\nyour journey better")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingContentThree()
}
