//
//  OnboardingContentTwo.swift
//  Quiddy
//
//  Created by stephan on 16/11/25.
//

import SwiftUI

struct OnboardingContentTwo: View {
    @EnvironmentObject private var registerVM: RegisterViewModel
    @State private var stopDate: Date = Date.now
    @State private var smokePerDayInput: String = ""
    
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
                    Text("When was the last time you smoked?")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.white)
                    
                    DatePicker("", selection: $stopDate, in: ...Date(), displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .colorScheme(.dark)
                        .padding()
                        .background(Color.clear)
                        .onChange(of: stopDate) { newValue in
                            registerVM.stopDate = newValue
                            registerVM.updatedStopDate = newValue
                        }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("How many cigarettes do you usually have in a day?")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.white)
                    
                    TextField("e.g. 10", text: $smokePerDayInput)
                        .keyboardType(.numberPad)
                        .onChange(of: smokePerDayInput) { newValue in
                            let filtered = newValue.filter{"0123456789".contains($0)}
                            if filtered != newValue {
                                smokePerDayInput = filtered
                            }
                            
                            if let newInt = Int(filtered) {
                                registerVM.cigPerDay = newInt
                            } else if filtered.isEmpty {
                                registerVM.cigPerDay = 0
                            }
                        }
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
    OnboardingContentTwo()
}
