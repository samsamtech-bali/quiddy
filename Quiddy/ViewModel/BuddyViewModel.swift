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
    
    func isAllowedToAdd(userRecord: CKRecord.ID) async -> Bool {
        do {
            let record = try await self.databasePublic.record(for: userRecord)
            
            
            guard let outgoingCode = record[QuiddyUserFields.outgoingCode.rawValue] as? String else { return false }
        
            if outgoingCode != "" && outgoingCode != "-" {
                print("isAllowedToAdd false")
                return false
            }
            print("isAllowedToAdd true")
            return true
            
        } catch {
            return false
        }
    }
    
    func addBuddy(userRecord: CKRecord.ID, userCode: String, buddyCode: String) async -> Void{
        do {
            print("Running addBuddy...")
            let dateNow = Date()
            
//            check if outgoing not "-"
            
            let isAllowed = await isAllowedToAdd(userRecord: userRecord)
            
            if isAllowed {
                print("user record id: \(String(describing: userRecord))")
    //            update user
                // update user's outgoing code with buddy's code
                // update user's invited date with date now
                let record = try await self.databasePublic.record(for: userRecord)
                
                record.setValue(buddyCode, forKey: QuiddyUserFields.outgoingCode.rawValue)
                record.setValue(dateNow, forKey: QuiddyUserFields.invitedDate.rawValue)
                
                _ = try await self.databasePublic.save(record)
                
    //            update buddy
                // update buddy's incoming code with user's code
                // update buddy's invited date with date now
                
                let buddyRecordModel = try await RegisterViewModel().fetchByUniqueCode(buddyCode)
                let buddyRecord = try await self.databasePublic.record(for: buddyRecordModel!.getRecord().recordID)
                buddyRecord.setValue(userCode, forKey: QuiddyUserFields.incomingCode.rawValue)
                buddyRecord.setValue(dateNow, forKey: QuiddyUserFields.invitedDate.rawValue)
                
                _ = try await self.databasePublic.save(buddyRecord)
            } else {
                print("User is not allowed to add more buddy!")
            }
        } catch {
            print("Error addBuddy: \(error.localizedDescription)")
        }
    }
    
    func rejectBuddy(userRecord: CKRecord.ID, incomingCode: String) async {
        do {
            print("Running rejectBuddy")
            //        get date now
            let dateNow = Date()
            let emptyString: String = "-"
            
                    //  remove incoming code change to - for user
                    // update invitedDate
            let record = try await self.databasePublic.record(for: userRecord)
            record.setValue(emptyString, forKey: QuiddyUserFields.incomingCode.rawValue)
            record.setValue(dateNow, forKey: QuiddyUserFields.invitedDate.rawValue)
            
            _ = try await self.databasePublic.save(record)
                    
            //        get buddy from incoming code
            let buddyRecordModel = try await RegisterViewModel().fetchByUniqueCode(incomingCode)
                    
                    // remove buddy's outgoing code
                    // update invitedDate
            let buddyRecord = try await self.databasePublic.record(for: buddyRecordModel!.getRecord().recordID)
            buddyRecord.setValue(emptyString, forKey: QuiddyUserFields.outgoingCode.rawValue)
            buddyRecord.setValue(dateNow, forKey: QuiddyUserFields.invitedDate.rawValue)
            
            _ = try await self.databasePublic.save(buddyRecord)
                    
        } catch {
            print("Error rejectBuddy: \(error.localizedDescription)")
        }

    }
    
    func acceptBuddy(userRecord: CKRecord.ID, incomingCode: String) async {
        do {
            print("Running acceptBuddy")
            
            let dateNow = Date()
            let emptyString: String = "-"
            
//            update user's data
            // update buddy code field with incoming code
            // remove incoming code field with "-"
            // update invitedDate
            let record = try await self.databasePublic.record(for: userRecord)
            print("record: \(record)")
            record.setValue(incomingCode, forKey: QuiddyUserFields.buddyCode.rawValue)
            record.setValue(emptyString, forKey: QuiddyUserFields.incomingCode.rawValue)
            record.setValue(dateNow, forKey: QuiddyUserFields.invitedDate.rawValue)
            record.setValue(dateNow, forKey: QuiddyUserFields.buddyStartDate.rawValue)
            
            _ = try await self.databasePublic.save(record)
            
//            update buddy's data
            // get buddy data
            // update buddy code with outgoing code
            // remove outgoing code field with "-"
            // update invitedDate
            let buddyRecordModel = try await RegisterViewModel().fetchByUniqueCode(incomingCode)
            let buddyRecord = try await self.databasePublic.record(for: buddyRecordModel!.getRecord().recordID)
            print("buddy record: \(buddyRecord)")
            
            let outgoingCode = buddyRecord[QuiddyUserFields.outgoingCode.rawValue] as? String
            print("outgoing code: \(String(describing: outgoingCode))")
            
            buddyRecord.setValue(outgoingCode, forKey: QuiddyUserFields.buddyCode.rawValue)
            buddyRecord.setValue(emptyString, forKey: QuiddyUserFields.outgoingCode.rawValue)
            buddyRecord.setValue(dateNow, forKey: QuiddyUserFields.invitedDate.rawValue)
            buddyRecord.setValue(dateNow, forKey: QuiddyUserFields.buddyStartDate.rawValue)
//            update buddy start date
            
            _ = try await self.databasePublic.save(buddyRecord)
            
        } catch {
            print("Error acceptBuddy: \(error.localizedDescription)")
        }
    }

    func updateBuddyCode(_ userRecord: QuiddyUserModel, userCode: String, buddyCode: String) async -> Void {
        do {
            //    update add buddy code to user's record
//            let userRecord = try await RegisterViewModel().fetchByUniqueCode(userCode)
            let dateNow = Date()
            
            print("user record: \(String(describing: userRecord))")
            
            let recordID = try await self.databasePublic.record(for: userRecord.getRecord().recordID)
            print("user record id: \(String(describing: recordID))")
            
            recordID.setValue(buddyCode, forKey: QuiddyUserFields.buddyCode.rawValue)
            recordID.setValue(dateNow, forKey: QuiddyUserFields.buddyStartDate.rawValue)
            
            
            _ = try await self.databasePublic.save(recordID)
            
            //    update buddy's record to add user's code
            let buddyRecord = try await RegisterViewModel().fetchByUniqueCode(buddyCode)
            print("buddy record: \(String(describing: userRecord))")
            
            let buddyRecordID = try await self.databasePublic.record(for: buddyRecord!.getRecord().recordID)
            buddyRecordID.setValue(userCode, forKey: QuiddyUserFields.buddyCode.rawValue)
            buddyRecordID.setValue(dateNow, forKey: QuiddyUserFields.buddyStartDate.rawValue)
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
            
            var newQuiddyCode: String = ""
            
            newQuiddyCode = RegisterViewModel().generateRandomUniqueString()
            
            while await RegisterViewModel().isCodeExisted(code: newQuiddyCode) == true {
                newQuiddyCode = RegisterViewModel().generateRandomUniqueString()
            }
            
            recordID.setValue(newQuiddyCode, forKey: QuiddyUserFields.quiddyCode.rawValue)
            print("new buddy record id: \(newQuiddyCode)")
            
            _ = try await self.databasePublic.save(recordID)
            
//            update buddy quiddy code
            let buddyRecordID = try await self.databasePublic.record(for: buddyRecord.getRecord().recordID)
            buddyRecordID.setValue("-", forKey: QuiddyUserFields.buddyCode.rawValue)
            print("buddy record id: \(String(describing: buddyRecordID))")
            
            var newBuddyQuiddyCode: String = ""
            
            newBuddyQuiddyCode = RegisterViewModel().generateRandomUniqueString()
            
            while await RegisterViewModel().isCodeExisted(code: newBuddyQuiddyCode) == true {
                newBuddyQuiddyCode = RegisterViewModel().generateRandomUniqueString()
            }
            
            buddyRecordID.setValue(newBuddyQuiddyCode, forKey: QuiddyUserFields.quiddyCode.rawValue)
            print("new buddy record id: \(newBuddyQuiddyCode)")
            
            _ = try await self.databasePublic.save(buddyRecordID)
            
        } catch {
            print("error: \(error.localizedDescription)")
            return
        }
    }
    

}
