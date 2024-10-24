//
//  GradientView.swift
//  WISERVtest
//
//  Created by Vladislav Avrutin on 24.10.2024.
//

import SwiftUI

struct GradientView: View {
    var colors: [Color]
    var startPoint: UnitPoint
    var endPoint: UnitPoint
    var rotation: Angle
    var width: CGFloat
    var height: CGFloat
    var blurRadius: CGFloat
    var xOffset: CGFloat
    var yOffset: CGFloat
    
    var body: some View {
        HStack {
            Spacer()
            LinearGradient(colors: colors,
                           startPoint: startPoint,
                           endPoint: endPoint)
            .frame(width: width, height: height)
            .rotationEffect(rotation)
            .blur(radius: blurRadius)
            .offset(x: xOffset, y: yOffset)
        }
    }
}
