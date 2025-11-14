//
//  HapticsExamples.swift
//  Quiddy
//
//  Created by Kelvin on 14/11/25.
//

import SwiftUI

// MARK: - Breathing Exercise Example

struct BreathingExerciseView: View {
    @State private var currentPhase: BreathingPhase = .inhale
    @State private var circleScale: CGFloat = 1.0
    @State private var isBreathing = false
    
    // Timing configuration
    private let inhaleDuration: TimeInterval = 4.0
    private let holdDuration: TimeInterval = 4.0
    private let exhaleDuration: TimeInterval = 6.0
    
    var body: some View {
        ZStack {
            Color(hex: "#0D0D11")
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                // Breathing Circle Animation
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "#C1A7FF"), Color(hex: "#8CBFFF")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 200, height: 200)
                    .scaleEffect(circleScale)
                    .overlay(
                        Text(phaseText)
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.white)
                    )
                
                // Start/Stop Button
                Button(action: {
                    if isBreathing {
                        stopBreathing()
                    } else {
                        startBreathing()
                    }
                }) {
                    Text(isBreathing ? "Stop" : "Start Breathing")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(Color.white, lineWidth: 1)
                        )
                }
                .padding(.horizontal, 32)
            }
        }
    }
    
    private var phaseText: String {
        switch currentPhase {
        case .inhale: return "Breathe In"
        case .hold: return "Hold"
        case .exhale: return "Breathe Out"
        case .complete: return "Complete"
        }
    }
    
    private func startBreathing() {
        isBreathing = true
        performBreathingCycle()
    }
    
    private func stopBreathing() {
        isBreathing = false
        currentPhase = .inhale
        withAnimation {
            circleScale = 1.0
        }
    }
    
    private func performBreathingCycle() {
        guard isBreathing else { return }
        
        // INHALE Phase
        currentPhase = .inhale
        HapticsManager.shared.breathingPulse(phase: .inhale, duration: inhaleDuration)
        
        withAnimation(.easeInOut(duration: inhaleDuration)) {
            circleScale = 1.5
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + inhaleDuration) {
            guard self.isBreathing else { return }
            
            // HOLD Phase
            self.currentPhase = .hold
            HapticsManager.shared.breathingPulse(phase: .hold, duration: self.holdDuration)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + self.holdDuration) {
                guard self.isBreathing else { return }
                
                // EXHALE Phase
                self.currentPhase = .exhale
                HapticsManager.shared.breathingPulse(phase: .exhale, duration: self.exhaleDuration)
                
                withAnimation(.easeInOut(duration: self.exhaleDuration)) {
                    self.circleScale = 1.0
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + self.exhaleDuration) {
                    // Cycle complete - repeat
                    self.performBreathingCycle()
                }
            }
        }
    }
}

// MARK: - Badge Unlock Example

struct BadgeUnlockView: View {
    @State private var showBadge = false
    @State private var badgeScale: CGFloat = 0.1
    @State private var badgeRotation: Double = -180
    @State private var particlesOpacity: Double = 0
    
    let badgeType: BadgeType
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
                .onTapGesture {
                    dismissBadge()
                }
            
            VStack(spacing: 24) {
                // Badge Icon
                ZStack {
                    // Particle effects
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [badgeType.color.opacity(0.3), .clear],
                                center: .center,
                                startRadius: 50,
                                endRadius: 120
                            )
                        )
                        .frame(width: 240, height: 240)
                        .opacity(particlesOpacity)
                    
                    // Badge
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [badgeType.color, badgeType.color.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                        .overlay(
                            Image(systemName: badgeType.icon)
                                .font(.system(size: 50, weight: .bold))
                                .foregroundColor(.white)
                        )
                        .scaleEffect(badgeScale)
                        .rotationEffect(.degrees(badgeRotation))
                }
                
                // Badge Info
                VStack(spacing: 12) {
                    Text(badgeType.title)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(badgeType.description)
                        .font(.system(size: 17))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                .opacity(showBadge ? 1 : 0)
                
                Button(action: {
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
                .padding(.horizontal, 32)
                .opacity(showBadge ? 1 : 0)
            }
        }
        .onAppear {
            animateBadgeUnlock()
        }
    }
    
    private func animateBadgeUnlock() {
        // Trigger appropriate haptic based on badge type
        if badgeType.isMajor {
            HapticsManager.shared.badgeUnlockMajor()
        } else {
            HapticsManager.shared.badgeUnlockMinor()
        }
        
        // Animate badge appearance
        withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
            badgeScale = 1.0
            badgeRotation = 0
        }
        
        withAnimation(.easeOut(duration: 0.8)) {
            particlesOpacity = 1.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.easeOut(duration: 0.5)) {
                showBadge = true
            }
        }
        
        // Fade out particles
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeOut(duration: 1.0)) {
                particlesOpacity = 0
            }
        }
    }
    
    private func dismissBadge() {
        HapticsManager.shared.selection()
        // Dismiss logic here
    }
}

struct BadgeType {
    let title: String
    let description: String
    let icon: String
    let color: Color
    let isMajor: Bool
    
