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
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
//                .environmentObject(router)
            
//            BadgeView()
                
            BuddyView()
                .environmentObject(registerVM)
                .environmentObject(buddyVM)
        }
    }
}
