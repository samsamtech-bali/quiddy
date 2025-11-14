//
//  PageIndicatorStatic.swift
//  Quiddy
//
//  Created by Kelvin on 13/11/25.
//


import SwiftUI

struct PageIndicatorStatic: View {
    let currentPage: Int
    let totalPages: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalPages, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? Color.white : Color(hex: "#3A3A3C"))
                    .frame(width: 8, height: 8)
            }
        }
    }
}

#Preview {
    PageIndicatorStatic(currentPage: 1, totalPages: 3)
        .background(Color.black)
}