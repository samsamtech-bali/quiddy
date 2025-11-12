//
//  ProgressBar.swift
//  Quiddy
//
//  Created by Kelvin on 11/11/25.
//


import SwiftUI

struct ProgressBar: View {
    let progress: Int
    let total: Int
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color(hex: "#3A3A3C"))
                    .frame(height: 4)
                    .cornerRadius(2)
                
                Rectangle()
                    .fill(Color.white)
                    .frame(width: geometry.size.width * CGFloat(progress) / CGFloat(total), height: 4)
                    .cornerRadius(2)
            }
        }
        .frame(height: 4)
    }
}