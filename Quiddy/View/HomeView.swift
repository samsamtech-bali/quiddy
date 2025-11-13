//
//  HomeView.swift
//  Quiddy
//
//  Created by stephan on 07/11/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var registerViewModel: RegisterViewModel
    
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
    
    private func resetSmokeFreeDays() {
        registerViewModel.stopDate = Date()
        registerViewModel.updatedStopDate = Date()
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
                username: "Buddy",
                daysSmokesFree: daysSmokesFree + 2,
                moneySaved: moneySaved + 5000
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
}
