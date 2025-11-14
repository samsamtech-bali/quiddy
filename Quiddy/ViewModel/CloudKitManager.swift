////
////  CloudKitManager.swift
////  Quiddy
////
////  Created by stephan on 06/11/25.
////
//
//import Foundation
//import CloudKit
//
//class CloudKitManager: ObservableObject {
//    
//    @Published var permissionStatus: Bool = false
//    @Published var isSignedInToiCloud: Bool = false
//    @Published var error: String = ""
//    @Published var username: String = ""
//    
//    init() {
//        getiCloudStatus()
//        requestPermission()
//        fetchiCloudUserRecordID()
//    }
//    
//    private func getiCloudStatus() {
//        CKContainer.default().accountStatus { [weak self] returnedStatus, returnedError in
//            switch returnedStatus {
//            case .available:
//                DispatchQueue.main.async {
//                    self?.isSignedInToiCloud = true
//                }
//                
//            case .couldNotDetermine:
//                DispatchQueue.main.async {
//                    self?.error = CloudKitError.iCloudAccountNotDetermined.localizedDescription
//                }
//            case .noAccount:
//                DispatchQueue.main.async {
//                    self?.error = CloudKitError.iCloudAccountNotFound.localizedDescription
//                }
//            case .restricted:
//                DispatchQueue.main.async {
//                    self?.error = CloudKitError.iCloudAccountRestricted.localizedDescription
//                }
//            default:
//                DispatchQueue.main.async {
//                    self?.error = CloudKitError.iCloudAccountUnknown.localizedDescription
//                }
//            }
//        }
//    }
//    
//    func requestPermission() {
//        //        CKContainer.default().requestApplicationPermission([.userDiscoverability]) { returnedStatus, returnedError in
//        //            DispatchQueue.main.async {
//        //                if returnedStatus == .granted {
//        //                    self.permissionStatus = true
//        //                }
//        //            }
//        //        }
//        //
//        //        CKContainer.default().perm
//        
//        //        let permissions =  CKContainer.ApplicationPermissions()
//        //        if let share = CKShare.Participant.perm
//        //
//        
//    }
//    
//    func fetchiCloudUserRecordID() {
//        CKContainer.default().fetchUserRecordID { [weak self] returnedID, returnedError in
//            if let id = returnedID {
//                self?.discoveriCloudUser(id: id)
//            }}
//    }
//    
//    func discoveriCloudUser(id: CKRecord.ID) {
//        //        CKContainer.default().discoverUserIdentity(withUserRecordID: id) { [weak self] returnedIdentity, returnedError in
//        //            DispatchQueue.main.async {
//        //                if let name = returnedIdentity?.nameComponents?.givenName {
//        //                    self?.username = name
//        //                }
//        //            }}
//        
//        
//        
//        // (CKRecord.ID?, (any Error)?)
//        // (Result<[CKRecord.ID : Result<CKRecord, any Error>], any Error>)
//        
//        
//        //        CKContainer.default().publicCloudDatabase.fetch(withRecordIDs: [id], desiredKeys: nil) { result in
//        //            switch result {
//        //            case .success(let recordResults):
//        //                for (recordID, individualRecordResult) in recordResults {
//        //                    switch individualRecordResult {
//        //                    case .success(let record):
//        ////                        self.username = record["name"] as? String ?? "no name"
//        //                        let lookUpInfo = CKUserIdentity.LookupInfo(userRecordID: recordID)
//        //                        self.username = lookUpInfo.
//        //                    case .failure(let individualError):
//        //                        print("Failed to fetch record with id: \(recordID.recordName): \(individualError.localizedDescription)")
//        //                    }
//        //                }
//        //            case .failure(let overallError):
//        //                print("Overall CloudKit operation failed: \(overallError.localizedDescription)")
//        //            }
//        //        }
//        
//        CKContainer.default().fetchShareParticipant(withUserRecordID: id) { participant, error in
//            guard let participant = participant, error == nil else {
//                print("Error fetching share participant: \(error?.localizedDescription ?? "Unknown error")")
//                return
//            }
//            
//            if let name = participant.userIdentity.nameComponents?.givenName {
//                print("name: \(name)")
//                self.username = name
//            }
//            
//        }
//        
//        
//        //            guard let userRecord = returnedIdentity else {
//        //                print("User record not found")
//        //                return
//        //            }
//        
//    }
//    
//    enum CloudKitError: LocalizedError {
//        case iCloudAccountNotFound
//        case iCloudAccountNotDetermined
//        case iCloudAccountRestricted
//        case iCloudAccountUnknown
//    }
//    
//}
