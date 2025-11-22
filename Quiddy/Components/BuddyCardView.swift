//
//  BuddyCardView.swift
//  Quiddy
//
//  Created by Jeremy Lumban Toruan on 10/11/25.
//

import SwiftUI

struct BuddyCardView: View {
    let hasBuddy: Bool
    let hasPendingRequest: Bool
    let username: String?
    let daysSmokesFree: Int?
    let moneySaved: Int?
    let onAddBuddyTap: () -> Void
    let onAcceptRequest: () -> Void
    let onDeclineRequest: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            // Title outside the card - only for pending request
            if hasPendingRequest {
                HStack {
                    Text("Buddy Request")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
            }
            
            // Card content
            ZStack {
                if hasBuddy {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.4, green: 0.7, blue: 1.0),
                            Color(red: 0.2, green: 0.5, blue: 0.9)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .cornerRadius(24)
                } else {
                    Color(red: 0.25, green: 0.25, blue: 0.25)
                        .cornerRadius(24)
                }
            
            if hasBuddy {
                // Existing buddy data view
                VStack(spacing: 12) {
                    HStack {
                        Text(username ?? "Buddy")
                            .font(.title)
                            .fontWeight(.medium)
                            .foregroundColor(.white.opacity(0.9))
                        
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 15)
                    
                    HStack(spacing: 50) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 6) {
                                Image(systemName: "bag")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white.opacity(0.7))
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Rp\((moneySaved ?? 0).formatted())")
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                    
                                    Text("money saved")
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.8))
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 6) {
                                Image(systemName: "clock")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white.opacity(0.7))
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("\(daysSmokesFree ?? 0) days")
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                    
                                    Text("smoke-free")
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.8))
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 15)
                }
            } else if hasPendingRequest {
                // Buddy request view (without title)
                HStack(spacing: 16) {
                    Text(username ?? "Someone")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        HapticsManager.shared.selection()
                        onAcceptRequest()
                    }) {
                        Text("Accept")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.white, lineWidth: 1)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: {
                        HapticsManager.shared.lightImpact()
                        onDeclineRequest()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal, 24)
                .frame(height: 40)
            } else {
                // Add buddy placeholder view (matching AddBuddy.PNG)
                Button(action: onAddBuddyTap) {
                    VStack(spacing: 16) {
                        Text("Add a buddy?")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Invite your buddy now to start your\nquitting journey together!")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .lineSpacing(2)
                    }
                    .padding(.horizontal, 24)
                }
                .buttonStyle(PlainButtonStyle())
            }
            }
            .frame(height: hasPendingRequest ? 60 : 150)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        // Preview with buddy
        BuddyCardView(
            hasBuddy: true,
            hasPendingRequest: false,
            username: "Stephan",
            daysSmokesFree: 12,
            moneySaved: 40000,
            onAddBuddyTap: {},
            onAcceptRequest: {},
            onDeclineRequest: {}
        )
        
        // Preview with buddy request
        BuddyCardView(
            hasBuddy: false,
            hasPendingRequest: true,
            username: "Stephan",
            daysSmokesFree: nil,
            moneySaved: nil,
            onAddBuddyTap: {},
            onAcceptRequest: {
                print("Accept tapped")
            },
            onDeclineRequest: {
                print("Decline tapped")
            }
        )
        
        // Preview without buddy (Add buddy state)
        BuddyCardView(
            hasBuddy: false,
            hasPendingRequest: false,
            username: nil,
            daysSmokesFree: nil,
            moneySaved: nil,
            onAddBuddyTap: {
                print("Add buddy tapped")
            },
            onAcceptRequest: {},
            onDeclineRequest: {}
        )
    }
    .padding()
}
