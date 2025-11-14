//
//  MainTabView.swift
//  Quiddy
//
//  Created by Jeremy Lumban Toruan on 10/11/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image("buddy-active")
                    Text("Home")
                }
            
            BreathingView()
                .tabItem {
                    Image("breathe-active")
                    Text("Breathing")
                }
        }
        .accentColor(.white)
        .background(Color(red: 0x12/255, green: 0x14/255, blue: 0x18/255))
    }
}

#Preview {
    MainTabView()
        .environmentObject(RegisterViewModel())
}
