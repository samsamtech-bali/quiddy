//
//  QuiddyApp.swift
//  Quiddy
//
//  Created by stephan on 05/11/25.
//

import SwiftUI

@main
struct QuiddyApp: App {
    @StateObject private var router = Router.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
//            BadgeView()
                .environmentObject(router)
        }
    }
}
