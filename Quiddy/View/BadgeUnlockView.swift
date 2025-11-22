//
//  BadgeUnlockView.swift
//  Quiddy
//
//  Created by Kelvin on 22/11/25.
//

import SwiftUI

// MARK: - Badge Unlock View
struct BadgeUnlockView: View {
    @Binding var isPresented: Bool
    let badge: UnlockedBadge
    
    @State private var badgeScale: CGFloat = 0.1
    @State private var badgeRotation: Double = -180
    @State private var badgeOpacity: Double = 0
    @State private var textOpacity: Double = 0
    @State private var particlesOpacity: Double = 0
    @State private var backgroundOpacity: Double = 0
    
    var body: some View {
        ZStack {
            // Background overlay
            Color.black.opacity(0.8 * backgroundOpacity)
                .ignoresSafeArea()
                .onTapGesture {
                    dismissBadge()
                }
            
            VStack(spacing: badge.isMajor ? 32 : 24) {
                // Badge Icon with particle effects
                ZStack {
                    // Particle effects (only for major badges)
                    if badge.isMajor {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [badge.color.opacity(0.4), .clear],
                                    center: .center,
                                    startRadius: 40,
                                    endRadius: 100
                                )
                            )
                            .frame(width: 200, height: 200)
                            .opacity(particlesOpacity)
                            .scaleEffect(1.2)
                    }
                    
                    // Badge Image
                    Image(badge.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: badge.isMajor ? 140 : 110, height: badge.isMajor ? 140 : 110)
                        .scaleEffect(badgeScale)
                        .rotationEffect(.degrees(badgeRotation))
                        .opacity(badgeOpacity)
                }
                
                // Badge Info
                VStack(spacing: badge.isMajor ? 16 : 12) {
                    Text(badge.title)
                        .font(.system(size: badge.isMajor ? 32 : 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(badge.message)
                        .font(.system(size: badge.isMajor ? 18 : 16))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                .opacity(textOpacity)
                
                // Dismiss button (appears after animation)
                if textOpacity > 0.8 {
                    Button(action: {
                        HapticsManager.shared.selection()
                        dismissBadge()
                    }) {
                        Text("Continue")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(Color.white, lineWidth: 1)
                            )
                    }
                    .padding(.horizontal, 48)
                    .transition(.opacity)
                }
            }
        }
        .onAppear {
            animateBadgeUnlock()
        }
    }
    
    private func animateBadgeUnlock() {
        // Trigger haptic based on badge importance
        if badge.isMajor {
            HapticsManager.shared.badgeUnlockMajor()
        } else {
            HapticsManager.shared.badgeUnlockMinor()
        }
        
        // Background fade in
        withAnimation(.easeOut(duration: 0.3)) {
            backgroundOpacity = 1.0
        }
        
        // Badge pop-in animation
        withAnimation(.spring(response: 0.6, dampingFraction: 0.6).delay(0.1)) {
            badgeScale = 1.0
            badgeRotation = 0
            badgeOpacity = 1.0
        }
        
        // Particle effects (major badges only)
        if badge.isMajor {
            withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                particlesOpacity = 1.0
            }
            
            // Fade out particles
            withAnimation(.easeOut(duration: 1.0).delay(1.5)) {
                particlesOpacity = 0
            }
        }
        
        // Text fade in
        withAnimation(.easeOut(duration: 0.5).delay(0.4)) {
            textOpacity = 1.0
        }
        
        // Auto-dismiss for minor badges
        if !badge.isMajor {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                dismissBadge()
            }
        }
    }
    
    private func dismissBadge() {
        withAnimation(.easeOut(duration: 0.3)) {
            backgroundOpacity = 0
            badgeOpacity = 0
            textOpacity = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isPresented = false
        }
    }
}

// MARK: - Unlocked Badge Model
struct UnlockedBadge {
    let imageName: String
    let title: String
    let message: String
    let color: Color
    let isMajor: Bool
    
    // Streak badges
    static func streak(days: Int) -> UnlockedBadge {
        let isMajor = days >= 30
        let badgeIndex = badgeIndexForDays(days)
        
        return UnlockedBadge(
            imageName: "Badge\(badgeIndex)",
            title: "\(days) Days Together!",
            message: isMajor ? "You've both stayed strong for \(days) days!" : "Keep going strong together!",
            color: isMajor ? Color(hex: "#FF9F0A") : Color(hex: "#FFD60A"),
            isMajor: isMajor
        )
    }
    
    // Money saved badges
    static func moneySaved(amount: Int) -> UnlockedBadge {
        let isMajor = amount >= 500000
        let badgeIndex = badgeIndexForMoney(amount)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        let formattedAmount = formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
        
        return UnlockedBadge(
            imageName: "MoneyBadge\(badgeIndex)",
            title: "Rp \(formattedAmount) Saved!",
            message: isMajor ? "Together you've saved so much!" : "Your savings are growing!",
            color: isMajor ? Color(hex: "#32D74B") : Color(hex: "#64D2FF"),
            isMajor: isMajor
        )
    }
    
    // Helper functions
    private static func badgeIndexForDays(_ days: Int) -> Int {
        switch days {
        case 7: return 1
        case 14: return 2
        case 30: return 3
        case 60: return 4
        case 90: return 5
        case 120: return 6
        default: return 1
        }
    }
    
    private static func badgeIndexForMoney(_ amount: Int) -> Int {
        switch amount {
        case 50000: return 1
        case 100000: return 2
        case 200000: return 3
        case 500000: return 4
        case 1000000: return 5
        case 2000000: return 6
        default: return 1
        }
    }
}

// MARK: - Preview
#Preview("Minor Badge - 7 Days") {
    BadgeUnlockPreview(badge: .streak(days: 7))
}

#Preview("Major Badge - 30 Days") {
    BadgeUnlockPreview(badge: .streak(days: 30))
}

#Preview("Major Badge - Money") {
    BadgeUnlockPreview(badge: .moneySaved(amount: 1000000))
}

struct BadgeUnlockPreview: View {
    let badge: UnlockedBadge
    @State private var isPresented = true
    
    var body: some View {
        ZStack {
            Color(hex: "#0D0D11")
                .ignoresSafeArea()
            
            if isPresented {
                BadgeUnlockView(isPresented: $isPresented, badge: badge)
            } else {
                Button("Show Badge Again") {
                    isPresented = true
                }
                .foregroundColor(.white)
            }
        }
    }
}
