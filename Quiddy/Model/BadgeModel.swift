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

let badgeList = [
    (id: "streak7" , asset: "streak7.png", type: "streak", name: "7 Days", description: "lorem ipsum"),
    (id: "streak15" , asset: "streak15.png", type: "streak", name: "15 Days", description: "lorem ipsum"),
    (id: "streak30" , asset: "streak30.png", type: "streak", name: "30 Days", description: "lorem ipsum"),
    (id: "streak60" , asset: "streak60.png", type: "streak", name: "60 Days", description: "lorem ipsum"),
    (id: "streak120" , asset: "streak120.png", type: "streak", name: "120 Days", description: "lorem ipsum"),
    
    (id: "money100", asset: "money100.png", type: "money", name: "100.000 saved", description: "lorem ipsum"),
    (id: "money250", asset: "money250.png", type: "money", name: "250.000 saved", description: "lorem ipsum"),
    (id: "money500", asset: "money500.png", type: "money", name: "500.000 saved", description: "lorem ipsum"),
    (id: "money1000", asset: "money1000.png", type: "money", name: "1.000.000 saved", description: "lorem ipsum"),
    (id: "money2500", asset: "money2500.png", type: "money", name: "2.500.000 saved", description: "lorem ipsum")
]
