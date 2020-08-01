//
//  MacrosMealHeader.swift
//  Nutrivurv
//
//  Created by Dillon on 7/31/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import SwiftUI

struct MacrosMealHeader: View {
    @State var blueFill: Bool = false
    @State var greenFill: Bool = false
    @State var orangeFill: Bool = false
    @State var redFill: Bool = false
    
    private var bgHeight: CGFloat = 34
    
    private var blueColor = Color(UIColor(named: "nutrivurv-blue-new")!)
    private var greenColor = Color(UIColor(named: "nutrivurv-green-new")!)
    private var orangeColor = Color(UIColor(named: "nutrivurv-orange-new")!)
    private var redColor = Color(UIColor(named: "nutrivurv-red-new")!)
    
    private var bgColor = Color(UIColor(named: "food-log-label-bg")!)
    private var bgShadowColor = Color(UIColor(named: "daily-vibe-shadow")!)
    private var labelColor = Color(UIColor(named: "food-log-label-text")!)
    
    var body: some View {
        return ZStack {
            RoundedRectangle(cornerRadius: bgHeight / 2, style: .continuous)
                .foregroundColor(bgColor)
                .shadow(color: bgShadowColor, radius: 8, x: 0, y: 0)
            
            HStack {
                Spacer(minLength: 22)
                HStack {
                    Circle()
                        .overlay(
                            Circle()
                                .stroke(blueColor, style: StrokeStyle(lineWidth: 4.0, lineCap: .round, lineJoin: .round)))
                        .foregroundColor(blueFill ? blueColor : .clear)
                        .frame(width: 16, height: 16)
                        .onTapGesture {
                            self.blueFill.toggle()
                    }
                    
                    
                    
                    Circle()
                        .overlay(
                            Circle()
                                .stroke(greenColor, style: StrokeStyle(lineWidth: 4.0, lineCap: .round, lineJoin: .round)))
                        .foregroundColor(greenFill ? greenColor : .clear)
                        .frame(width: 16, height: 16)
                        .onTapGesture {
                            self.greenFill.toggle()
                    }
                    
                    
                    
                    Circle()
                        .overlay(
                            Circle()
                                .stroke(orangeColor, style: StrokeStyle(lineWidth: 4.0, lineCap: .round, lineJoin: .round)))
                        .foregroundColor(orangeFill ? orangeColor : .clear)
                        .frame(width: 16, height: 16)
                        .onTapGesture {
                            self.orangeFill.toggle()
                    }
                    
                    
                    
                    Circle()
                        .overlay(
                            Circle()
                                .stroke(redColor, style: StrokeStyle(lineWidth: 4.0, lineCap: .round, lineJoin: .round)))
                        .foregroundColor(redFill ? redColor : .clear)
                        .frame(width: 16, height: 16)
                        .onTapGesture {
                            self.redFill.toggle()
                    }
                }.frame(width: 88)
                
                HStack {
                    Text("34 Cals")
                        .foregroundColor(labelColor)
                        .font(Font.custom("Gaoel", size: 10))
                }.frame(width: 63, alignment: .center)
                
                Spacer(minLength: 18)
                
            }
            .frame(width: 156, height: 16, alignment: .center)
            
        }.frame(width: 184, height: bgHeight)
        
    }
}

struct MacrosMealHeader_Previews: PreviewProvider {
    static var previews: some View {
        MacrosMealHeader()
    }
}
