//
//  UsernameView.swift
//  Quiddy
//
//  Created by stephan on 07/11/25.
//

import SwiftUI

struct UsernameView: View {
    @EnvironmentObject private var registerVM: RegisterViewModel
    
    @State private var username = ""
    @State private var generatedCode = ""
    
    var body: some View {
        VStack {
            TextField("Username", text: $username)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
            .textFieldStyle(.roundedBorder)
            .onSubmit {
                generatedCode = registerVM.generateRandomUniqueString()
            }
            
            Text(generatedCode != "" ? generatedCode : "code has not been generated")
        }
        .padding()
    }
}

#Preview {
    UsernameView()
        .environmentObject(RegisterViewModel())
}
