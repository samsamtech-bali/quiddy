//
//  OnboardingContentOne.swift
//  Quiddy
//
//  Created by stephan on 16/11/25.
//

import SwiftUI

struct OnboardingContentOne: View {
    @EnvironmentObject private var registerVM: RegisterViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(spacing: 8) {
                Text("Let's get to know your story")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Your answers will help shape the app\naround your needs.")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(Color(hex: "#8E8E93"))
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 24)
            .padding(.top, 40)
            
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("What can we call you?")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.white)
                    
                    TextField("e.g. John", text: $registerVM.username)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .font(.system(size: 17))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(hex: "#3A3A3C"), lineWidth: 1)
                        )
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 40)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingContentOne()
}
