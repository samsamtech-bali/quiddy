//
//  BuddyView.swift
//  Quiddy
//
//  Created by stephan on 11/11/25.
//

import SwiftUI

struct BuddyView: View {
    @EnvironmentObject var registerVM: RegisterViewModel
    @EnvironmentObject var buddyVM: BuddyViewModel
    
    @State var hasBuddy = false
    @State var code: String = ""
    @State var showingAlert = false
    @State var alertMessage = ""
    
    @State var userRecord: QuiddyUserModel?
    @State var buddyRecord: QuiddyUserModel?
    
    var body: some View {
        
        VStack {
            if hasBuddy {
                VStack {
                    Text("=== Your Data ===")
                    Text(userRecord?.username ?? "No name")
                    
                    Text("=== Buddy Data ===")
                    Text(buddyRecord?.username ?? "Buddy has no name")
                    
                    Button("Remove buddy", action: {
                        Task {
                            guard let userRecord = self.userRecord else { return }
                            guard let buddyRecord = self.buddyRecord else { return }
                            
                            print("=== removing buddy ===")
                            print("user record: \(userRecord)")
                            print("buddy record: \(buddyRecord)")
                            
                            await buddyVM.removeBuddy(userRecord: userRecord, buddyRecord: buddyRecord)
                            
                            hasBuddy = false
                        }
                    })
                }
                .padding()
            } else {
                VStack {
                    TextField("Enter buddy code", text: $code)
                    
                    Button("Submit", action: {
                        Task {
                            print("Submiting buddy code: \(code)")
                            //  check if code not equal to that user code
                            //                    let userRecord = try await registerVM.fetchByRecordName()
                            
                            //  check if code exist
                            let result = await registerVM.isCodeExisted(code: code)
                            print("Code exist: \(result)")
                            
                            
                            // update quiddy code
                            guard let userRecord = self.userRecord else { return }
                            print("user record: \(userRecord)")
                            if userRecord.quiddyCode == code {
                                self.alertMessage = "you could not input your own code"
                                showingAlert = true
                            }  else if result == false {
                                print("=== enter false state ===")
                                alertMessage = "there is no user with this code"
                                showingAlert = true
                            } else {
                                print("=== enter true state ===")
                                await buddyVM.updateBuddyCode(
                                    userRecord,
                                    userCode: userRecord.quiddyCode,
                                    buddyCode: code
                                )
                                hasBuddy = true
                                code = ""
                            }
                        }
                    })
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                .alert(alertMessage, isPresented: $showingAlert, actions: {
                    Button("OK", role: .cancel, action: {})
                })
            }
            
        }
        .onAppear {
            Task {
                print("hasBuddy condition: \(hasBuddy)")
                print("run onAppear on BuddyView...")
                
                
                let record = try await registerVM.fetchByRecordName()
                print("user record: \(String(describing: userRecord))")
                self.userRecord = record
                
                
                guard let record = self.userRecord else { return }
                if record.buddyCode != "" && record.buddyCode != "-" {
                    self.hasBuddy = true
                }
            }
        }
        .onChange(of: hasBuddy) {
            Task {
                print("Running onChange hasBuddy")
                if hasBuddy == true {
                    print("hasBuddy true condition")
                    //  fetch buddy data
                    guard let record = self.userRecord else { return }
                    print("record: \(record)")
                    print("buddy code: \(record.buddyCode)")
                    
                    if record.buddyCode == "-" {
                        self.userRecord = try await registerVM.fetchByRecordName()
                    }
                    
                    self.buddyRecord = try await registerVM.fetchByUniqueCode(record.buddyCode)
                }
            }
            
        }
    }
}

#Preview {
    BuddyView()
        .environmentObject(RegisterViewModel())
        .environmentObject(BuddyViewModel())
}

