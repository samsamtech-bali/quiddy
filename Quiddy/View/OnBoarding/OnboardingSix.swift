//
//  OnboardingSix.swift
//  Quiddy
//
//  Created by stephan on 07/11/25.
//


import SwiftUI

struct OnboardingSix: View {
    @EnvironmentObject private var router: Router
    @EnvironmentObject private var registerVM: RegisterViewModel
    @State private var hasDrawn = false
    
    var body: some View {
        ZStack {
            Color(hex: "#0D0D11")
                .ignoresSafeArea()
            
            Text("quiddy code: \(registerVM.quiddyCode)")
            Button(
                "Continue",
                action: {
                    Task {
                       let userData = await registerVM.createNewUser(
                            username: registerVM.username,
                            quiddyCode: registerVM.quiddyCode,
                            stopDate: registerVM.stopDate,
                            updatedStopDate: registerVM.updatedStopDate,
                            cigPerDay: registerVM.cigPerDay,
                            pricePerCig: registerVM.pricePerCig
                        )
                        
                        
                        print("user data: \(String(describing: userData))")
                        
                        BuddyView()
                    }
            })
        }
        .onAppear {
            print("=== Print ===")
            print("username: \(registerVM.username)")
            print("quiddy Code: \(registerVM.quiddyCode)")
            print("Stop Date: \(registerVM.stopDate)")
            print("updated Stop Date: \(registerVM.updatedStopDate)")

            print("Cig Per Day: \(registerVM.cigPerDay)")

            print("Price Per Cig: \(registerVM.pricePerCig)")
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Button(action: {
                        router.path.removeLast()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    }
                    
                    ProgressBar(progress: 6, total: 6)
                        .padding(.leading, 12)
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)
                
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
                
                Button(action: {
                    // Navigate directly to HomeView
                    router.path.append(Route.pageOne)
                }) {
                    Text("I promise myself")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.white, lineWidth: 1)
                        )
                }
                .disabled(!hasDrawn)
                .opacity(hasDrawn ? 1.0 : 0.5)
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
        .navigationBarHidden(true)
    }
}

