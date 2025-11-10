//
//  QuiddyUserModel.swift
//  Quiddy
//
//  Created by stephan on 07/11/25.
//

import Foundation
import CloudKit

class QuiddyUserModel {
    public var userID: CKRecord.ID?
    public var username: String
    public var quiddyCode: String
    public var stopDate: Date
    public var updatedStopDate: Date
    public var cigPerDay: Int
    public var pricePerCig: Int
    public var dateCravingPressed: [Date]
    public var badges: [BadgeModel]
    public var relapseDate: [Date]
    
    func getRecord() -> CKRecord {
        let quiddyUserRecord  = CKRecord(recordType: RecordNames.QuiddyUsers.rawValue, recordID: userID ?? CKRecord(recordType: RecordNames.QuiddyUsers.rawValue, recordID: CKRecord.ID(recordName: UUID().uuidString)).recordID)
        
        quiddyUserRecord.setValuesForKeys([
            QuiddyUserFields.username.rawValue: self.username,
            QuiddyUserFields.quiddyCode.rawValue: self.quiddyCode,
            QuiddyUserFields.stopDate.rawValue: self.stopDate,
            QuiddyUserFields.updatedStopDate.rawValue: self.updatedStopDate,
            QuiddyUserFields.cigPerDay.rawValue: self.cigPerDay,
            QuiddyUserFields.pricePerCig.rawValue: self.pricePerCig,
            QuiddyUserFields.dateCravingPressed.rawValue: self.dateCravingPressed,
            QuiddyUserFields.badges.rawValue: self.badges,
            QuiddyUserFields.relapseDate.rawValue: self.relapseDate
        ])
        
        return quiddyUserRecord
    }
    
    init?(_ record: CKRecord) {
        guard let username = record[QuiddyUserFields.username.rawValue] as? String else { return nil }
        
        guard let quiddyUser = record[RecordNames.QuiddyUsers.rawValue] as? QuiddyUserModel else { return nil }
        self.username = quiddyUser.username
        self.quiddyCode = quiddyUser.quiddyCode
        self.stopDate = quiddyUser.stopDate
        self.updatedStopDate = quiddyUser.updatedStopDate
        self.cigPerDay = quiddyUser.cigPerDay
        self.pricePerCig = quiddyUser.pricePerCig
        self.dateCravingPressed = quiddyUser.dateCravingPressed
        self.badges = quiddyUser.badges
        self.relapseDate = quiddyUser.relapseDate
        
        self.userID = record.recordID
    }
    
    
    init(userID: CKRecord.ID? = nil, username: String, quiddyCode: String, stopDate: Date, updatedStopDate: Date, cigPerDay: Int, pricePerCig: Int, dateCravingPressed: [Date], badges: [BadgeModel], relapseDate: [Date]) {
        self.userID = userID
        self.username = username
        self.quiddyCode = quiddyCode
        self.stopDate = stopDate
        self.updatedStopDate = updatedStopDate
        self.cigPerDay = cigPerDay
        self.pricePerCig = pricePerCig
        self.dateCravingPressed = dateCravingPressed
        self.badges = badges
        self.relapseDate = relapseDate
    }
    
}

enum QuiddyUserFields: String {
    case userID
    case username
    case quiddyCode
    case stopDate
    case updatedStopDate
    case cigPerDay
    case pricePerCig
    case dateCravingPressed
    case badges
    case relapseDate
}
