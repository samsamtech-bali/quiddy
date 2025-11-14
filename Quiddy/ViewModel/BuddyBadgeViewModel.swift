//
//  BuddyBadgeViewModel.swift
//  Quiddy
//
//  Created by stephan on 13/11/25.
//

import Foundation
import CloudKit

class BuddyBadgeViewModel: ObservableObject {
    let container: CKContainer
    let databasePublic: CKDatabase
    
    init() {
        self.container = CKContainer(identifier: "iCloud.com.stephan.iCloud")
        self.databasePublic = container.publicCloudDatabase
    }
    
    func addBuddyBadge(userRecord: CKRecord.ID, buddyRecord: CKRecord.ID, badgeType: String, badgeName: String) async -> BuddyBadgeModel? {
        do {
            print("Running addBuddyBadge function...")
            
            let dateNow = Date()
            let userRecordName = userRecord.recordName
            let buddyRecordName = buddyRecord.recordName
            
            let buddyBadge = BuddyBadgeModel(
                userA: userRecordName, userB: buddyRecordName, badgeType: badgeType, badgeName: badgeName, obtainedDate: dateNow
            )
            let buddyBadgeRecord = buddyBadge.getRecord()
            let record = try await databasePublic.save(buddyBadgeRecord)
            
            let newBuddyBadge = BuddyBadgeModel(record)
            print("buddy badge: \(String(describing: newBuddyBadge))")
            return newBuddyBadge
        } catch {
            print("Error addBuddyBadge: \(error.localizedDescription)")
            return nil
        }
        
    }
    
    func calculateSharedStreak(since buddyStartDate: Date) -> Int {
//        TODO: maybe need another check could not less than user's and buddy's updatedStopDate
        
//        user buddy start date until day now return days
        let dateNow = Date()
        
        let components = Calendar.current.dateComponents([.day], from: buddyStartDate, to: dateNow)
        
        return max(0, components.day ?? 0)
    }
    
    func calculateSharedMoneySaved(userRecord: QuiddyUserModel, buddyRecord: QuiddyUserModel) -> Int {
//        calculate user money
        let userMoneySaved = BadgeViewModel().calculateMoneySaved(record: userRecord)
        print("userMoneySaved: \(userMoneySaved)")
        
//        calculate buddy money
        let buddyMoneySaved = BadgeViewModel().calculateMoneySaved(record: buddyRecord)
        print("buddyMoneySaved: \(buddyMoneySaved)")
        
        let total = userMoneySaved + buddyMoneySaved
        print("total: \(total)")
        return total
    }
    
}
