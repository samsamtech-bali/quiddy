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
    
//    @State private var username = ""
//    @State private var generatedCode = ""
    
    var body: some View {
        VStack {
            TextField("Username", text: $registerVM.username)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
            .textFieldStyle(.roundedBorder)
            
            Text(registerVM.quiddyCode != "" ? registerVM.quiddyCode : "code has not been generated")
            
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
        }
        .padding()
    }
}

#Preview {
    OnboardingThree()
        .environmentObject(Router.shared)
        .environmentObject(RegisterViewModel())
}
