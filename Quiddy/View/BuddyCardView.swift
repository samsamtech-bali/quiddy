//
//  BuddyCardView.swift
//  Quiddy
//
//  Created by Jeremy Lumban Toruan on 10/11/25.
//

import SwiftUI

struct BuddyCardView: View {
    let username: String
    let daysSmokesFree: Int
    let moneySaved: Int
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.4, green: 0.7, blue: 1.0),
                    Color(red: 0.2, green: 0.5, blue: 0.9)
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
    BuddyCardView(
        username: "Stephan",
        daysSmokesFree: 12,
        moneySaved: 40000
    )
    .padding()
}
