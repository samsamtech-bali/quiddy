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
    @EnvironmentObject var buddyBadgeVM: BuddyBadgeViewModel
    @EnvironmentObject var buddyNudgeVM: BuddyNudgeViewModel
    @EnvironmentObject var pushNotificationVM: PushNotificationViewModel
    
    @State var hasBuddy = false
    @State var code: String = ""
    @State var showingAlert = false
    @State var alertMessage = ""
    
    @State var userRecord: QuiddyUserModel?
    @State var buddyRecord: QuiddyUserModel?
    
    @State var userFreeSmokeDays: Int = 0
    @State var userMoneySaved: Int = 0
    
    @State var buddyFreeSmokeDays: Int = 0
    @State var buddyMoneySaved: Int = 0
    
    @State var combinedFreeSmokeDays: Int = 0
    @State var combinedMoneySaved: Int = 0
    
    @State var hasInvitation: Bool = false
    @State var allowedToInvite: Bool = true
    
    @State var badges: [(id: String, asset: String, type: String, name: String, description: String, achieved: Bool, count: Int, threshold: Int)] = []
    
    
    var body: some View {
        
        VStack {
            if hasBuddy {
                VStack {
                    Text("=== Your Data ===")
                    Text("name:")
                    Text(userRecord?.username ?? "No name")
                    
                    Text("days since:")
                    Text("\(userFreeSmokeDays)")
                    
                    Text("money saved:")
                    Text("\(userMoneySaved)")
                    
                    Button("reset", action: {
                        Task {
                            guard let userRecord = self.userRecord else { return }
                            guard let buddyRecord = self.buddyRecord else { return }
                            
                            await buddyBadgeVM.reset(userRecord: userRecord.getRecord().recordID, buddyRecord: buddyRecord.getRecord().recordID, userRelapseDate: &userRecord.relapseDate)
                        }
                    })
                    
                    Text("=== Buddy Data ===")
                    Text(buddyRecord?.username ?? "Buddy has no name")
                    
                    Text("days since:")
                    Text("\(buddyFreeSmokeDays)")
                    
                    Text("money saved:")
                    Text("\(buddyMoneySaved)")
                    
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
                    
                    Text("=== Combine Data ===")
                    
                    Text("streak:")
                    Text("\(combinedFreeSmokeDays)")
                    
                    Text("total money saved:")
                    Text("\(combinedMoneySaved)")
                    
                    
                    Text("=== Badges Data ===")
                    
                    VStack {
                        ForEach(0..<badges.count, id: \.self) { index in
                            HStack {
                                Text("name \(badges[index].name)")
                                Text("count \(badges[index].count)")
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button("Nudge \(String(describing: buddyRecord?.username))", action: {
                        Task {
                            guard let userRecord = self.userRecord else { return }
                            guard let buddyRecord = self.buddyRecord else { return }
                            
                            let message = buddyNudgeVM.randomMessage()
                            
                            _ = await buddyNudgeVM.createNewNudge(sender: userRecord.getRecord().recordID.recordName, receiver: buddyRecord.getRecord().recordID.recordName, message: message)
                        }
                    })
                    
                    Button("calculate", action: {
                        guard let userRecord = self.userRecord else { return }
                        let days = buddyBadgeVM.calculateSharedStreak(since: userRecord.buddyStartDate)
                        
                        print("days: \(days)")
                    })
                    
                    Button("compare user", action: {
                        guard let userRecord = self.userRecord else { return }
                        guard let buddyRecord = self.buddyRecord else { return }
                        
                        let users = buddyBadgeVM.compareUser(userRecordName: userRecord.getRecord().recordID.recordName, buddyRecordName: buddyRecord.getRecord().recordID.recordName)
                        print("userA in view: \(users.userA)")
                        print("userB in view: \(users.userB)")
                    })
                    
                }
                .padding()
            } else {
                VStack {
                    if hasInvitation {
                        Text("\(userRecord?.incomingCode) is inviting you to be a buddy")
                        Button(action: {
                            Task {
                                guard let userRecord = self.userRecord else { return }
                                
                                await buddyVM.acceptBuddy(userRecord: userRecord.getRecord().recordID, incomingCode: userRecord.incomingCode)
                                
                                hasBuddy = true
                            }
                        }, label: {
                            Text("Accept")
                        })
                        
                        Button(action: {
                            Task {
                                guard let userRecord = self.userRecord else { return }
                                
                                await buddyVM.rejectBuddy(userRecord: userRecord.getRecord().recordID, incomingCode: userRecord.incomingCode)
                            }
                        }, label: {
                            Text("Reject")
                        })
                    }
                    
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
//                                await buddyVM.updateBuddyCode(
//                                    userRecord,
//                                    userCode: userRecord.quiddyCode,
//                                    buddyCode: code
//                                )
//                                hasBuddy = true
                                if allowedToInvite {
                                    await buddyVM.addBuddy(userRecord: userRecord.getRecord().recordID, userCode: userRecord.quiddyCode, buddyCode: code)
                                    code = ""
                                    allowedToInvite = false
                                }
                            }
                        }
                    })
                    .buttonStyle(.borderedProminent)
                    
                    if !allowedToInvite {
                        Text("You are not allowed to invite more buddy!")
                    }
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
                
                pushNotificationVM.requestNotificationPermissions()
                
                let record = try await registerVM.fetchByRecordName()
                print("user record: \(String(describing: userRecord))")
                self.userRecord = record
                
                
                guard let record = self.userRecord else { return }
                userFreeSmokeDays = buddyBadgeVM.daysSmokesFree(record.updatedStopDate)
                userMoneySaved = buddyBadgeVM.calculateMoneySaved(record: record)
                
                if record.buddyCode != "" && record.buddyCode != "-" {
                    self.hasBuddy = true
                }
                
                if record.incomingCode != "" && record.incomingCode != "-" {
                    self.hasInvitation = true
                }
                
                if record.outgoingCode != "" && record.outgoingCode != "-" {
                    self.allowedToInvite = false
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
                    
                    guard let buddyRecord = self.buddyRecord else { return }
                    buddyFreeSmokeDays = buddyBadgeVM.daysSmokesFree(buddyRecord.updatedStopDate)
                    buddyMoneySaved = buddyBadgeVM.calculateMoneySaved(record: buddyRecord)
                    
                    combinedFreeSmokeDays = buddyBadgeVM.calculateSharedStreak(since: record.buddyStartDate)
                    
                    combinedMoneySaved = buddyBadgeVM.calculateSharedMoneySaved(userRecord: record, buddyRecord: buddyRecord)
                    
                    await buddyBadgeVM.checkAchievedBadges(streak: combinedFreeSmokeDays, moneySaved: combinedMoneySaved, userRecord: record.getRecord().recordID, buddyRecord: buddyRecord.getRecord().recordID)
                    
                    let badgeByStreakType = try await buddyBadgeVM.fetchAllBadgesByType(userRecordName: record.getRecord().recordID.recordName, badgeType: BadgeType.streak.rawValue)
                    
                    self.badges = buddyBadgeVM.compareBadges(achievedBadges: badgeByStreakType)
                    
                    print("badgeByStreakType: \(badgeByStreakType)")
                    
                    pushNotificationVM.subscribeToNudgeNotifications(sender: buddyRecord.getRecord().recordID.recordName, receiver: record.getRecord().recordID.recordName)
                }
            }
            
        }
    }
}

