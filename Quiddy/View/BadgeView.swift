//
//  BadgeView.swift
//  Quiddy
//
//  Created by stephan on 06/11/25.
//

import SwiftUI

struct BadgeView: View {
    @State private var badgeTitle: String = ""
    @State private var badgeDescription: String = ""
    @State var badgeData: BadgeModel?
    @State var recordName: String?
    
    @StateObject var badgeViewModel = BadgeViewModel()
    
    
    
    var body: some View {
        VStack {
            Text("Create a new badge")
            Form {
                
                TextField(
                    "Badge Title",
                    text: $badgeTitle
                )
                .autocorrectionDisabled(true)
                
                TextField(
                    "Badge Description",
                    text: $badgeDescription
                )
                .autocorrectionDisabled(true)
                
                Button("Submit new badge", action: {
                    Task {
                        let result = await badgeViewModel.createBadge(badgeTitle, badgeDescription)
                        print("Compeleted...\n result = \(String(describing: result))")
                    }
                })
                
            }
            
            Text("Badge Title: \(badgeData?.badgeTitle ?? "data")")
            Text("Badge Description: \(badgeData?.badgeDescription ?? "data")")
            
            Text("User: \(recordName ?? "No data")")
            
//            Text("update a badge")
//            Form {
//                
//                TextField(
//                    "Badge Title",
//                    text: $badgeTitle
//                )
//                .autocorrectionDisabled(true)
//                
//                
//                TextField(
//                    "Badge Description",
//                    text: $badgeDescription
//                )
//                .autocorrectionDisabled(true)
//                
//                Button("Submit new badge", action: {
//                    Task {
//                        let result = await badgeViewModel.createBadge(badgeTitle, badgeDescription)
//                        print("Compeleted...\n result = \(String(describing: result))")
//                    }
//                })
//                
//            }
            
        }
        .onAppear {
            Task {
                badgeData = await badgeViewModel.getBadge("966E5937-FFFC-4079-8C48-4B45888985F6") ?? BadgeModel(badgeTitle: "No data", badgeDescription: "No data")
                
                recordName = await badgeViewModel.fetchCurrentUserRecordName()
            }
        }
        
    }
}

#Preview {
    BadgeView(badgeData: BadgeModel(badgeTitle: "500k", badgeDescription: "This is an example description"))
}
