//
//  OnboardingSix.swift
//  Quiddy
//
//  Created by stephan on 07/11/25.
//

import SwiftUI

struct OnboardingSix: View {
    @EnvironmentObject private var registerVM: RegisterViewModel

    var body: some View {
        VStack {
            Text("Done")
            
            
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

        }
    }
}

#Preview {
    OnboardingSix()
}
