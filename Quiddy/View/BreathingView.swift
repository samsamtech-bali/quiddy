//
//  BreathingView.swift
//  Quiddy
//
//  Created by Vena Feranica on 13/11/25.
//

import SwiftUI

enum BreathingState {
    case breatheIn
    case hold
    case breatheOut
    
    var displayTitle: String {
        switch self {
        case .breatheIn: return "Breathe In"
        case .hold: return "Hold"
        case .breatheOut: return "Breathe Out"
        }
    }
    
    var duration: TimeInterval {
        switch self {
        case .breatheIn: return 4.0
        case .hold: return 7.0
        case .breatheOut: return 8.0
        }
    }
}

enum CirclePosition {
    static let circleA = CGPoint(x: 60, y: 250)
    static let circleB = CGPoint(x: 350, y: 520)
    static let center = CGPoint(x: 197, y: 390)
}


struct BreathingView: View {
    @State var count: Int = 4
    @State var state: BreathingState = .breatheIn
    @State var isAnimating: Bool = false
    @State var position1: CGPoint = CirclePosition.circleA
    @State var position2: CGPoint = CirclePosition.circleB
    @State var breathingTask: Task<Void, Never>? = nil
    
    var body: some View {
        ZStack {
            Color(red: 0x12/255, green: 0x14/255, blue: 0x18/255)
                .ignoresSafeArea()
            ZStack {
                LinearGradient(
                    colors: [Color(hex: "BE9FFF"), Color(hex: "88C0FB")],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .mask {
                    Canvas { context, size in
                        context.addFilter(.alphaThreshold(min: 0.9))
                        context.addFilter(.blur(radius: 15))
                        context.drawLayer { ctx in
                            let circle0 = ctx.resolveSymbol(id: 0)!
                            let circle1 = ctx.resolveSymbol(id: 1)!
                            
                            ctx.draw(circle0, at: CirclePosition.center)
                            ctx.draw(circle1, at: CirclePosition.center)
                        }
                        
                    } symbols: {
                        Circle()
                            .fill(.black)
                            .frame(width: 400, height: 250)
                            .position(position1)
                            .tag(0)
                        
                        Circle()
                            .fill(.black)
                            .frame(width: 300, height: 180)
                            .position(position2)
                            .tag(1)
                    }
                }
            }
            VStack {
                if isAnimating == true {
                    Text(state.displayTitle)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    Text("\(count)s")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    Spacer()
                } else {
                    VStack {
                        Text("Start a breathing exercise")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        Text("Press start whenever you're ready")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                    }
                 
                    .multilineTextAlignment(.center)
                    
                    Spacer()
                }
                
                Button(action: {
                    if isAnimating == false {
                        state = .breatheIn
                        position1 = CirclePosition.circleA
                        position2 = CirclePosition.circleB
                        count = Int(state.duration)
                        isAnimating = true
                        breathingTask = startCycle()
                    } else {
                        breathingTask?.cancel()
                        breathingTask = nil
                        isAnimating = false
                        count = Int(state.duration)
                        withAnimation(.linear(duration: 1)) {
                            position1 = CirclePosition.circleA
                            position2 = CirclePosition.circleB
                        }
                        
                    }
                }) {
                    Text(isAnimating ? "Stop" : "Start")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(70)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 1)
                        )
                }
                
                
                Spacer()
            }
            .padding(100)
            
        }
        .onReceive(Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()) { _ in
            guard isAnimating else { return }
            count -= 1
            if count == 0 {
                count = Int(state.duration)
                
            }
            
            
        }
        
    }
    func transition() {
        switch state {
        case .breatheIn:
            state = .hold
        case .hold:
            state = .breatheOut
        case .breatheOut:
            state = .breatheIn
        }
        count = Int(state.duration)
    }
    
    func updatePosition() {
        switch state {
        case .breatheIn:
            position1 = CirclePosition.center
            position2 = CirclePosition.center
        case .hold:
            position1 = CirclePosition.center
            position2 = CirclePosition.center
        case .breatheOut:
            position1 = CirclePosition.circleA
            position2 = CirclePosition.circleB
        }
    }
    
    func startCycle() -> Task<Void, Never> {
        return Task {
            while isAnimating {
                print("Animation cycle running, state: \(state)")
                withAnimation(.linear(duration: state.duration)) {
                    updatePosition()
                }
                try? await Task.sleep(for: .seconds(state.duration))
                guard isAnimating else {
                    break
                }
                print("About to transition from \(state), count is currently: \(count)")
                transition()
            }
        }
    }
}

#Preview {
    BreathingView()
}
