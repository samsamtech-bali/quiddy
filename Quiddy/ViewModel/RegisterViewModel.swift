//
//  RegisterViewModel.swift
//  Quiddy
//
//  Created by stephan on 05/11/25.
//

import Foundation
import CloudKit

class RegisterViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var quiddyCode: String = ""
    @Published var stopDate: Date = Date.now
    @Published var updatedStopDate: Date = Date.now
    @Published var cigPerDay: Int = 0
    @Published var pricePerCig: Double = 0
    
    let container: CKContainer
    let databasePublic: CKDatabase
    
    init() {
        self.container = CKContainer(identifier: "iCloud.com.stephan.iCloud")
        self.databasePublic = container.publicCloudDatabase
    }
    
    func createNewUser(
        username: String,
        quiddyCode: String,
        stopDate: Date,
        updatedStopDate: Date,
        cigPerDay: Int,
        pricePerCig: Double
    ) async -> QuiddyUserModel? {
        do {
            print("Running createNewUser function...")
            
            let currentRecord = try await fetchByRecordName()
            
            print("current record: \(String(describing: currentRecord))")
            
            if currentRecord != nil {
                print("user already has data...")
                return nil
            } else {
                let emptyString: String = "-"
                let emptyStringJSON: String = "[]"
                let emptyDateArr: [Date] = []
                let emptyDate: Date = Date()
                print("emptyDateArr: \(emptyDateArr)")
                
                let quiddyUser = QuiddyUserModel(
                    username: username,
                    quiddyCode: quiddyCode,
                    stopDate: stopDate,
                    updatedStopDate: updatedStopDate,
                    cigPerDay: cigPerDay,
                    pricePerCig: pricePerCig,
                    dateCravingPressed: emptyDateArr,
                    badges: emptyStringJSON,
                    relapseDate: emptyDateArr,
                    buddyCode: emptyString,
                    buddyStartDate: emptyDate
                )
                let quiddyUserRecord = quiddyUser.getRecord()
                let record = try await databasePublic.save(quiddyUserRecord)
                let newQuiddyUser = QuiddyUserModel(record)
                print("quiddy user id: \(String(describing: record.recordID.recordName))")
                return newQuiddyUser
            }
        } catch {
            print("Error creating new user: \(error)")
            return nil
        }
    }
    
    func fetchCurrentUserRecordName() async -> String {
        do {
            print("Running fetchCurrentUserRecordName...")
            
            let userRecordName = try await container.userRecordID()
            print("user record id should be: \(userRecordName)")
            print("user record name should be: \(userRecordName.recordName)")
            return userRecordName.recordName
        } catch {
            print("Error fetching user data: \(error)")
            return "No data"
        }
    }
    
    func fetchByRecordName() async throws -> QuiddyUserModel? {
        print("Running fetchByRecordName...")
        let recordName = await fetchCurrentUserRecordName()
        let recordID = CKRecord.ID(recordName: recordName)
        print("recordID: \(recordID)")
        
        let predicate = NSPredicate(format: "creatorUserRecordID == %@", recordID)
        
        let query = CKQuery(recordType: "QuiddyUsers", predicate: predicate)
        
        return try await withCheckedThrowingContinuation { continuation in
            let operation = CKQueryOperation(query: query)
            operation.resultsLimit = 1
            
            var result: QuiddyUserModel?
            
            operation.recordMatchedBlock = { (returnedID, returnedResult) in
                switch returnedResult {
                case .success(let record):
                    print("record: \(record)")
                    result = QuiddyUserModel(record)
                    print("success recordMatchedBlock: \(String(describing: result))")
                    print("cigPerDay: \(String(describing: result?.cigPerDay))")
                case .failure(let error):
                    print("Error recordMatchedBlock for returnID \(returnedID): \(error)")
                }
                
            }
            
            operation.queryResultBlock = { returnedResult in
                switch returnedResult {
                case .success:
                    print("reach success query")
                    continuation.resume(returning: result)
                case .failure(let error):
                    print("reach failure query")
                    continuation.resume(throwing: error)
                }
            }
            
            container.publicCloudDatabase.add(operation)
        }
    }
    
    func fetchByUniqueCode(_ code: String) async throws -> QuiddyUserModel? {
        print("Running fetchByUniqueCode with arg \(code)...")
        let predicate = NSPredicate(format: "quiddyCode == %@", code)
//        print("record type: \(RecordNames.QuiddyUsers.rawValue)")
        let query = CKQuery(recordType: "QuiddyUsers", predicate: predicate)
        
        return try await withCheckedThrowingContinuation { continuation in
            print("running continuation...")
            let operation = CKQueryOperation(query: query)
            operation.resultsLimit = 1
            
            var result: QuiddyUserModel?
            
            operation.recordMatchedBlock = { (returnedID, returnedResult) in
                switch returnedResult {
                case .success(let record):
                    result = QuiddyUserModel(record)
                    print("result: \(String(describing: result))")
                case .failure(let error):
                    print("error recordMatchedBlock isCodeExisted: \(error)")
                }
            }
            
            operation.queryResultBlock = { returnedResult in
                switch returnedResult {
                case .success:
                    continuation.resume(returning: result)
                case .failure(let error):
                    print("error fetching by quiddy code: \(error)")
                    continuation.resume(throwing: error)
                }}
            
            container.publicCloudDatabase.add(operation)
        }
    }
    
    func generateRandomUniqueString() -> String {
        let result = UUID().uuidString.prefix(6).description
        print("Random String V2: \(result)")
        return result
    }
    
    func isCodeExisted(code: String) async -> Bool {
        do {
            print("Running isCodeExisted with code \(code)...")
            let data = try await fetchByUniqueCode(code)
            print("isCodeExisted data: \(String(describing: data))")
            
            if data != nil {
                print("return true")
                return true
            } else {
                print("return false")
                return false
            }
        } catch {
            print("error isCodeExisted: \(error.localizedDescription)")
            print("return true cause of error")
            return true
        }
    }
    
    func calculatePricePerCig(price: Int, days: Int) {
        let newPrice = Double(price/days)
        print("price per cigeratte: \(newPrice)")
        
        self.pricePerCig = newPrice
    }
    
    
    
    
    //    func generateUserCode() -> String {
    //        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    //        let result = String((0...6).map{_ in letters.randomElement()!})
    //        print("Random String: \(result)")
    //        return result
    //    }
}
