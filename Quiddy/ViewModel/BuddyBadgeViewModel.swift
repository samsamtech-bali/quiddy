//
//  BuddyBadgeViewModel.swift
//  Quiddy
//
//  Created by stephan on 13/11/25.
//

import Foundation
import CloudKit

class BuddyBadgeViewModel: ObservableObject {
    let container: CKContainer
    let databasePublic: CKDatabase
    
    @Published var availableBadges = []
    
    init() {
        self.container = CKContainer(identifier: "iCloud.com.stephan.iCloud")
        self.databasePublic = container.publicCloudDatabase
        
        self.availableBadges = [
            (id: "streak7" , asset: "streak7.png", type: "streak", name: "7 Days", description: "lorem ipsum", achieved: false, count: 0, threshold: 7),
            (id: "streak15" , asset: "streak15.png", type: "streak", name: "15 Days", description: "lorem ipsum", achieved: false, count: 0, threshold: 7),
            (id: "streak30" , asset: "streak30.png", type: "streak", name: "30 Days", description: "lorem ipsum", achieved: false, count: 0, threshold: 7),
            (id: "streak60" , asset: "streak60.png", type: "streak", name: "60 Days", description: "lorem ipsum", achieved: false, count: 0, threshold: 7),
            (id: "streak120" , asset: "streak120.png", type: "streak", name: "120 Days", description: "lorem ipsum", achieved: false, count: 0, threshold: 7),
            
            (id: "money100", asset: "money100.png", type: "money", name: "100.000 saved", description: "lorem ipsum", achieved: false, count: 0, threshold: 7),
            (id: "money250", asset: "money250.png", type: "money", name: "250.000 saved", description: "lorem ipsum", achieved: false, count: 0, threshold: 7),
            (id: "money500", asset: "money500.png", type: "money", name: "500.000 saved", description: "lorem ipsum", achieved: false, count: 0, threshold: 7),
            (id: "money1000", asset: "money1000.png", type: "money", name: "1.000.000 saved", description: "lorem ipsum", achieved: false, count: 0, threshold: 7),
            (id: "money2500", asset: "money2500.png", type: "money", name: "2.500.000 saved", description: "lorem ipsum", achieved: false, count: 0, threshold: 7)
        ]
    }
    
    func addBuddyBadge(userRecord: CKRecord.ID, buddyRecord: CKRecord.ID, badgeType: String, badgeThreshold: Int) async -> BuddyBadgeModel? {
        do {
            print("Running addBuddyBadge function...")
            print("threshold: \(badgeThreshold)")
            
            let dateNow = Date()
            let userRecordName = userRecord.recordName
            let buddyRecordName = buddyRecord.recordName
            
            let recordNames = compareUser(userRecordName: userRecordName, buddyRecordName: buddyRecordName)
            
            var badgeName: String = ""
            
            if badgeType == BadgeType.streak.rawValue {
                switch badgeThreshold {
                case 7:
                    badgeName = "7 Days"
                case 14:
                    badgeName = "14 Days"
                case 30:
                    badgeName = "30 Days"
                case 60:
                    badgeName = "60 Days"
                case 90:
                    badgeName = "90 Days"
                case 120:
                    badgeName = "120 Days"
                default:
                    badgeName = "Unknown"
                }
            } else if badgeType == BadgeType.moneySaved.rawValue {
                switch badgeThreshold {
                case 100000:
                    badgeName = "Rp 100.000 Saved"
                case 250000:
                    badgeName = "Rp 250.000 Saved"
                case 500000:
                    badgeName = "Rp 500.000 Saved"
                case 1000000:
                    badgeName = "Rp 1.000.000 Saved"
                case 2500000:
                    badgeName = "Rp 2.500.000 Saved"
                default:
                    badgeName = "Unknown"
                }
            }
            
            
            
            let buddyBadge = BuddyBadgeModel(
                userA: recordNames.userA, userB: recordNames.userB, badgeType: badgeType, badgeName: badgeName, badgeThreshold: badgeThreshold, obtainedDate: dateNow
            )
            let buddyBadgeRecord = buddyBadge.getRecord()
            let record = try await databasePublic.save(buddyBadgeRecord)
            
            let newBuddyBadge = BuddyBadgeModel(record)
            print("buddy badge: \(String(describing: newBuddyBadge))")
            return newBuddyBadge
        } catch {
            print("Error addBuddyBadge: \(error.localizedDescription)")
            return nil
        }
        
    }
    
