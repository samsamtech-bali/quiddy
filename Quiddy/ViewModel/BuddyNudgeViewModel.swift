//
//  BuddyNudgeViewModel.swift
//  Quiddy
//
//  Created by stephan on 17/11/25.
//

import Foundation
import CloudKit

class BuddyNudgeViewModel: ObservableObject {
    let container: CKContainer
    let databasePublic: CKDatabase
    
    init() {
        self.container = CKContainer(identifier: "iCloud.com.stephan.iCloud")
        self.databasePublic = container.publicCloudDatabase
    }
    
    func randomMessage() -> String {
        let messages = [
            "lorem ipsum one one one",
            "lorem ipsum two two two",
            "lorem ipsum three three three",
            "lorem ipsum four four four",
            "lorem ipsum five five five",
        ]
        
        let randomizedMessage = messages.randomElement()
        print("message: \(String(describing: randomizedMessage))")
        
        guard let message = randomizedMessage else { return "HI!"}
        
        return message
    }
    
    func createNewNudge(sender: String, receiver: String, message: String) async -> BuddyNudgeModel? {
        do {
            print("Running createNewNudge function...")
            
            let buddyNudge = BuddyNudgeModel(sender: sender, receiver: receiver, message: message)
            let buddyNudgeRecord = buddyNudge.getRecord()
            let record = try await databasePublic.save(buddyNudgeRecord)
            
            let newBuddyNudge = BuddyNudgeModel(record)
            print("buddy nudge: \(String(describing: newBuddyNudge))")
            return newBuddyNudge
        } catch {
            print("Error createNewNudge: \(error.localizedDescription)")
            return nil
        }
    }
}
