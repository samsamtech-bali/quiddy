//
//  HapticsManager.swift
//  Quiddy
//
//  Created by Kelvin on 14/11/25.
//

import SwiftUI
import UIKit

/// Centralized haptic feedback manager
/// Respects system accessibility settings and provides debouncing
final class HapticsManager {
    
    // MARK: - Singleton
    static let shared = HapticsManager()
    private init() {}
    
    // MARK: - Generators
    private let selectionGenerator = UISelectionFeedbackGenerator()
    private let impactLight = UIImpactFeedbackGenerator(style: .light)
    private let impactMedium = UIImpactFeedbackGenerator(style: .medium)
    private let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
    private let notificationGenerator = UINotificationFeedbackGenerator()
    
    // MARK: - Debounce Tracking
    private var lastHapticTime: [String: Date] = [:]
    private let debounceInterval: TimeInterval = 0.1 // 100ms minimum between same haptics
    
    // MARK: - Settings
    private var isHapticsEnabled: Bool {
        // Check if user has reduced motion enabled (we respect this for haptics too)
        return !UIAccessibility.isReduceMotionEnabled
    }
    
    // MARK: - Debounce Logic
    private func shouldTrigger(for key: String) -> Bool {
        guard isHapticsEnabled else { return false }
        
        let now = Date()
        if let lastTime = lastHapticTime[key] {
            guard now.timeIntervalSince(lastTime) >= debounceInterval else {
                return false
            }
        }
        lastHapticTime[key] = now
        return true
    }
    
    // MARK: - Public Haptic Methods
    
    /// Light haptic for selections, toggles, and small interactions
    func selection() {
        guard shouldTrigger(for: "selection") else { return }
        selectionGenerator.selectionChanged()
    }
    
    /// Very subtle impact for micro-interactions
    func lightImpact() {
        guard shouldTrigger(for: "lightImpact") else { return }
        impactLight.impactOccurred()
    }
    
    /// Medium impact for confirmations and important actions
    func mediumImpact() {
        guard shouldTrigger(for: "mediumImpact") else { return }
        impactMedium.impactOccurred()
    }
    
    /// Heavy impact for major moments (use sparingly)
    func heavyImpact() {
        guard shouldTrigger(for: "heavyImpact") else { return }
        impactHeavy.impactOccurred()
    }
    
    /// Success pattern for achievements, connections, completions
    func success() {
        guard shouldTrigger(for: "success") else { return }
        notificationGenerator.notificationOccurred(.success)
    }
    
    /// Warning pattern for errors, invalid inputs
    func warning() {
        guard shouldTrigger(for: "warning") else { return }
        notificationGenerator.notificationOccurred(.warning)
    }
    
    /// Error pattern for critical failures
    func error() {
        guard shouldTrigger(for: "error") else { return }
        notificationGenerator.notificationOccurred(.error)
    }
    
    // MARK: - Advanced Patterns
    
    /// Success pulse pattern for badge reveals
    func successPulse() {
        guard isHapticsEnabled else { return }
        
        lightImpact()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.mediumImpact()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.success()
        }
    }
    
    /// Breathing exercise pattern - gentle pulses
    /// - Parameters:
    ///   - phase: "inhale", "hold", or "exhale"
    ///   - duration: how long this phase lasts
    func breathingPulse(phase: BreathingPhase, duration: TimeInterval) {
        guard isHapticsEnabled else { return }
        
        switch phase {
        case .inhale:
            // Soft tick at start
            lightImpact()
            
        case .hold:
            // Optional single pulse in the middle
            DispatchQueue.main.asyncAfter(deadline: .now() + duration / 2) { [weak self] in
                self?.lightImpact()
            }
            
        case .exhale:
            // Gentle pulses throughout exhale
            let pulseCount = Int(duration / 1.5) // One pulse every 1.5 seconds
            for i in 0..<pulseCount {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 1.5) { [weak self] in
                    self?.lightImpact()
                }
            }
            
        case .complete:
            // Success pulse at end
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.success()
            }
        }
    }
    
    /// Drawing checkmark haptic - subtle feedback as user draws
    func drawingStart() {
        guard isHapticsEnabled else { return }
        selection()
    }
    
    /// Checkmark completion - satisfying feedback
    func checkmarkCompleted() {
        guard isHapticsEnabled else { return }
        mediumImpact()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
            self?.success()
        }
    }
    
    /// Slider snap haptic - triggered at specific values
    func sliderSnap() {
        guard shouldTrigger(for: "sliderSnap") else { return }
        selection()
    }
    
    /// Page transition haptic - when page fully settles
    func pageTransition() {
        guard shouldTrigger(for: "pageTransition") else { return }
        selection()
    }
    
    // MARK: - Badge Unlock Patterns
    
    /// Minor milestone badge (7 days, small achievements)
    func badgeUnlockMinor() {
        guard isHapticsEnabled else { return }
        lightImpact()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.mediumImpact()
        }
    }
    
    /// Major milestone badge (30, 90, 120 days)
    func badgeUnlockMajor() {
        guard isHapticsEnabled else { return }
        mediumImpact()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
            self?.heavyImpact()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.success()
        }
    }
    
    // MARK: - Pairing Screen Placeholders
    
    /// Haptic when user taps "Copy Code" button
    func copyCode() {
        guard isHapticsEnabled else { return }
        lightImpact()
    }
    
    /// Haptic when "Connect" button is tapped
    func connectButtonTapped() {
        guard isHapticsEnabled else { return }
        selection()
    }
    
    /// Success haptic when pairing succeeds
    func pairingSuccess() {
        guard isHapticsEnabled else { return }
        mediumImpact()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.success()
        }
    }
    
    /// Warning haptic when pairing fails
    func pairingFailed() {
        guard isHapticsEnabled else { return }
        warning()
    }
    
    /// Haptic when entering buddy code (per digit or on submit)
    func codeInput() {
        guard shouldTrigger(for: "codeInput") else { return }
        selection()
    }
    
    // MARK: - Prepare Generators
    
    /// Call this before expected haptic feedback for better responsiveness
    func prepare() {
        selectionGenerator.prepare()
        impactLight.prepare()
        impactMedium.prepare()
        impactHeavy.prepare()
        notificationGenerator.prepare()
    }
}

// MARK: - Supporting Types

enum BreathingPhase {
    case inhale
    case hold
    case exhale
    case complete
}

// MARK: - SwiftUI View Extension

extension View {
    /// Adds haptic feedback to any view tap
    func hapticFeedback(_ style: HapticStyle = .selection, onTap: @escaping () -> Void) -> some View {
        self.onTapGesture {
            HapticsManager.shared.trigger(style)
            onTap()
        }
    }
    
    /// Adds haptic feedback with custom trigger
    func hapticOn(_ trigger: Bool, style: HapticStyle) -> some View {
        self.onChange(of: trigger) { newValue in
            if newValue {
                HapticsManager.shared.trigger(style)
            }
        }
    }
}

enum HapticStyle {
    case selection
    case light
    case medium
    case heavy
    case success
    case warning
    case error
}

extension HapticsManager {
    func trigger(_ style: HapticStyle) {
        switch style {
        case .selection: selection()
        case .light: lightImpact()
        case .medium: mediumImpact()
        case .heavy: heavyImpact()
        case .success: success()
        case .warning: warning()
        case .error: error()
        }
    }
}
