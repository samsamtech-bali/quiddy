//
//  OnboardingFive.swift
//  Quiddy
//
//  Created by stephan on 07/11/25.
//

import SwiftUI

struct OnboardingFive: View {
    @EnvironmentObject private var router: Router
    @EnvironmentObject private var registerVM: RegisterViewModel
    
    @State private var pricePerPackInput: String = ""
    @State private var pricePerPackInt: Int = 0
    @State private var daysPerPackInput: String = ""
    @State private var daysPerPackInt: Int = 0
    
    private var canContinue: Bool {
        !pricePerPackInput.isEmpty && pricePerPackInt > 0 && !daysPerPackInput.isEmpty && daysPerPackInt > 0
    }
    
    private func formatCurrency(_ value: String) -> String {
        let filtered = value.filter { "0123456789".contains($0) }
        guard let number = Int(filtered), number > 0 else { return "" }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        
        return formatter.string(from: NSNumber(value: number)) ?? filtered
    }
    
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
                    
                    ProgressBar(progress: 4, total: 6)
                        .padding(.leading, 12)
                    
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
                        Text("How much does a pack usually cost for you?")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 8) {
                            Text("Rp")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundColor(.white)
                            
                            TextField("25,000", text: $pricePerPackInput)
                                .keyboardType(.numberPad)
                                .onChange(of: pricePerPackInput) { newValue in
                                    let filtered = newValue.filter{"0123456789".contains($0)}
                                    
                                    if let newInt = Int(filtered) {
                                        pricePerPackInt = newInt
                                        pricePerPackInput = formatCurrency(filtered)
                                    } else if filtered.isEmpty {
                                        pricePerPackInt = 0
                                        pricePerPackInput = ""
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
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("How long does a pack last you?")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 12) {
                            TextField("2", text: $daysPerPackInput)
                                .keyboardType(.numberPad)
                                .onChange(of: daysPerPackInput) { newValue in
                                    let filtered = newValue.filter{"0123456789".contains($0)}
                                    if filtered != newValue {
                                        daysPerPackInput = filtered
                                    }
                                    
                                    if let newInt = Int(filtered) {
                                        daysPerPackInt = newInt
                                    } else if filtered.isEmpty {
                                        daysPerPackInt = 0
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
                                .frame(width: 100)
                            
                            Text("Days")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 40)
                
                Spacer()
                
                Button(action: {
                    registerVM.calculatePricePerCig(price: pricePerPackInt, days: daysPerPackInt)
                    router.path.append(Route.costFeedbackView)
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

#Preview {
    OnboardingFive()
        .environmentObject(Router.shared)
        .environmentObject(RegisterViewModel())
}

