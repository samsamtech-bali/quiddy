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
    
    var body: some View {
        VStack {
            Form {
                
                TextField("How much", text: $pricePerPackInput)
                    .keyboardType(.phonePad)
                    .onChange(of: pricePerPackInput) { newValue in
                        let filtered = newValue.filter{"0123456789".contains($0)}
                        if filtered != newValue {
                            pricePerPackInput = filtered
                        }
                        
                        if let newInt = Int(filtered) {
                            pricePerPackInt = newInt
                        } else if filtered.isEmpty {
                            pricePerPackInt = 0
                        }
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("How long", text: $daysPerPackInput)
                    .keyboardType(.phonePad)
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
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            
            Text("Debug Price Per Pack Int: \((pricePerPackInt))")
            Text("Debug Days Per Pack Int: \((daysPerPackInt))")
            
            Button("Continue", action: {
                registerVM.calculatePricePerCig(price: pricePerPackInt, days: daysPerPackInt)
                
                router.path.append(Route.successView)
            })
        }
        .padding()
    }
}

#Preview {
    OnboardingFive()
}
