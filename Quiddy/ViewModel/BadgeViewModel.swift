//
//  BadgeViewModel.swift
//  Quiddy
//
//  Created by stephan on 06/11/25.
//

import Foundation
import CloudKit


class BadgeViewModel: ObservableObject {
    let container: CKContainer
    let databasePublic: CKDatabase
    
    init() {
        self.container = CKContainer(identifier: "iCloud.com.stephan.iCloud")
        //        self.container = CKContainer.default()
        self.databasePublic = container.publicCloudDatabase
    }
    
    func createBadge(_ badgeTitle: String, _ badgeDescription: String) async -> BadgeModel? {
        do {
            print("Running create badge function...")
            let badge = BadgeModel(badgeTitle: badgeTitle, badgeDescription: badgeDescription)
            let badgeRecord = badge.getRecord()
            let record = try await databasePublic.save(badgeRecord)
            let newBadge = BadgeModel(record)
            print("badge id: \(String(describing: newBadge?.badgeID))")
            return newBadge
        } catch {
            print("Error creating badge: \(error)")
            return nil
        }
    }
    
    func getBadge(_ badgeName: String) async-> BadgeModel? {
        let recordId = CKRecord.ID(recordName: badgeName)
        do {
            let record = try await self.databasePublic.record(for: recordId)
            return BadgeModel(record)
        } catch {
            print("Record not found: \(error)")
            return nil
        }
    }
    
    func updateBadgeTitle(newBadgeTitle: String, badge: BadgeModel) async -> Void {
        do {
            let badgeRecord = try await self.databasePublic.record(for: badge.getRecord().recordID)
            badgeRecord.setValue(BadgeFields.title.rawValue, forKey: newBadgeTitle)
            _ = try await self.databasePublic.save(badgeRecord)
            badge.badgeTitle = newBadgeTitle
        } catch {
            print("Error updating badge record: \(error)")
            return
        }
    }
    
    func deleteBadge(_ badge: BadgeModel) async -> Void {
        do {
            let record = badge.getRecord()
            try await self.databasePublic.deleteRecord(withID: record.recordID)
        } catch {
            print("Error deleting project record: \(error)")
            return
        }
    }
    
    func fetchCurrentUserRecordName() async -> String {
        do {
            let userRecordName = try await container.userRecordID()
            print("user record name should be: \(userRecordName)")
            return userRecordName.recordName
        } catch {
            print("Error updating badge record: \(error)")
            return "No data"
        }
    }
    
}