#Preview {
    var emptyDateArr: [Date] = []
    BuddyView(
        userRecord:QuiddyUserModel(
            username: "stephan",
            quiddyCode: "1AB482",
            stopDate: Date.now,
            updatedStopDate: Date.now,
            cigPerDay: 5,
            pricePerCig: 12500,
            dateCravingPressed: emptyDateArr,
//            badges: "[]",
            relapseDate: emptyDateArr,
            buddyCode: "FF1592",
            buddyStartDate: Date(),
            incomingCode: "-",
            invitedDate: Date.now,
            outgoingCode: "-"
        ),
        buddyRecord: QuiddyUserModel(
            username: "jeremy",
            quiddyCode: "FF1592",
            stopDate: Date.now,
            updatedStopDate: Date.now,
            cigPerDay: 3,
            pricePerCig: 5000,
            dateCravingPressed: emptyDateArr,
//            badges: "[]",
            relapseDate: emptyDateArr,
            buddyCode: "1AB482",
            buddyStartDate: Date(),
            incomingCode: "-",
            invitedDate: Date.now,
            outgoingCode: "-"
        )
    )
    .environmentObject(RegisterViewModel())
    .environmentObject(BuddyViewModel())
    .environmentObject(BuddyBadgeViewModel())
    .environmentObject(PushNotificationViewModel())
}
