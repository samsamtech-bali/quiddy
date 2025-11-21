//
//  PushNotification.swift
//  Quiddy
//
//  Created by stephan on 17/11/25.
//

import SwiftUI
import CloudKit

struct PushNotification: View {
    @StateObject private var vm = PushNotificationViewModel()
    
    var body: some View {
        VStack {
            Button("Request notification permissions", action: {
                vm.requestNotificationPermissions()
            })
            
            Button("Subscribe to notification", action: {
                vm.subscribeToNotifications()
            })
            
            Button("Unsubscribe to notification", action: {
                vm.unsubscribeToNotifications()
            })
        }
    }
}

#Preview {
    PushNotification()
}
