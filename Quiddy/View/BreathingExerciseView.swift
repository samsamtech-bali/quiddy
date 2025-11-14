//
//  BreathingExerciseView.swift
//  Quiddy
//
//  Created by Jeremy Lumban Toruan on 10/11/25.
//

import SwiftUI

struct BreathingExerciseView: View {
    var body: some View {
        VStack(spacing: 30) {
            Text("Breathing Exercise")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Coming Soon")
                .font(.title2)
                .foregroundColor(.white.opacity(0.8))
            
            Spacer()
        }
        .padding()
//        .background(Color(red: 0x12/255, green: 0x14/255, blue: 0x18/255))
//        .ignoresSafeArea()
    }
}

#Preview {
    BreathingExerciseView()
}
