//
//  BuddyViewModel.swift
//  Quiddy
//
//  Created by stephan on 11/11/25.
//

import Foundation
import CloudKit

class BuddyViewModel: ObservableObject {
    let container: CKContainer
    let databasePublic: CKDatabase
    
    init() {
        self.container = CKContainer(identifier: "iCloud.com.stephan.iCloud")
        self.databasePublic = container.publicCloudDatabase
    }
    

    func updateBuddyCode(_ userRecord: QuiddyUserModel, userCode: String, buddyCode: String) async -> Void {
        do {
            //    update add buddy code to user's record
//            let userRecord = try await RegisterViewModel().fetchByUniqueCode(userCode)
            print("user record: \(String(describing: userRecord))")
            
            let recordID = try await self.databasePublic.record(for: userRecord.getRecord().recordID)
            print("user record id: \(String(describing: recordID))")
            
            recordID.setValue(buddyCode, forKey: QuiddyUserFields.buddyCode.rawValue)
            
            
            _ = try await self.databasePublic.save(recordID)
            
            //    update buddy's record to add user's code
            let buddyRecord = try await RegisterViewModel().fetchByUniqueCode(buddyCode)
            print("buddy record: \(String(describing: userRecord))")
            
            let buddyRecordID = try await self.databasePublic.record(for: buddyRecord!.getRecord().recordID)
            buddyRecordID.setValue(userCode, forKey: QuiddyUserFields.buddyCode.rawValue)
            print("buddy record id: \(String(describing: buddyRecordID))")
            
            _ = try await self.databasePublic.save(buddyRecordID)
            
        } catch {
            print("error: \(error.localizedDescription)")
            return
        }
    }
    
    func removeBuddy(userRecord: QuiddyUserModel, buddyRecord: QuiddyUserModel) async -> Void {
        do {
            print("Running removeBuddy...")
//            update user quiddy code
            let recordID = try await self.databasePublic.record(for: userRecord.getRecord().recordID)
            print("user record id: \(String(describing: recordID))")
            recordID.setValue("-", forKey: QuiddyUserFields.buddyCode.rawValue)
            _ = try await self.databasePublic.save(recordID)
            
//            update buddy quiddy code
            let buddyRecordID = try await self.databasePublic.record(for: buddyRecord.getRecord().recordID)
            buddyRecordID.setValue("-", forKey: QuiddyUserFields.buddyCode.rawValue)
            print("buddy record id: \(String(describing: buddyRecordID))")
            _ = try await self.databasePublic.save(buddyRecordID)
            
        } catch {
            print("error: \(error.localizedDescription)")
            return
        }
    }
    

}
