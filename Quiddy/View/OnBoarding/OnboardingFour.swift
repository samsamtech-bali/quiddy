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
//    @State private var smokePerDayInt: Int = 0
    
    var body: some View {
        VStack {
            
            DatePicker("When was the last time you smoke?", selection: $stopDate, in: ...Date(), displayedComponents: .date)
            
            
            VStack(alignment: .leading) {
                Text("How much cigerattes do you smoke per day?")
                
                TextField("How much", text: $smokePerDayInput)
                    .keyboardType(.phonePad)
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
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
            }
            
            
            Text("Debug Int: \((registerVM.cigPerDay))")
            
            Button("Continue", action: {
                registerVM.stopDate = stopDate
                registerVM.updatedStopDate = stopDate
                
                router.path.append(Route.priceView)
            })
        }
        .padding()
    }
}

#Preview {
    OnboardingFour()
}