    func fetchTogetherBadge(userRecordName: String, buddyRecordName: String) async throws -> [BuddyBadgeModel]? {
        print("Running fetchTogetherBadge with userRecordName: \(userRecordName), buddyRecordName: \(buddyRecordName)")
        
        let users = compareUser(userRecordName: userRecordName, buddyRecordName: buddyRecordName)
        
        let predicate = NSPredicate(format: "userA == %@ AND userB == %@", users.userA, users.userB)
        
        print("record type: \(RecordNames.BuddyBadge.rawValue)")
        let query = CKQuery(recordType: RecordNames.BuddyBadge.rawValue, predicate: predicate)
        
        return try await withCheckedThrowingContinuation{ continuation in
            let operation = CKQueryOperation(query: query)
            print("operation: \(operation)")
            
            var results: [BuddyBadgeModel] = []
            var result: BuddyBadgeModel?
            
            operation.recordMatchedBlock = { (returnedID, returnedResult) in
                switch returnedResult {
                case .success(let record):
                    print("record: \(record)")
                    result = BuddyBadgeModel(record)
                    print("result: \(String(describing: result))")
                    
                    guard let res = result else { return }
                    results.append(res)
                    
                    print("results: \(String(describing: results))")
                case .failure(let error):
                    print("Error recordMatchedBlock for returnID \(returnedID): \(error)")
                }
            }
            
            operation.queryResultBlock = { returnedResult in
                switch returnedResult {
                case .success:
                    print("reach success condition")
                    
                    print("last results: \(String(describing: results))")
                    continuation.resume(returning: results)
                case .failure(let error):
                    print("reach failure condition")
                    continuation.resume(throwing: error)
                }
            }
            
            container.publicCloudDatabase.add(operation)
            
        }
    }
    
    func fetchAllBadgesByTypeAndUserA(userRecordName: String, badgeType: String) async throws -> [BuddyBadgeModel]?{
        print("Running fetchAllBadgesByType for user \(userRecordName) and type \(badgeType)...")
        
        let predicate = NSPredicate(format: "badgeType == %@ && userA == %@", badgeType, userRecordName)
        
        print("predicate: \(predicate)")
        
        
        let query = CKQuery(recordType: RecordNames.BuddyBadge.rawValue, predicate: predicate)
        
        
        return try await withCheckedThrowingContinuation { continuation in
            let operation = CKQueryOperation(query: query)
            
            var results: [BuddyBadgeModel] = []
            var result: BuddyBadgeModel?
            
            operation.recordMatchedBlock = { (returnedID, returnedResult) in
                switch returnedResult {
                case .success(let record):
                    print("record: \(record)")
                    result = BuddyBadgeModel(record)
                    print("result: \(String(describing: result))")
                    
                    guard let res = result else { return }
                    results.append(res)
                    
                    print("results: \(String(describing: results))")
                case .failure(let error):
                    print("Error recordMatchedBlock for returnID \(returnedID): \(error)")
                }
            }
            
            operation.queryResultBlock = { returnedResult in
                switch returnedResult {
                case .success:
                    print("reach success condition")
                    
                    print("last results: \(String(describing: results))")
                    continuation.resume(returning: results)
                case .failure(let error):
                    print("reach failure condition")
                    continuation.resume(throwing: error)
                }
            }
            
            container.publicCloudDatabase.add(operation)
            
        }
        
    
    }
    
    func fetchAllBadgesByTypeAndUserB(userRecordName: String, badgeType: String) async throws -> [BuddyBadgeModel]?{
        print("Running fetchAllBadgesByType for user \(userRecordName) and type \(badgeType)...")
        
        let predicate = NSPredicate(format: "badgeType == %@ && userB == %@", badgeType, userRecordName)
        
        print("predicate: \(predicate)")
        
        
        let query = CKQuery(recordType: RecordNames.BuddyBadge.rawValue, predicate: predicate)
        
        
        return try await withCheckedThrowingContinuation { continuation in
            let operation = CKQueryOperation(query: query)
            
            var results: [BuddyBadgeModel] = []
            var result: BuddyBadgeModel?
            
            operation.recordMatchedBlock = { (returnedID, returnedResult) in
                switch returnedResult {
                case .success(let record):
                    print("record: \(record)")
                    result = BuddyBadgeModel(record)
                    print("result: \(String(describing: result))")
                    
                    guard let res = result else { return }
                    results.append(res)
                    
                    print("results: \(String(describing: results))")
                case .failure(let error):
                    print("Error recordMatchedBlock for returnID \(returnedID): \(error)")
                }
            }
            
            operation.queryResultBlock = { returnedResult in
                switch returnedResult {
                case .success:
                    print("reach success condition")
                    
                    print("last results: \(String(describing: results))")
                    continuation.resume(returning: results)
                case .failure(let error):
                    print("reach failure condition")
                    continuation.resume(throwing: error)
                }
            }
            
            container.publicCloudDatabase.add(operation)
            
        }
        
    
    }
    
