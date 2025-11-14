//
//  DrawingCanvasView.swift
//  Quiddy
//
//  Updated with Haptics by Kelvin on 14/11/25.
//

import SwiftUI

struct DrawingCanvasView: View {
    @Binding var hasDrawn: Bool
    @State private var lines: [Line] = []
    @State private var currentLine: Line = Line(points: [])
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Canvas { context, size in
                for line in lines {
                    var path = Path()
                    if let firstPoint = line.points.first {
                        path.move(to: firstPoint)
                        for point in line.points.dropFirst() {
                            path.addLine(to: point)
                        }
                    }
                    context.stroke(path, with: .color(.black), lineWidth: 3)
                }
                
                var path = Path()
                if let firstPoint = currentLine.points.first {
                    path.move(to: firstPoint)
                    for point in currentLine.points.dropFirst() {
                        path.addLine(to: point)
                    }
                }
                context.stroke(path, with: .color(.black), lineWidth: 3)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 300)
            .background(Color(hex: "#E5E5E5"))
            .cornerRadius(16)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if currentLine.points.isEmpty {
                            // Haptic when starting to draw
                            HapticsManager.shared.drawingStart()
                        }
                        currentLine.points.append(value.location)
                        hasDrawn = true
                    }
                    .onEnded { _ in
                        lines.append(currentLine)
                        currentLine = Line(points: [])
                        
                        // Check if drawing looks complete (has multiple strokes)
                        if lines.count >= 2 && hasDrawn {
                            HapticsManager.shared.checkmarkCompleted()
                        }
                    }
            )
            
            Button(action: {
                HapticsManager.shared.lightImpact()
                lines.removeAll()
                currentLine = Line(points: [])
                hasDrawn = false
            }) {
                Text("Clear")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.black)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
            }
            .padding(12)
        }
    }
}

struct Line {
    var points: [CGPoint]
}
