//
//  BuddyBadgeModel.swift
//  Quiddy
//
//  Created by stephan on 13/11/25.
//

import Foundation
import CloudKit

class BuddyBadgeModel {
    public var buddyBadgeID: CKRecord.ID?
    public var userA: String
    public var userB: String
    public var badgeType: String
    public var badgeName: String
    public var obtainedDate: Date
    
    func getRecord() -> CKRecord {
        let buddyBadgeRecord = CKRecord(recordType: RecordNames.BuddyBadge.rawValue, recordID: buddyBadgeID ?? CKRecord(recordType: RecordNames.BuddyBadge.rawValue, recordID: CKRecord.ID(recordName: UUID().uuidString)).recordID)
        
        buddyBadgeRecord.setValuesForKeys([
            BuddyBadgeFields.userA.rawValue: self.userA,
            BuddyBadgeFields.userB.rawValue: self.userB,
            BuddyBadgeFields.badgeType.rawValue: self.badgeType,
            BuddyBadgeFields.badgeName.rawValue: self.badgeName,
            BuddyBadgeFields.obtainedDate.rawValue: self.obtainedDate
        ])
        
        return buddyBadgeRecord
    }
    
    init?(_ record: CKRecord) {
        guard let userA = record[BuddyBadgeFields.userA.rawValue] as? String else { return nil }
        self.userA = userA
        
        guard let userB = record[BuddyBadgeFields.userB.rawValue] as? String else { return nil }
        self.userB = userB
        
        guard let badgeType = record[BuddyBadgeFields.badgeType.rawValue] as? String else { return nil }
        self.badgeType = badgeType
        
        guard let badgeName = record[BuddyBadgeFields.badgeName.rawValue] as? String else { return nil }
        self.badgeName = badgeName
        
        guard let obtainedDate = record[BuddyBadgeFields.obtainedDate.rawValue] as? Date else { return nil }
        self.obtainedDate = obtainedDate
        
        self.buddyBadgeID = record.recordID
    }
    
    init(
        buddyBadgeID: CKRecord.ID? = nil,
        userA: String,
        userB: String,
        badgeType: String,
        badgeName: String,
        obtainedDate: Date
    ) {
        self.buddyBadgeID = buddyBadgeID
        self.userA = userA
        self.userB = userB
        self.badgeType = badgeType
        self.badgeName = badgeName
        self.obtainedDate = obtainedDate
    }
}

enum BuddyBadgeFields: String {
    case buddyBadgeID
    case userA
    case userB
    case badgeType
    case badgeName
    case obtainedDate
}