    static let sevenDays = BadgeType(
        title: "7 Days Strong",
        description: "One week smoke-free!",
        icon: "star.fill",
        color: Color(hex: "#FFD60A"),
        isMajor: false
    )
    
    static let thirtyDays = BadgeType(
        title: "30 Days Champion",
        description: "A full month of freedom!",
        icon: "crown.fill",
        color: Color(hex: "#FF9F0A"),
        isMajor: true
    )
    
    static let ninetyDays = BadgeType(
        title: "90 Days Warrior",
        description: "You've conquered three months!",
        icon: "shield.fill",
        color: Color(hex: "#AF52DE"),
        isMajor: true
    )
}

// MARK: - Buddy Pairing Screen Example

struct BuddyPairingView: View {
    @State private var buddyCode: String = ""
    @State private var myCode: String = "ABC123"
    @State private var isPairing: Bool = false
    @State private var pairingSuccess: Bool = false
    @State private var showError: Bool = false
    
    var body: some View {
        ZStack {
            Color(hex: "#0D0D11")
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Text("Find Your Buddy")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                
                // My Code Section
                VStack(spacing: 12) {
                    Text("Your Code")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(Color(hex: "#8E8E93"))
                    
                    HStack {
                        Text(myCode)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(hex: "#1C1C1E"))
                            .cornerRadius(12)
                        
                        Button(action: copyCode) {
                            Image(systemName: "doc.on.doc")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .frame(width: 48, height: 48)
                                .background(Color(hex: "#1C1C1E"))
                                .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal, 24)
                
                // Divider
                Text("OR")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color(hex: "#8E8E93"))
                
                // Enter Buddy Code Section
                VStack(spacing: 12) {
                    Text("Enter Buddy's Code")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(Color(hex: "#8E8E93"))
                    
                    TextField("ABC123", text: $buddyCode)
                        .textInputAutocapitalization(.characters)
                        .autocorrectionDisabled(true)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color(hex: "#1C1C1E"))
                        .cornerRadius(12)
                        .onChange(of: buddyCode) { _ in
                            HapticsManager.shared.codeInput()
                        }
                }
                .padding(.horizontal, 24)
                
                // Connect Button
                Button(action: connectWithBuddy) {
                    if isPairing {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Connect")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(buddyCode.isEmpty ? Color.gray : Color(hex: "#C1A7FF"))
                .cornerRadius(24)
                .disabled(buddyCode.isEmpty || isPairing)
                .padding(.horizontal, 24)
                
                // Error Message
                if showError {
                    Text("Invalid code. Please try again.")
                        .font(.system(size: 15))
                        .foregroundColor(.red)
                        .transition(.opacity)
                }
                
                Spacer()
            }
            .padding(.top, 60)
        }
        .alert("Connected!", isPresented: $pairingSuccess) {
            Button("Start Journey", role: .cancel) {
                HapticsManager.shared.selection()
                // Navigate to main app
            }
        } message: {
            Text("You and your buddy are now connected!")
        }
    }
    
    private func copyCode() {
        HapticsManager.shared.copyCode()
        UIPasteboard.general.string = myCode
        // Show toast or feedback
    }
    
    private func connectWithBuddy() {
        HapticsManager.shared.connectButtonTapped()
        isPairing = true
        showError = false
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            isPairing = false
            
            // Simulate success or failure
            let success = Bool.random()
            
            if success {
                HapticsManager.shared.pairingSuccess()
                pairingSuccess = true
            } else {
                HapticsManager.shared.pairingFailed()
                withAnimation {
                    showError = true
                }
                
                // Hide error after 3 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    withAnimation {
                        showError = false
                    }
                }
            }
        }
    }
}

// MARK: - Slider with Haptic Feedback Example

struct HapticSliderView: View {
    @State private var cigPerDay: Double = 10
    @State private var lastSnapValue: Int = 10
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Cigarettes per day")
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.white)
            
            Text("\(Int(cigPerDay))")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.white)
            
            Slider(value: $cigPerDay, in: 0...50, step: 1)
                .tint(Color(hex: "#C1A7FF"))
                .onChange(of: cigPerDay) { newValue in
                    let intValue = Int(newValue)
                    
                    // Haptic at every 5 cigarettes milestone
                    if intValue % 5 == 0 && intValue != lastSnapValue {
                        HapticsManager.shared.sliderSnap()
                        lastSnapValue = intValue
                    }
                }
                .padding(.horizontal, 24)
        }
        .padding()
        .background(Color(hex: "#0D0D11"))
    }
}

// MARK: - Preview Helpers

#Preview("Breathing Exercise") {
    BreathingExerciseView()
}

#Preview("Badge Unlock - Minor") {
    BadgeUnlockView(badgeType: .sevenDays)
}

#Preview("Badge Unlock - Major") {
    BadgeUnlockView(badgeType: .thirtyDays)
}

#Preview("Buddy Pairing") {
    BuddyPairingView()
}

#Preview("Haptic Slider") {
    HapticSliderView()
}
