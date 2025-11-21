//
//  BuddyNudgeModel.swift
//  Quiddy
//
//  Created by stephan on 17/11/25.
//

import Foundation
import CloudKit


class BuddyNudgeModel {
    public var buddyNudgeID: CKRecord.ID?
    public var sender: String
    public var receiver: String
    public var message: String
    
    
    func getRecord() -> CKRecord {
        let buddyNudgeRecord = CKRecord(recordType: RecordNames.BuddyNudge.rawValue, recordID: buddyNudgeID ?? CKRecord(recordType: RecordNames.BuddyNudge.rawValue, recordID: CKRecord.ID(recordName: UUID().uuidString)).recordID)
        
        buddyNudgeRecord.setValuesForKeys([
            BuddyNudgeFields.sender.rawValue: self.sender,
            BuddyNudgeFields.receiver.rawValue: self.receiver,
            BuddyNudgeFields.message.rawValue: self.message,
        ])
        
        return buddyNudgeRecord
    }
    
    init?(_ record: CKRecord) {
        guard let sender = record[BuddyNudgeFields.sender.rawValue] as? String else { return nil }
        self.sender = sender
        
        guard let receiver = record[BuddyNudgeFields.receiver.rawValue] as? String else { return nil }
        self.receiver = receiver
        
        guard let message = record[BuddyNudgeFields.message.rawValue] as? String else { return nil }
        self.message = message
        
        self.buddyNudgeID = record.recordID
    }
    
    init(
        buddyNudgeID: CKRecord.ID? = nil,
        sender: String,
        receiver: String,
        message: String
    ) {
        self.buddyNudgeID = buddyNudgeID
        self.sender = sender
        self.receiver = receiver
        self.message = message
    }
}

enum BuddyNudgeFields: String {
    case buddyNudgeID
    case sender
    case receiver
    case message
}
