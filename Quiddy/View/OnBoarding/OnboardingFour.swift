//
//  OnboardingFour.swift
//  Quiddy
//
//  Created by stephan on 07/11/25.
//

import SwiftUI

struct OnboardingFour: View {
    @EnvironmentObject private var router: Router
    @EnvironmentObject private var registerVM: RegisterViewModel
    
    @State private var stopDate: Date = Date.now
    @State private var smokePerDayInput: String = ""
    
    var body: some View {
        ZStack {
            Color(hex: "#0D0D11")
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Button(action: {
                        router.path.removeLast()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }
                    
                    ProgressBar(progress: 2, total: 6)
                        .padding(.leading, 12)
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Let's get to know your story")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Your answers will help shape the app\naround your needs.")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(Color(hex: "#8E8E93"))
                }
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
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(hex: "#3A3A3C"), lineWidth: 1)
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("How many cigarettes do you usually have in a day?")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.white)
                        
                        TextField("e.g. John", text: $smokePerDayInput)
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
                
                Button(action: {
                    registerVM.stopDate = stopDate
                    registerVM.updatedStopDate = stopDate
                    router.path.append(Route.priceView)
                }) {
                    Text("Continue")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.white, lineWidth: 1)
                        )
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
        .navigationBarHidden(true)
    }
}
