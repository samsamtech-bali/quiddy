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
    public var buddyCode: String
    public var stopDate: Date
    public var updatedStopDate: Date
    public var cigPerDay: Int
    public var pricePerCig: Double
    public var dateCravingPressed: [Date]
    public var badges: String
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
            QuiddyUserFields.relapseDate.rawValue: self.relapseDate,
            QuiddyUserFields.buddyCode.rawValue: self.buddyCode
        ])
        
        return quiddyUserRecord
    }
    
    init?(_ record: CKRecord) {
        guard let username = record[QuiddyUserFields.username.rawValue] as? String else { return nil }
        self.username = username
        
        guard let quiddyCode = record[QuiddyUserFields.quiddyCode.rawValue] as? String else { return nil }
        self.quiddyCode = quiddyCode
        
        guard let stopDate = record[QuiddyUserFields.stopDate.rawValue] as? Date else { return nil }
        self.stopDate = stopDate
        
        guard let updatedStopDate = record[QuiddyUserFields.updatedStopDate.rawValue] as? Date else { return nil }
        self.updatedStopDate = updatedStopDate
        
        guard let cigPerDay = record[QuiddyUserFields.cigPerDay.rawValue] as? Int else { return nil }
        self.cigPerDay = cigPerDay
        
        guard let pricePerCig = record[QuiddyUserFields.pricePerCig.rawValue] as? Double else { return nil }
        self.pricePerCig = pricePerCig
        
        guard let dateCravingPressed = record[QuiddyUserFields.dateCravingPressed.rawValue] as? [Date] else { return nil }
        self.dateCravingPressed = dateCravingPressed
        
        guard let badges = record[QuiddyUserFields.badges.rawValue] as? String else { return nil }
        self.badges = badges
        
        guard let relapseDate = record[QuiddyUserFields.relapseDate.rawValue] as? [Date] else { return nil }
        self.relapseDate = relapseDate
        
        guard let buddyCode = record[QuiddyUserFields.buddyCode.rawValue] as? String else { return nil }
        self.buddyCode = buddyCode
        
        self.userID = record.recordID
    }
    
    
    init(
        userID: CKRecord.ID? = nil,
        username: String,
        quiddyCode: String,
        stopDate: Date,
        updatedStopDate: Date,
        cigPerDay: Int,
        pricePerCig: Double,
        dateCravingPressed: [Date],
        badges: String,
        relapseDate: [Date],
        buddyCode: String
    ) {
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
        self.buddyCode = buddyCode
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
    case buddyCode
}
