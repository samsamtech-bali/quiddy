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
    
    func generateUserCode() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let result = String((0...6).map{_ in letters.randomElement()!})
        print("Random String: \(result)")
        return result
    }
    
    func generateRandomUniqueString() -> String {
        let result = UUID().uuidString.prefix(6).description
        print("Random String V2: \(result)")
        return result
    }
    
    func isCodeExisted() {
//        get record based on quiddyCode
//        let query = CKQuery()
//        query.recordType = RecordNames.QuiddyUsers
    }
    
    func calculatePricePerCig(price: Int, days: Int) {
        let newPrice = Double(price/days)
        print("price per cigeratte: \(newPrice)")
        
        self.pricePerCig = newPrice
    }

}
