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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(router)
        }
    }
}
