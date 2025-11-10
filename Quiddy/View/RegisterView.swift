//
//  RegisterView.swift
//  Quiddy
//
//  Created by stephan on 05/11/25.
//

import SwiftUI

struct RegisterView: View {
    @State private var username: String = ""
    @State private var generatedCode: String = ""
    
    @StateObject private var registerViewModel = RegisterViewModel()
    
    var body: some View {
        VStack {
            TextField("Username", text: $username)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
            .textFieldStyle(.roundedBorder)
            .onSubmit {
                generatedCode = registerViewModel.generateRandomUniqueString()
            }
            
            Text(generatedCode != "" ? generatedCode : "code has not been generated")
        }
        .padding()
            
            
        
        
    }
}

#Preview {
    RegisterView()
}
