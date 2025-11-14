//
//  OnboardingFlowContainer.swift
//  Quiddy
//
//  Created by Kelvin on 14/11/25.
//

import SwiftUI

struct OnboardingFlowContainer: View {
    @EnvironmentObject private var router: Router
    @EnvironmentObject private var registerVM: RegisterViewModel
    @State private var currentPage: Int = 0
    
    var body: some View {
        ZStack {
            Color(hex: "#0D0D11")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Fixed Header with Back Button and Progress Bar
                HStack {
                    Button(action: {
                        if currentPage > 0 {
                            withAnimation {
                                currentPage -= 1
                            }
                        } else {
                            router.path.removeLast()
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }
                    .frame(width: 24, height: 24)
                    
                    ProgressBar(progress: currentPage + 1, total: 6)
                        .padding(.leading, 12)
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)
                .frame(height: 44)
                
                // Dynamic Content Area
                Group {
                    switch currentPage {
                    case 0:
                        OnboardingContentOne()
                    case 1:
                        OnboardingContentTwo()
                    case 2:
                        OnboardingContentThree()
                    case 3:
                        OnboardingContentFour()
                    case 4:
                        OnboardingContentFive()
                    case 5:
                        OnboardingContentSix()
                    default:
                        OnboardingContentOne()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Fixed Bottom Button
                Button(action: {
                    handleContinue()
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
                .disabled(!canContinue())
                .opacity(canContinue() ? 1.0 : 0.5)
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
        .navigationBarHidden(true)
    }
    
    private func canContinue() -> Bool {
        switch currentPage {
        case 0:
            return !registerVM.username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case 1:
            return registerVM.cigPerDay > 0
        case 2, 4:
            return true // Thank you and cost feedback screens auto-advance
        case 3:
            return registerVM.pricePerCig > 0
        case 5:
            return true // Drawing screen has its own validation in content
        default:
            return true
        }
    }
    
    private func handleContinue() {
        switch currentPage {
        case 0:
            let generatedCode = registerVM.generateRandomUniqueString()
            registerVM.quiddyCode = generatedCode
            withAnimation {
                currentPage += 1
            }
        case 1:
            withAnimation {
                currentPage += 1
            }
            // Auto-advance after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    currentPage += 1
                }
            }
        case 2:
            // Thank you screen - handled by auto-advance
            break
        case 3:
            withAnimation {
                currentPage += 1
            }
            // Auto-advance after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    currentPage += 1
                }
            }
        case 4:
            // Cost feedback - handled by auto-advance
            break
        case 5:
            // Save user data to CloudKit before navigating to main app
            Task {
                print("=== DATA ===")
                print("username: \(registerVM.username)")
                print("quiddyCode: \(registerVM.quiddyCode)")
                print("stopDate: \(registerVM.stopDate)")
                print("updatedStopDate: \(registerVM.updatedStopDate)")
                print("cigPerDay: \(registerVM.cigPerDay)")
                print("pricePerCig: \(registerVM.pricePerCig)")
                
                await registerVM.createNewUser(
                    username: registerVM.username,
                    quiddyCode: registerVM.quiddyCode,
                    stopDate: registerVM.stopDate,
                    updatedStopDate: registerVM.updatedStopDate,
                    cigPerDay: registerVM.cigPerDay,
                    pricePerCig: registerVM.pricePerCig
                )
            }
            router.path.append(Route.pageOne)
        default:
            break
        }
    }
}

// MARK: - Content Components

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

struct OnboardingContentFour: View {
    @EnvironmentObject private var registerVM: RegisterViewModel
    @State private var pricePerPackInput: String = ""
    @State private var pricePerPackInt: Int = 0
    @State private var daysPerPackInput: String = ""
    @State private var daysPerPackInt: Int = 0
    
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
                                    registerVM.calculatePricePerCig(price: pricePerPackInt, days: newInt)
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
        }
    }
}

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
    OnboardingFlowContainer()
        .environmentObject(Router.shared)
        .environmentObject(RegisterViewModel())
}
