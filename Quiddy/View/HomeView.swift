//
//  HomeView.swift
//  Quiddy
//
//  Created by stephan on 07/11/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var registerViewModel: RegisterViewModel
    @EnvironmentObject private var badgeVM: BadgeViewModel
    @EnvironmentObject private var buddyBadgeVM: BuddyBadgeViewModel
    
    @State private var showingInviteView = false
    @State private var hasBuddy = false
    
    @State private var userRecord: QuiddyUserModel?
    @State private var buddyRecord: QuiddyUserModel?
    
    @State var userFreeSmokeDays: Int = 0
    @State var userMoneySaved: Int = 0
    
    @State var buddyFreeSmokeDays: Int = 0
    @State var buddyMoneySaved: Int = 0
    
    @State var combinedFreeSmokeDays: Int = 0
    @State var combinedMoneySaved: Int = 0
    
    
    
    private func loadUserAndBuddyData() {
        Task {
            do {
                // Load user record
                let record = try await registerViewModel.fetchByRecordName()
                self.userRecord = record
                
                guard let record = self.userRecord else { return }
                
                userFreeSmokeDays = badgeVM.daysSmokesFree(record.updatedStopDate)
                userMoneySaved = badgeVM.calculateMoneySaved(record: record)
                
                if !record.buddyCode.isEmpty && record.buddyCode != "-" {
                    self.hasBuddy = true
                    
                    let buddyRecord = try await registerViewModel.fetchByUniqueCode(record.buddyCode)
                    self.buddyRecord = buddyRecord
                    
                    guard let buddyRecord = self.buddyRecord else { return }
                    buddyFreeSmokeDays = badgeVM.daysSmokesFree(buddyRecord.updatedStopDate)
                    buddyMoneySaved = badgeVM.calculateMoneySaved(record: buddyRecord)
                    
                    combinedFreeSmokeDays = buddyBadgeVM.calculateSharedStreak(since: record.buddyStartDate)
                    
                    combinedMoneySaved = buddyBadgeVM.calculateSharedMoneySaved(userRecord: record, buddyRecord: buddyRecord)
                    
                    await buddyBadgeVM.checkAchievedBadges(streak: combinedFreeSmokeDays, moneySaved: combinedMoneySaved, userRecord: record.getRecord().recordID, buddyRecord: buddyRecord.getRecord().recordID)
                }
                else {
                    self.hasBuddy = false
                    self.buddyRecord = nil
                }
                
                
            } catch {
                print("Error loading user/buddy data: \(error)")
                self.hasBuddy = false
                self.buddyRecord = nil
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
            CardView(
                username: userRecord?.username ?? "no data",
                daysSmokesFree: userFreeSmokeDays,
                moneySaved: userMoneySaved,
                onRefresh: {
                    Task {
                        guard let userRecord = self.userRecord else { return }
                        guard let buddyRecord = self.buddyRecord else { return }
                        
                        await badgeVM.reset(userRecord: userRecord.getRecord().recordID, buddyRecord: buddyRecord.getRecord().recordID, userRelapseDate: &userRecord.relapseDate)

                    }
                }
            )
            .offset(y: 140)
            
            BuddyCardView(
                hasBuddy: hasBuddy,
                username: buddyRecord?.username ?? "Find a buddy",
                daysSmokesFree: buddyFreeSmokeDays,
                moneySaved:buddyMoneySaved,
                onAddBuddyTap: {
                    showingInviteView = true
                }
            )
            .offset(y: 140)
            
            // Badges Together Section
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Badges Together")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    NavigationLink(destination: BadgeListView()) {
                        Image(systemName: "chevron.right")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 20)
                
                // Badge Preview
                HStack(spacing: 10) {
                    BadgePreview(badgeIndex: 1, isEarned: true)
                    BadgePreview(badgeIndex: 2, isEarned: true)
                    BadgePreview(badgeIndex: 3, isEarned: false)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
            .offset(y: 150)
            
            Spacer()
        }
        .padding()
        .background(Color(red: 0x12/255, green: 0x14/255, blue: 0x18/255))
        .ignoresSafeArea()
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingInviteView) {
            InviteView()
                .environmentObject(registerViewModel)
        }
        .onAppear {
            loadUserAndBuddyData()
        }
        .onChange(of: showingInviteView) { _ in
            if !showingInviteView {
                // Refresh data when returning from invite view
                loadUserAndBuddyData()
            }
        }
    }
        
}

struct BadgePreview: View {
    let badgeIndex: Int
    let isEarned: Bool
    
    var body: some View {
        Image(isEarned ? "Badge\(badgeIndex)" : "Badge\(badgeIndex)locked")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 110, height: 110)
    }
}

#Preview {
    HomeView()
        .environmentObject(RegisterViewModel())
        .environmentObject(BadgeViewModel())
}