    func fetchAllBadgesByType(userRecordName: String, badgeType: String) async throws -> [BuddyBadgeModel] {
        print("Running fetchAllBadgesByType...")
        
        let recordA = try await fetchAllBadgesByTypeAndUserA(userRecordName: userRecordName, badgeType: badgeType)
        let recordB = try await fetchAllBadgesByTypeAndUserB(userRecordName: userRecordName, badgeType: badgeType)
        
        print("recordA: \(String(describing: recordA))")
        print("recordB: \(String(describing: recordB))")
        
        guard let recordA = recordA else { return [] }
        guard let recordB = recordB else { return [] }
        
        print("newRecordA: \(recordA)")
        print("newRecordB: \(recordB)")
        
        var combined: [BuddyBadgeModel] = []
        combined.append(contentsOf: recordA)
        combined.append(contentsOf: recordB)
        
        return combined
    }
    
    func calculateSharedStreak(since buddyStartDate: Date) -> Int {
        //        TODO: maybe need another check could not less than user's and buddy's updatedStopDate
        
        //        user buddy start date until day now return days
        let dateNow = Date()
        
        let components = Calendar.current.dateComponents([.day], from: buddyStartDate, to: dateNow)
        
        return max(0, components.day ?? 0)
    }
    
    func calculateSharedMoneySaved(userRecord: QuiddyUserModel, buddyRecord: QuiddyUserModel) -> Int {
        //        calculate user money
        let userMoneySaved = BadgeViewModel().calculateMoneySaved(record: userRecord)
        print("userMoneySaved: \(userMoneySaved)")
        
        //        calculate buddy money
        let buddyMoneySaved = BadgeViewModel().calculateMoneySaved(record: buddyRecord)
        print("buddyMoneySaved: \(buddyMoneySaved)")
        
        let total = userMoneySaved + buddyMoneySaved
        print("total: \(total)")
        return total
    }
    
    func compareUser(userRecordName: String, buddyRecordName: String) -> (userA: String, userB: String) {
        print("Running compareUser...")
        print("userRecordName: \(userRecordName)")
        print("buddyRecordName: \(buddyRecordName)")
        
        let users: Set = [userRecordName, buddyRecordName]
        print("users: \(users)")
        
        
        let sortedUsers = users.sorted()
        print("sortedUsers: \(sortedUsers)")
        
        let userA = sortedUsers[0]
        let userB = sortedUsers[1]
        
        print("userA: \(userA)")
        print("userB: \(userB)")
        
        return (userA: userA, userB: userB)
    }
    
    
    func checkAchievedBadges(streak: Int, moneySaved: Int, userRecord: CKRecord.ID, buddyRecord: CKRecord.ID) async {
        do {
            print("Running checkAchievedBadges...")
            let streakThreshold: [Int] = [7, 14, 30, 60, 90, 120]
            let moneySavedThreshold: [Int] = [100000, 250000, 500000, 1000000, 2500000]
            
            let userRecordID = try await self.databasePublic.record(for: userRecord)
            let buddyRecordID = try await self.databasePublic.record(for: buddyRecord
            )
            
            //        fetch achieved badges from buddyBadge table
            let buddyBadges = try await fetchTogetherBadge(userRecordName: userRecord.recordName, buddyRecordName: buddyRecord.recordName)
            
            guard let buddyBadges = buddyBadges else { return }
            
            for threshold in streakThreshold {
                if streak >= threshold {
                    let exists = buddyBadges.contains { $0.badgeThreshold == threshold && $0.badgeType == BadgeType.streak.rawValue}
                    
                    if exists {
                        continue
                    } else {
                        print("save streak badge for threshold: \(threshold)")
                        _ = await addBuddyBadge(userRecord: userRecordID.recordID, buddyRecord: buddyRecordID.recordID, badgeType: BadgeType.streak.rawValue, badgeThreshold: threshold)
                    }
                } else {
                    break
                }
            }
            
            for threshold in moneySavedThreshold {
                if moneySaved >= threshold {
                    let exists = buddyBadges.contains { $0.badgeThreshold == threshold && $0.badgeType == BadgeType.moneySaved.rawValue}
                    
                    if exists {
                        continue
                    } else {
                        print("save money saved badge for threshold: \(threshold)")
                        _ = await addBuddyBadge(userRecord: userRecordID.recordID, buddyRecord: buddyRecordID.recordID, badgeType: BadgeType.moneySaved.rawValue, badgeThreshold: threshold)
                    }
                } else {
                    break
                }
            }
            
        } catch {
            print("error checkAchievedBadges: \(error.localizedDescription)")
        }
        
        
    }
    
    
    
}

enum BadgeType: String {
    case streak
    case moneySaved
}

