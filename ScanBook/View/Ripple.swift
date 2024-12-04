//
//  Ripple.swift
//  ScanBook
//
//  Created by 磯部馨仁 on 2024/05/04.
//

import SwiftUI

struct Ripple: ViewModifier {
    // MARK: Lifecycle
    
    init(rippleColor: Color) {
        color = rippleColor
    }
    
    // MARK: Internal
    
    let color: Color
    
    let timeInterval: TimeInterval = 0.2
    
    // MARK: Private
    
    @State private var scale: CGFloat = 0.5
    
    @State private var animationPosition: CGFloat = 0.0
    @State private var x: CGFloat = 0.0
    @State private var y: CGFloat = 0.0
    
    @State private var opacityFraction: CGFloat = 0.0
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .foregroundColor(.gray.opacity(0.05))
                Circle()
                    .foregroundColor(color)
                    .opacity(0.2 * opacityFraction)
                    .scaleEffect(scale)
                    .offset(x: x, y: y)
                content
            }
            .gesture(
                DragGesture(minimumDistance: 0.0)
                    .onChanged { gesture in
                        let location = gesture.startLocation
                        
                        x = location.x - geometry.size.width / 2
                        y = location.y - geometry.size.height / 2
                        
                        opacityFraction = 1.0
                        
                        withAnimation(.linear(duration: timeInterval / 2.0)) {
                            scale = 3.0 *
                            (
                                max(geometry.size.height, geometry.size.width) /
                                min(geometry.size.height, geometry.size.width)
                            )
                        }
                    }
                    .onEnded { _ in
                        withAnimation(.linear(duration: timeInterval / 2.0)) {
                            opacityFraction = 0.0
                            scale = 1.0
                        }
                    }
            )
            .clipped()
        }
    }
}
