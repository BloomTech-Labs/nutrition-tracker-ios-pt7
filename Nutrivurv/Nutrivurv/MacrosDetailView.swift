//
//  MacrosDetailView.swift
//  Nutrivurv
//
//  Created by Dillon on 8/7/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import SwiftUI

struct MacrosDetailView: View {
    var count: CGFloat
    var progressPercent: CGFloat
    var macroDescription: String
    
    var uiColor: UIColor
    var width: CGFloat = 56
    var height: CGFloat = 56
    
    var ringAnimation = Animation.easeInOut(duration: 0.4)
    var fontColor = UIColor(displayP3Red: 68/255, green: 71/255, blue: 78/255, alpha: 1)
    
    var body: some View {
        let multiplier = width / 100
        var progress = 1 - (progressPercent / 100)
        
        // As percentages approach 100 the rings appear to be completed before they actually are - due to the rounded line caps
        // If over 75 percent, each percentage mark of a ring will be represented as a fraction of percentage less than the actual value
        if progressPercent > 75 {
            progress = 1 - (0.75 + ((0.92 * (progressPercent - 75)) / 100))
        }
        
        if progressPercent >= 100 {
            // 0 Represents the entire circle being filled
            progress = 0
        }
        
        return VStack(spacing: 14) {
            ZStack {
                Circle()
                    .stroke(Color(uiColor).opacity(0.25), style: StrokeStyle(lineWidth: 13.5)).grayscale(0.4).brightness(0.09)
                    .frame(width: width - 0.25, height: height - 0.25)
                    .animation(ringAnimation)
                
                Circle()
                    .trim(from: progress, to: 1)
                    .stroke(
                        LinearGradient(gradient: Gradient(colors: [Color(uiColor).opacity(0.45), Color(uiColor)]), startPoint: .topTrailing, endPoint: .bottomLeading),
                        style: StrokeStyle(lineWidth: 14, lineCap: .round, lineJoin: .round))
                    .rotationEffect(.degrees(90))
                    .rotation3DEffect(Angle(degrees: 180), axis: (x: 1, y: 0, z: 0))
                    .frame(width: width, height: height)
                    .shadow(color: Color(uiColor).opacity(0.3), radius: 5 * multiplier, x: 2 * multiplier, y: 3 * multiplier)
                    .animation(ringAnimation)
                
                HStack(spacing: 0) {
                    Text(String(format: "%.0f", progressPercent))
                        .font(Font.custom("Catamaran-Bold", size: 18))
                        .foregroundColor(Color(fontColor))
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)

                    Text("%")
                        .font(Font.custom("Catamaran-Bold", size: 10))
                        .foregroundColor(Color(fontColor))
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
                .animation(ringAnimation)
                .frame(width: 38, height: 30, alignment: .center)
            }
            
            Text("\(String(format: "%.0f", count))\(macroDescription)")
                .font(Font.custom("QuattrocentoSans-Italic", size: 15))
                .animation(ringAnimation)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
    }
}

struct FoodDetailMacros_Previews: PreviewProvider {
    static var previews: some View {
        MacrosDetailView(count: 65, progressPercent: 24, macroDescription: "cals", uiColor: UIColor(named: "nutrivurv-blue-new")!)
    }
}
