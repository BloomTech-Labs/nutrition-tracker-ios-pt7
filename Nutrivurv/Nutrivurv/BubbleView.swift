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
    
    var body: some View {
        Image("bubble")
            .resizable()
            .frame(width: 66, height: 60)
    }
}

struct BubbleView_Previews: PreviewProvider {
    static var previews: some View {
        BubbleView(currentProgress: .constant(false))
    }
}
