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
    @State private var showingInviteView = false
    @State private var userRecord: QuiddyUserModel?
    @State private var buddyRecord: QuiddyUserModel?
    @State private var hasBuddy = false
    
    private var daysSmokesFree: Int {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day], from: registerViewModel.stopDate, to: now)
        return max(0, components.day ?? 0)
    }
    
    private var moneySaved: Int {
        let days = daysSmokesFree
        let dailyCost = Double(registerViewModel.cigPerDay) * registerViewModel.pricePerCig
        return Int(dailyCost * Double(days))
    }
    
    private var buddyDaysSmokesFree: Int {
        guard let buddyRecord = buddyRecord else { return 0 }
        return badgeVM.daysSmokesFree(buddyRecord.updatedStopDate)
    }
    
    private var buddyMoneySaved: Int {
        guard let buddyRecord = buddyRecord else { return 0 }
        return badgeVM.calculateMoneySaved(record: buddyRecord)
    }
    
    private func resetSmokeFreeDays() {
        registerViewModel.stopDate = Date()
        registerViewModel.updatedStopDate = Date()
    }
    
    private func loadUserAndBuddyData() {
        Task {
            do {
                // Load user record
                let record = try await registerViewModel.fetchByRecordName()
                self.userRecord = record
                
                // Check if user has a buddy
                if let record = record,
                   !record.buddyCode.isEmpty && record.buddyCode != "-" {
                    self.hasBuddy = true
                    
                    // Load buddy data
                    let buddy = try await registerViewModel.fetchByUniqueCode(record.buddyCode)
                    self.buddyRecord = buddy
                } else {
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
                username: registerViewModel.username.isEmpty ? "User" : registerViewModel.username,
                daysSmokesFree: daysSmokesFree,
                moneySaved: moneySaved,
                onRefresh: {
                    resetSmokeFreeDays()
                }
            )
            .offset(y: 140)
            
            BuddyCardView(
                hasBuddy: hasBuddy,
                username: buddyRecord?.username ?? "Find a buddy",
                daysSmokesFree: hasBuddy ? buddyDaysSmokesFree : nil,
                moneySaved: hasBuddy ? buddyMoneySaved : nil,
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
