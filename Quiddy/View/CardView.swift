//
//  CardView.swift
//  Quiddy
//
//  Created by Claude on 10/11/25.
//

import SwiftUI

struct CardView: View {
    let username: String
    let daysSmokesFree: Int
    let moneySaved: Int
    let onRefresh: () -> Void
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.7, green: 0.6, blue: 0.9),
                    Color(red: 0.5, green: 0.3, blue: 0.8)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .cornerRadius(24)
            
            VStack(spacing: 12) {
                HStack {
                    Text(username)
                        .font(.title)
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.9))
                    
                    Spacer()
                    
                    Button(action: onRefresh) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.red)
                            .frame(width: 40, height: 40)
                            .background(
                                Color.white.opacity(0.3)
                            )
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 15)
                
                HStack(spacing: 50) {
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 6) {
                            Image(systemName: "bag")
                                .font(.system(size: 20))
                                .foregroundColor(.white.opacity(0.7))
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Rp\(moneySaved.formatted())")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                
                                Text("money saved")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 6) {
                            Image(systemName: "clock")
                                .font(.system(size: 20))
                                .foregroundColor(.white.opacity(0.7))
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("\(daysSmokesFree) days")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                
                                Text("smoke-free")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                    }
                    
                    
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 15)
            }
        }
        .frame(height: 150)
    }
}

#Preview {
    CardView(
        username: "Jeremy",
        daysSmokesFree: 25,
        moneySaved: 4000000,
        onRefresh: {}
    )
    .padding()
}
