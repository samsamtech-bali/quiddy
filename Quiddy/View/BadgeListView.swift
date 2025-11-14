//
//  BadgeListView.swift
//  Quiddy
//
//  Created by Jeremy Lumban Toruan on 10/11/25.
//

import SwiftUI

struct BadgeListView: View {
    @Environment(\.dismiss) private var dismiss
    
    let streakBadges = [7, 14, 30, 60, 90, 120]
    let earnedStreakBadges = [7, 14] // Mock data - 7 and 14 day badges earned
    
    let savingsBadges = [50000, 100000, 200000, 500000, 1000000, 2000000] // Savings milestones in currency units
    let earnedSavingsBadges = [50000] // Mock data - first milestone earned
    
    var body: some View {
        NavigationView {
            ZStack {
//                Color(red: 0x12/255, green: 0x14/255, blue: 0x18/255)
//                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Back Button
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    ScrollView {
                        VStack(spacing: 40) {
                            // Streaks Section
                            VStack(alignment: .leading, spacing: 20) {
                                HStack {
                                    Text("Streaks")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                                    ForEach(Array(streakBadges.enumerated()), id: \.element) { index, days in
                                        HexagonBadge(
                                            number: days,
                                            isEarned: earnedStreakBadges.contains(days),
                                            badgeIndex: index + 1
                                        )
                                    }
                                }
                            }
                            
                            // Savings Section
                            VStack(alignment: .leading, spacing: 20) {
                                HStack {
                                    Text("Savings")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                                    ForEach(Array(savingsBadges.enumerated()), id: \.element) { index, amount in
                                        MoneyBadge(
                                            amount: amount,
                                            isEarned: earnedSavingsBadges.contains(amount),
                                            badgeIndex: index + 1
                                        )
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct HexagonBadge: View {
    let number: Int
    let isEarned: Bool
    let badgeIndex: Int
    
    var body: some View {
        ZStack {
//            // Fallback background for debugging
//            Circle()
//                .fill(Color.gray.opacity(0.2))
//                .frame(width: 90, height: 90)
            
            if isEarned {
                Image("Badge\(badgeIndex)")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 110, height: 110)
            } else {
                Image("Badge\(badgeIndex)locked")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 110, height: 110)
            }
            
            // Debug text overlay
//            Text("\(number)")
//                .font(.caption)
//                .foregroundColor(.white)
//                .background(Color.black.opacity(0.5))
//                .cornerRadius(4)
        }
    }
}

struct MoneyBadge: View {
    let amount: Int
    let isEarned: Bool
    let badgeIndex: Int
    
    var body: some View {
        ZStack {
            if isEarned {
                Image("MoneyBadge\(badgeIndex)")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 110, height: 110)
            } else {
                Image("MoneyBadge\(badgeIndex)Locked")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 110, height: 110)
            }
        }
    }
}

#Preview {
    BadgeListView()
}
