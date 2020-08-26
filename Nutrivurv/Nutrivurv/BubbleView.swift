//
//  BubbleView.swift
//  Nutrivurv
//
//  Created by Dillon on 8/7/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import SwiftUI

struct BubbleView: View {
    @Binding var currentProgress: Bool
    @Binding var showNutrients: Bool
    @Binding var newMealEntry: Bool
    
    var index: Double // starting at one, used as a multiplier for the animation delay
    var percentDifference: Double
    
    var body: some View {
        ZStack {
            Image("bubble")
                .renderingMode(.template)
                .resizable()
                .foregroundColor(Color(UIColor(named: "bubble-bg-color")!))
                .shadow(color: Color(UIColor(named: "daily-vibe-shadow")!), radius: 1, x: 0, y: 0.5)
            
            HStack(spacing: 0) {
                if newMealEntry {
                    Text("+")
                    .font(Font.custom("QuattrocentoSans-Bold", size: 14))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                }
                
                Text(Int(percentDifference) == 0 ? "0" : "\(String(format: "%.0f", percentDifference))")
                    .font(Font.custom("QuattrocentoSans-Bold", size: 18))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                
                Text("%")
                    .font(Font.custom("QuattrocentoSans-Bold", size: 11))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(width: 44, height: 30, alignment: .top)
            
        }
        .frame(width: 70, height: 60)
        .scaleEffect(currentProgress ? 0.00000001 : 1.0)
        .animation(showNutrients ? .easeInOut :
            (Animation.interactiveSpring(response: currentProgress ? 0.1 : 0.4, dampingFraction: currentProgress ? 1.0 : 0.6, blendDuration: 0.2)
                .delay(currentProgress ? 0 : (0.2 * (index/3.5)))
                .speed(currentProgress ? 0.25 : 1.0)))
    }
}

struct BubbleView_Previews: PreviewProvider {
    static var previews: some View {
        BubbleView(currentProgress: .constant(false), showNutrients: .constant(false), newMealEntry: .constant(true), index: 1, percentDifference: 6)
    }
}
