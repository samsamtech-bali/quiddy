//
//  OnboardingContentFive.swift
//  Quiddy
//
//  Created by stephan on 16/11/25.
//

import SwiftUI

struct OnboardingContentFive: View {
    @EnvironmentObject private var registerVM: RegisterViewModel
    
    var monthlyCost: Int {
        let dailyCost = registerVM.pricePerCig * Double(registerVM.cigPerDay)
        return Int(dailyCost * 30)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 8) {
                Text("Rp \(monthlyCost) a month.")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Could go to something better.")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, 32)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingContentFive()
}
