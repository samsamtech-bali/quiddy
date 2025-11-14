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
    @StateObject private var badgeVM = BadgeViewModel()
    @StateObject private var buddyBadgeVM = BuddyBadgeViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(router)
                .environmentObject(registerVM)
                .environmentObject(buddyVM)
                .environmentObject(badgeVM)
                .environmentObject(buddyBadgeVM)
            
            
        }
        
    }
}
