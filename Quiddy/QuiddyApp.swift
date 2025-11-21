//
//  QuiddyApp.swift
//  Quiddy
//
//  Updated by Kelvin on 12/11/25.
//

import SwiftUI

@main
struct QuiddyApp: App {
    @StateObject private var router = Router.shared
    @StateObject private var registerVM = RegisterViewModel()
    @StateObject private var buddyVM = BuddyViewModel()
    @StateObject private var buddyBadgeVM = BuddyBadgeViewModel()
    @StateObject private var pushNotificationVM = PushNotificationViewModel()
    @StateObject private var buddyNudgeVM = BuddyNudgeViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
//            BuddyView()
                .environmentObject(router)
                .environmentObject(registerVM)
                .environmentObject(buddyVM)
                .environmentObject(buddyBadgeVM)
                .environmentObject(pushNotificationVM)
                .environmentObject(buddyNudgeVM)
            
//            PushNotification()
            
            
        }
        
    }
}
