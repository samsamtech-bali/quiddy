//
//  BadgeModel.swift
//  Quiddy
//
//  Created by stephan on 06/11/25.
//

import Foundation
import CloudKit

class BadgeModel: ObservableObject {
    public var badgeID: CKRecord.ID?
    public var badgeTitle: String
    public var badgeDescription: String
    
    func getRecord() -> CKRecord {
        let badgeRecord = CKRecord(recordType: RecordNames.Badges.rawValue, recordID: badgeID ?? CKRecord(recordType: RecordNames.Badges.rawValue, recordID: CKRecord.ID(recordName: UUID().uuidString)).recordID)
//        badgeRecord.setValue(self.badgeTitle, forKey: BadgeFields.badgeTitle.rawValue)
        badgeRecord.setValuesForKeys([
            BadgeFields.title.rawValue: self.badgeTitle,
            BadgeFields.description.rawValue: self.badgeDescription
        ])
        
        return badgeRecord
    }
    
    init?(_ record: CKRecord) {
        guard let badgeTitle = record[BadgeFields.title.rawValue] as? String else { return nil }
        self.badgeTitle = badgeTitle
        
        guard let badgeDescription = record[BadgeFields.description.rawValue] as? String else { return nil }
        self.badgeDescription = badgeDescription
        
        self.badgeID = record.recordID
    }
    
    init(badgeID: CKRecord.ID? = nil, badgeTitle: String, badgeDescription: String) {
        self.badgeID = badgeID
        self.badgeTitle = badgeTitle
        self.badgeDescription = badgeDescription
    }
}

enum BadgeFields: String {
    case id
    case title
    case description
}

enum RecordNames: String {
    case Badges
    case QuiddyUsers
}
