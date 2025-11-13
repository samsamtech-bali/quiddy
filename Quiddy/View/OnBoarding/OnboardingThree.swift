//
//  OnboardingThree.swift
//  Quiddy
//
//  Created by stephan on 07/11/25.
//

import SwiftUI

struct OnboardingThree: View {
    @EnvironmentObject private var router: Router
    @EnvironmentObject private var registerVM: RegisterViewModel
    
    private var canContinue: Bool {
        !registerVM.username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        ZStack {
            Color(hex: "#0D0D11")
                .ignoresSafeArea()
    
            Button("Continue", action: {
                Task {
                    var generatedCode: String
                    
                    generatedCode = registerVM.generateRandomUniqueString()
                    
                    while await registerVM.isCodeExisted(code: generatedCode) == true {
                        generatedCode = registerVM.generateRandomUniqueString()
                    }
                    
                    registerVM.quiddyCode = generatedCode
                    
                    
                    router.path.append(Route.ciggerateView)
                }
            })
            .buttonStyle(.bordered)

            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    if !router.path.isEmpty {
                        Button(action: {
                            router.path.removeLast()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                        }
                    }
                    
                    ProgressBar(progress: 1, total: 6)
                        .padding(.leading, router.path.isEmpty ? 0 : 12)
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)
                
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
                
                Button(action: {
                    let generatedCode = registerVM.generateRandomUniqueString()
                    registerVM.quiddyCode = generatedCode
                    router.path.append(Route.ciggerateView)
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
                .disabled(!canContinue)
                .opacity(canContinue ? 1.0 : 0.5)
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
        .navigationBarHidden(true)
    }
}

