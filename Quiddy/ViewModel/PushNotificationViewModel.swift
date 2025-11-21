//
//  PushNotificationViewModel.swift
//  Quiddy
//
//  Created by stephan on 17/11/25.
//

import Foundation
import CloudKit
import UserNotifications
import UIKit

class PushNotificationViewModel: ObservableObject {
    let container: CKContainer
    let databasePublic: CKDatabase
    
    init() {
        self.container = CKContainer(identifier: "iCloud.com.stephan.iCloud")
        self.databasePublic =  container.publicCloudDatabase
    }
    
    func requestNotificationPermissions() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        UNUserNotificationCenter.current().requestAuthorization(options: options, completionHandler: { success, error in
            if let error = error {
                print(error)
            } else if success {
                print("Notification permissions success!")
                
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Notification permissions failure.")
            }
            
        })
    }
    
    
    func subscribeToNotifications() {
        
        let predicate = NSPredicate(value: true)
        
        let subscription = CKQuerySubscription(recordType: RecordNames.BuddyBadge.rawValue, predicate: predicate, subscriptionID: "badge_achieved_together", options: .firesOnRecordCreation)
        
        let notification = CKSubscription.NotificationInfo()
        notification.title = "There's a new fruit!"
        notification.alertBody = "Open the app to check your fruits."
        notification.soundName = "default"
        
        subscription.notificationInfo = notification
        
        container.publicCloudDatabase.save(subscription) { returnedSubscription, returnedError in
            if let error = returnedError {
                print(error)
            } else {
                print("Successfully subscribed to notifications!")
            }
            
        }
    }
    
    func unsubscribeToNotifications() {
        container.publicCloudDatabase.delete(withSubscriptionID: "badge_achieved_together", completionHandler: { returnedID, returnedError in
            if let error = returnedError {
                print(error)
            } else {
                print("Successfully unsubscribed!")
            }
        })
    }
    
    func subscribeToNudgeNotifications(sender: String, receiver: String) {
        
        let predicate = NSPredicate(format: "sender == %@ AND receiver == %@", sender, receiver)
//        let predicate = NSPredicate(value: true)
        
        print("predicate: \(predicate)")
        
        let subscription = CKQuerySubscription(recordType: RecordNames.BuddyNudge.rawValue, predicate: predicate, subscriptionID: "buddy_nudge", options: .firesOnRecordCreation)
        
//        let message = BuddyNudgeViewModel().randomMessage()
        
        let notification = CKSubscription.NotificationInfo()
        notification.title = "\(sender) nudge you!"
        notification.alertBody = "You got message from \(sender)!"
        
        subscription.notificationInfo = notification
        
        container.publicCloudDatabase.save(subscription) { returnedSubscription, returnedError in
            if let error = returnedError {
                print("error subscribeToNudgeNotifications: \(error.localizedDescription)")
            } else {
                print("Successfully subscribed to buddy nudge!")
            }
        }
    }
    
    func unsubscribeToNudgeNotifications() {
        container.publicCloudDatabase.delete(withSubscriptionID: "buddy_nudge", completionHandler: { returnedID, returnedError in
            if let error = returnedError {
                print("Error unsubscribeToNudgeNotifications: \(error.localizedDescription)")
            } else {
                print("Successfully unsubscribeToNudgeNotifications!")
            }
        })
    }
    
    
    
    
    
    
}
