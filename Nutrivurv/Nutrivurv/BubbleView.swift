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
    
    var body: some View {
        Image("bubble")
            .resizable()
            .frame(width: 66, height: 60)
            .scaleEffect(currentProgress ? 0.00000001 : 1.0)
            .animation(Animation.interactiveSpring(response: currentProgress ? 0.1 : 0.4, dampingFraction: currentProgress ? 1.0 : 0.6, blendDuration: 0.2)
                .delay(currentProgress ? 0 : (0.1 * (index/1.5)))
                .speed(currentProgress ? 0.25 : 1.0))
    }
}

struct BubbleView_Previews: PreviewProvider {
    static var previews: some View {
        BubbleView(currentProgress: .constant(false), index: 1)
    }
}
