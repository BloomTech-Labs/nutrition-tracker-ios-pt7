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
    
    var index: Double // starting at one, used as a multiplier for the animation delay
    var percentDifference: Int
    
    var body: some View {
        ZStack {
            Image("bubble")
                .resizable()
            
            HStack(spacing: 0) {
                Text("+")
                    .font(Font.custom("QuattrocentoSans-Bold", size: 14))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                
                Text("\(percentDifference)")
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
        .frame(width: 66, height: 60)
        .scaleEffect(currentProgress ? 0.00000001 : 1.0)
        .animation(Animation.interactiveSpring(response: currentProgress ? 0.1 : 0.4, dampingFraction: currentProgress ? 1.0 : 0.6, blendDuration: 0.2)
        .delay(currentProgress ? 0 : (0.2 * (index/3.5)))
        .speed(currentProgress ? 0.25 : 1.0))
        
    }
}

struct BubbleView_Previews: PreviewProvider {
    static var previews: some View {
        BubbleView(currentProgress: .constant(false), index: 1, percentDifference: 6)
    }
}
