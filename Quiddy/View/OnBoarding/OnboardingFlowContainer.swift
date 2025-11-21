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
    @State private var hasDrawnPromise: Bool = false
    
    var body: some View {
        ZStack {
            Color(hex: "#0D0D11")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Fixed Header with Back Button and Progress Bar
                HStack {
                    Button(action: {
                        HapticsManager.shared.selection()
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
                
                // Fixed Bottom Button - Hidden on auto-advance screens
                if currentPage != 2 && currentPage != 4 {
                    Button(action: {
                        HapticsManager.shared.selection()
                        handleContinue()
                    }) {
                        Text(currentPage == 5 ? "I promise myself" : "Continue")
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
                } else {
                    Spacer()
                        .frame(height: 80) // Maintain spacing when button is hidden
                }
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
            return hasDrawnPromise // Drawing screen validation
            
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
            
            // Auto-advance after delay with haptic
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                HapticsManager.shared.pageTransition()
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
            
            // Auto-advance after delay with haptic
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                HapticsManager.shared.pageTransition()
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
                
                // Final commitment - success haptic
                HapticsManager.shared.mediumImpact()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    HapticsManager.shared.success()
                    
                }
                router.path.append(Route.pageOne)
            }
        default:
            break
            
        }
    }
}

#Preview {
    OnboardingFlowContainer()
        .environmentObject(Router.shared)
        .environmentObject(RegisterViewModel())
}
