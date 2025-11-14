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
    
    
    func daysSmokesFree(_ updatedStopDate: Date) -> Int {
        //        NOTE: use updatedStopDate not stopDate
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day], from: updatedStopDate, to: now)
        return max(0, components.day ?? 0)
    }
    
    func calculateMoneySaved(record: QuiddyUserModel) -> Int {
//        TODO: refactor logic use stopDate and decrease with relapse date
        
        let stopDate = record.stopDate
        let arrRelapseDate = record.relapseDate
        
        print("stopDate: \(stopDate)")
        print("arrRelapseDate: \(arrRelapseDate)")
        
//        for date in arrRelapseDate {
//            let status = filteredRelapseDate.contains { $0 == date }
//            
//            if status == false {
//                filteredRelapseDate.append(date)
//            } else {
//                continue
//            }
//        }
        
        
        let relapseDays = arrRelapseDate.count
        print("relapseDays: \(relapseDays)")
        
        let smokeFreeSinceStart = daysSmokesFree(stopDate)
        let totalFree = smokeFreeSinceStart - relapseDays
        
        let cigPerDay = record.cigPerDay
        let pricePerCig = record.pricePerCig
        
        print("smokeFreeSinceStart: \(smokeFreeSinceStart)")
        print("totalFree: \(totalFree)")
        print("cigPerDay: \(cigPerDay)")
        print("pricePerCig: \(pricePerCig)")
        
        let dailyCost = cigPerDay * Int(pricePerCig)
        print("dailyCost: \(dailyCost)")
        return Int(dailyCost) * totalFree
    }
    
    func reset(userRecord: CKRecord.ID, buddyRecord: CKRecord.ID, userRelapseDate: inout [Date]) async {
        do {
            print("Running reset...")
            let userRecordID = try await self.databasePublic.record(for: userRecord)
            let buddyRecordID = try await self.databasePublic.record(for: buddyRecord)
            
            print("args userRecord: \(userRecordID)")
            print("args buddyRecord: \(buddyRecordID)")
            
            print("userRelapseDate: \(userRelapseDate)")
            
            let dateNow = Date()
            var condition: Bool = false
            
//            check if already contain date no need to save
            for date in userRelapseDate {
                print("looping through userRelapseDate: \(date)")
                let matched = userRelapseDate.contains {
                    print("$0 is \($0)")
                    let userRelapseDateComponent = Calendar.current.dateComponents([.day, .year, .month], from: $0)
                    let dateNowComponent = Calendar.current.dateComponents([.day, .year, .month], from: dateNow)
                    print("userRelapseDateComponent: \(userRelapseDateComponent)")
                    print("dateNowComponent: \(dateNowComponent)")
                    print("result: \(userRelapseDateComponent == dateNowComponent)")
                    return userRelapseDateComponent == dateNowComponent
                }
                
                print("matched: \(matched)")
                
                if matched == false {
                    print("matched false")
                    condition = false
                    continue
                } else {
                    print("matched true")
                    condition = true
                    break
                }
                
            }
            
            print("break the loop")
            
            if condition == false {
                print("condition false so append...")
                userRelapseDate.append(dateNow)
            }
            
            //        reset userRecord
            userRecordID.setValuesForKeys([
                QuiddyUserFields.updatedStopDate.rawValue: dateNow,
                QuiddyUserFields.buddyStartDate.rawValue: dateNow,
                QuiddyUserFields.relapseDate.rawValue: userRelapseDate
            ])
            
            _ = try await self.databasePublic.save(userRecordID)
            print("user record updated!")
            //        reset buddyRecord
            buddyRecordID.setValuesForKeys([
                QuiddyUserFields.buddyStartDate.rawValue: dateNow
            ])
            
            _ = try await self.databasePublic.save(buddyRecordID)
            print("buddy record updated!")
        } catch {
            print("Error reset: \(error.localizedDescription)")
            return
        }
        
        
        
    }
    
    func addBadge(name: String) {
        
    }
    
}
