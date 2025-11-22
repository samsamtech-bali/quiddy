//
//  HomeView.swift
//  Quiddy
//
//  Created by stephan on 07/11/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var registerViewModel: RegisterViewModel
    @EnvironmentObject private var buddyBadgeVM: BuddyBadgeViewModel
    @EnvironmentObject private var buddyVM: BuddyViewModel
    
    @State private var showingInviteView = false
    @State private var hasBuddy = false
    @State private var hasPendingRequest = false
    @State private var hasOutgoingRequest = false
    @State private var incomingBuddyUsername = ""
    
    @State private var userRecord: QuiddyUserModel?
    @State private var buddyRecord: QuiddyUserModel?
    
    @State var userFreeSmokeDays: Int = 0
    @State var userMoneySaved: Int = 0
    
    @State var buddyFreeSmokeDays: Int = 0
    @State var buddyMoneySaved: Int = 0
    
    @State var combinedFreeSmokeDays: Int = 0
    @State var combinedMoneySaved: Int = 0
    @State var earnedBadges: [BuddyBadgeModel] = []
    
    @State private var showBadgeUnlock = false
    @State private var newlyUnlockedBadges: [UnlockedBadge] = []
    @State private var currentBadgeIndex = 0
    
    private var earnedBadgeCount: Int {
        return earnedBadges.count
    }
    
    private var totalBadgeCount: Int {
        return 12 // 6 streak badges + 6 money badges
    }
    
    private var badgePreviewData: [(index: Int, isEarned: Bool)] {
        let streakBadges = earnedBadges.filter { $0.badgeType == BadgeType.streak.rawValue }
        let sortedStreakBadges = streakBadges.sorted { $0.badgeThreshold < $1.badgeThreshold }
        
        var previews: [(index: Int, isEarned: Bool)] = []
        
        // Show first 3 badges, prioritizing earned ones
        for i in 1...3 {
            if i <= sortedStreakBadges.count {
                previews.append((index: i, isEarned: true))
            } else {
                previews.append((index: i, isEarned: false))
            }
        }
        
        return previews
    }
    
    private func loadUserAndBuddyData() {
        Task {
            do {
                // Load user record
                let record = try await registerViewModel.fetchByRecordName()
                self.userRecord = record
                
                guard let record = self.userRecord else { return }
                
                userFreeSmokeDays = buddyBadgeVM.daysSmokesFree(record.updatedStopDate)
                userMoneySaved = buddyBadgeVM.calculateMoneySaved(record: record)
                
                if !record.buddyCode.isEmpty && record.buddyCode != "-" {
                    self.hasBuddy = true
                    self.hasPendingRequest = false
                    self.hasOutgoingRequest = false
                    
                    let buddyRecord = try await registerViewModel.fetchByUniqueCode(record.buddyCode)
                    self.buddyRecord = buddyRecord
                    
                    guard let buddyRecord = self.buddyRecord else { return }
                    buddyFreeSmokeDays = buddyBadgeVM.daysSmokesFree(buddyRecord.updatedStopDate)
                    buddyMoneySaved = buddyBadgeVM.calculateMoneySaved(record: buddyRecord)
                    
                    combinedFreeSmokeDays = buddyBadgeVM.calculateSharedStreak(since: record.buddyStartDate)
                    
                    combinedMoneySaved = buddyBadgeVM.calculateSharedMoneySaved(userRecord: record, buddyRecord: buddyRecord)
                    
                    // Store previous badges before checking for new achievements
                    let previousBadges = earnedBadges
                    
                    await buddyBadgeVM.checkAchievedBadges(streak: combinedFreeSmokeDays, moneySaved: combinedMoneySaved, userRecord: record.getRecord().recordID, buddyRecord: buddyRecord.getRecord().recordID)
                    
                    // Load earned badges (refresh after potential new achievements)
                    let badges = try await buddyBadgeVM.fetchTogetherBadge(
                        userRecordName: record.getRecord().recordID.recordName,
                        buddyRecordName: buddyRecord.getRecord().recordID.recordName
                    )
                    earnedBadges = badges ?? []
                    
                    // Check for newly unlocked badges
                    checkForNewBadges(previousBadges: previousBadges, currentBadges: earnedBadges)
                }
                else if !record.incomingCode.isEmpty && record.incomingCode != "-" {
                    // Has pending buddy request
                    self.hasBuddy = false
                    self.hasPendingRequest = true
                    self.hasOutgoingRequest = false
                    
                    // Fetch the username of the person who sent the request
                    let senderRecord = try await registerViewModel.fetchByUniqueCode(record.incomingCode)
                    self.incomingBuddyUsername = senderRecord?.username ?? "Someone"
                    
                    self.buddyRecord = nil
                    self.earnedBadges = []
                }
                else if !record.outgoingCode.isEmpty && record.outgoingCode != "-" {
                    // Waiting for buddy to accept invitation
                    self.hasBuddy = false
                    self.hasPendingRequest = false
                    self.hasOutgoingRequest = true
                    
                    self.buddyRecord = nil
                    self.earnedBadges = []
                }
                else {
                    self.hasBuddy = false
                    self.hasPendingRequest = false
                    self.hasOutgoingRequest = false
                    self.buddyRecord = nil
                    self.earnedBadges = []
                }
                
                
            } catch {
                print("Error loading user/buddy data: \(error)")
                self.hasBuddy = false
                self.hasPendingRequest = false
                self.hasOutgoingRequest = false
                self.buddyRecord = nil
                self.earnedBadges = []
            }
        }
    }
    
    private func checkForNewBadges(previousBadges: [BuddyBadgeModel], currentBadges: [BuddyBadgeModel]) {
        let previousBadgeIds = Set(previousBadges.map { "\($0.badgeType)-\($0.badgeThreshold)" })
        let newBadges = currentBadges.filter { badge in
            !previousBadgeIds.contains("\(badge.badgeType)-\(badge.badgeThreshold)")
        }
        
        if !newBadges.isEmpty {
            newlyUnlockedBadges = newBadges.compactMap { convertToUnlockedBadge($0) }
            currentBadgeIndex = 0
            showBadgeUnlock = true
        }
    }
    
    private func convertToUnlockedBadge(_ badge: BuddyBadgeModel) -> UnlockedBadge? {
        if badge.badgeType == BadgeType.streak.rawValue {
            return UnlockedBadge.streak(days: badge.badgeThreshold)
        } else if badge.badgeType == BadgeType.moneySaved.rawValue {
            return UnlockedBadge.moneySaved(amount: badge.badgeThreshold)
        }
        return nil
    }
    
    private func showNextBadge() {
        currentBadgeIndex += 1
        if currentBadgeIndex >= newlyUnlockedBadges.count {
            showBadgeUnlock = false
            newlyUnlockedBadges = []
            currentBadgeIndex = 0
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
            CardView(
                username: userRecord?.username ?? "User",
                daysSmokesFree: userFreeSmokeDays,
                moneySaved: userMoneySaved,
                onRefresh: {
                    Task {
                        guard let userRecord = self.userRecord else { return }
                        
                        guard let buddyRecord = self.buddyRecord else { return }
                        
                        await buddyBadgeVM.reset(userRecord: userRecord.getRecord().recordID, buddyRecord: buddyRecord.getRecord().recordID, userRelapseDate: &userRecord.relapseDate)
                    }
                }
            )
            .offset(y: 140)
            
            BuddyCardView(
                hasBuddy: hasBuddy,
                hasPendingRequest: hasPendingRequest,
                hasOutgoingRequest: hasOutgoingRequest,
                username: hasPendingRequest ? incomingBuddyUsername : (buddyRecord?.username ?? "Find a buddy"),
                daysSmokesFree: buddyFreeSmokeDays,
                moneySaved: buddyMoneySaved,
                onAddBuddyTap: {
                    showingInviteView = true
                },
                onAcceptRequest: {
                    Task {
                        guard let userRecord = self.userRecord else { return }
                        await buddyVM.acceptBuddy(
                            userRecord: userRecord.getRecord().recordID,
                            incomingCode: userRecord.incomingCode
                        )
                        loadUserAndBuddyData() // Refresh the view
                    }
                },
                onDeclineRequest: {
                    Task {
                        guard let userRecord = self.userRecord else { return }
                        await buddyVM.rejectBuddy(
                            userRecord: userRecord.getRecord().recordID,
                            incomingCode: userRecord.incomingCode
                        )
                        loadUserAndBuddyData() // Refresh the view
                    }
                }
            )
            .offset(y: 140)
            
            // Badges Together Section
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Badges Together")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("\(earnedBadgeCount) of \(totalBadgeCount) earned")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: BadgeListView()
                        .environmentObject(registerViewModel)
                        .environmentObject(buddyBadgeVM)
                    ) {
                        Image(systemName: "chevron.right")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 20)
                
                // Badge Preview
                HStack(spacing: 10) {
                    ForEach(badgePreviewData, id: \.index) { badge in
                        BadgePreview(badgeIndex: badge.index, isEarned: badge.isEarned)
                    }
                    
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
        .overlay {
            if showBadgeUnlock && currentBadgeIndex < newlyUnlockedBadges.count {
                BadgeUnlockView(
                    isPresented: Binding(
                        get: { showBadgeUnlock },
                        set: { _ in showNextBadge() }
                    ),
                    badge: newlyUnlockedBadges[currentBadgeIndex]
                )
            }
        }
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
        .environmentObject(BuddyBadgeViewModel())
        .environmentObject(BuddyViewModel())
}
