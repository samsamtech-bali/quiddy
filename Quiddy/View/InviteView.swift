//
//  InviteView.swift
//  Quiddy
//
//

import SwiftUI

struct InviteView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var registerVM: RegisterViewModel
    @EnvironmentObject private var buddyVM: BuddyViewModel
    @State private var buddyCode: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    @State private var showCopyFeedback = false
    @State private var userRecord: QuiddyUserModel?
    
    var body: some View {
        ZStack {
            Color(hex: "#0D0D11")
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                // Header Section
                VStack(spacing: 16) {
                    Text("Start your journey with a buddy")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("Share your code with them so you can start\nthis journey together.")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .lineSpacing(2)
                }
                .padding(.top, 40)
                
                // Input Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Enter your buddy's code")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white)
                    
                    TextField("e.g. 12345abcde", text: $buddyCode)
                        .font(.system(size: 17))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.white.opacity(0.3), lineWidth: 1)
                        )
                    
                    Button(action: connectToBuddy) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            }
                            Text("Connect")
                                .font(.system(size: 17, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.7, green: 0.6, blue: 0.9),
                                    Color(red: 0.5, green: 0.3, blue: 0.8)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(24)
                    }
                    .disabled(buddyCode.isEmpty || isLoading)
                    .opacity(buddyCode.isEmpty ? 0.5 : 1.0)
                }
                
                // Divider Section
                HStack {
                    Rectangle()
                        .fill(.white.opacity(0.3))
                        .frame(height: 1)
                    
                    Text("or")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.horizontal, 16)
                    
                    Rectangle()
                        .fill(.white.opacity(0.3))
                        .frame(height: 1)
                }
                
                // User's Code Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Your invite code")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white)
                    
                    HStack {
                        Text(userRecord?.quiddyCode ?? "No Value")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 20)
                        
                        Button(action: copyCodeToClipboard) {
                            Text(showCopyFeedback ? "COPIED!" : "COPY")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(showCopyFeedback ? Color.green.opacity(0.3) : Color.white.opacity(0.2))
                                .cornerRadius(16)
                        }
                        .padding(.trailing, 8)
                    }
                    .frame(height: 56)
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(28)
                    
                    Button(action: shareCode) {
                        Text("Share your code")
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(.white.opacity(0.3), lineWidth: 1)
                            )
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 24)
        }
        .navigationBarHidden(true)
        .overlay(
            // Back Button
            VStack {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                    }
                    .padding(.leading, 24)
                    .padding(.top, 16)
                    
                    Spacer()
                }
                Spacer()
            }
        )
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        }
        .onAppear {
            Task {
                do {
                    userRecord = try await registerVM.fetchByRecordName()
                    print("User record loaded: \(String(describing: userRecord?.username))")
                } catch {
                    print("Failed to load user record: \(error)")
                }
            }
        }
    }
    
    private func connectToBuddy() {
        guard !buddyCode.isEmpty else { return }
        
        isLoading = true
        Task {
            do {
                print("Submiting buddy code: \(buddyCode)")
                
                // Get current user record if not already loaded
                if userRecord == nil {
                    userRecord = try await registerVM.fetchByRecordName()
                }
                
                guard let userRecord = self.userRecord else {
                    await MainActor.run {
                        isLoading = false
                        alertMessage = "Unable to load your profile. Please try again."
                        showingAlert = true
                    }
                    return
                }
                
                // Check if user is trying to add themselves
                if userRecord.quiddyCode == buddyCode {
                    await MainActor.run {
                        isLoading = false
                        alertMessage = "You cannot add yourself as a buddy."
                        showingAlert = true
                    }
                    return
                }
                
                // Check if code exists
                let codeExists = await registerVM.isCodeExisted(code: buddyCode)
                print("Code exist: \(codeExists)")
                
                await MainActor.run {
                    isLoading = false
                    
                    if codeExists == false {
                        print("=== enter false state ===")
                        alertMessage = "There is no user with this code."
                        showingAlert = true
                    } else {
                        print("=== enter true state ===")
                        // Check if user is allowed to send invitation
                        Task {
                            let isAllowed = await buddyVM.isAllowedToAdd(userRecord: userRecord.getRecord().recordID)
                            
                            await MainActor.run {
                                if !isAllowed {
                                    alertMessage = "You already have a pending invitation. Please wait for a response or cancel your current request."
                                    showingAlert = true
                                } else {
                                    // Send buddy invitation
                                    Task {
                                        await buddyVM.addBuddy(
                                            userRecord: userRecord.getRecord().recordID,
                                            userCode: userRecord.quiddyCode,
                                            buddyCode: buddyCode
                                        )
                                        
                                        await MainActor.run {
                                            alertMessage = "Invitation sent! Your buddy will receive a request to connect with you."
                                            showingAlert = true
                                            buddyCode = ""
                                            
                                            // Dismiss view after successful invitation
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                                dismiss()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } catch {
                print("Error in connectToBuddy: \(error)")
                await MainActor.run {
                    isLoading = false
                    alertMessage = "Connection failed. Please check your network and try again."
                    showingAlert = true
                }
            }
        }
    }
    
    private func copyCodeToClipboard() {
        UIPasteboard.general.string = registerVM.quiddyCode
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        // Visual feedback
        showCopyFeedback = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showCopyFeedback = false
        }
    }
    
    private func shareCode() {
        let shareText = "Join me on my quit smoking journey! Use my code: \(registerVM.quiddyCode)"
        let activityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityVC, animated: true)
        }
    }
}

#Preview {
    InviteView()
        .environmentObject(RegisterViewModel())
        .environmentObject(BuddyViewModel())
}
