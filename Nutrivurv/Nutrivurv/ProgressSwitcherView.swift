//
//  ProgressSwitcherView.swift
//  Nutrivurv
//
//  Created by Dillon on 8/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import SwiftUI

struct ProgressSwitcherView: View {
    @Binding var currentProgress: Bool
    
    var unselectedTextColor: Color = Color(UIColor(named: "unselected-progress-switcher")!)
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Today's Progress")
                .font(Font.custom("Catamaran-Bold", size: 14))
                .padding(EdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0))
                .frame(width: 177, height: 23)
            
            ZStack {
                RoundedRectangle(cornerRadius: 14.0, style: .continuous)
                    .foregroundColor(Color(UIColor(named: "progress-switcher-bg")!))
                    .frame(width: 193, height: 28)
                    .onTapGesture {
                        withAnimation(Animation.interactiveSpring(response: 0.24, dampingFraction: 0.74, blendDuration: 0.02)) {
                            self.currentProgress.toggle()
                        }
                }
                
                RoundedRectangle(cornerRadius: 14.0, style: .continuous)
                    .foregroundColor(Color(UIColor(named: "nutrivurv-blue-new")!))
                    .frame(width: 100, height: 28)
                    .offset(x: currentProgress ? -47 : 47, y: 0)
                
                HStack {
                    Text("currently")
                        .font(Font.custom("Gaoel", size: 10))
                        .foregroundColor(currentProgress ? .white : unselectedTextColor)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                        .frame(width: 64)
                    Spacer()
                    Text("after this")
                        .font(Font.custom("Gaoel", size: 10))
                        .foregroundColor(currentProgress ? unselectedTextColor : .white)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                        .frame(width: 73)
                }
                .padding(EdgeInsets(top: 0, leading: 18, bottom: 0, trailing: 12))
                
            }
            .frame(width: 193, height: 28)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 14, trailing: 0))
            
        }.frame(width: 193, height: 60)
    }
}

struct ProgressSwitcherView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressSwitcherView(currentProgress: .constant(true))
    }
}
