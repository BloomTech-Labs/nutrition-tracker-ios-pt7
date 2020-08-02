//
//  MacrosMealHeader.swift
//  Nutrivurv
//
//  Created by Dillon on 7/31/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import SwiftUI

struct MacrosMealHeader: View {
    @State var blueFill: Bool = true
    @State var greenFill: Bool = false
    @State var orangeFill: Bool = false
    @State var redFill: Bool = false
    
    private var bgHeight: CGFloat = 34
    
    private var blueColor = Color(UIColor(named: "nutrivurv-blue-new")!).opacity(0.7)
    private var greenColor = Color(UIColor(named: "nutrivurv-green-new")!).opacity(0.7)
    private var orangeColor = Color(UIColor(named: "nutrivurv-orange-new")!).opacity(0.7)
    private var redColor = Color(UIColor(named: "nutrivurv-red-new")!).opacity(0.7)
    
    private var bgColor = Color(UIColor(named: "food-log-label-bg")!)
    private var bgShadowColor = Color(UIColor(named: "daily-vibe-shadow")!)
    private var labelColor = Color(UIColor(named: "food-log-label-text")!)
    
    @State var caloriesCount = "269 cals"
    @State var carbsCount = "64 grams"
    @State var proteinCoiunt = "23 grams"
    @State var fatCount = "13 grams"
    
    @State var labelText = ""
    
    var body: some View {
        
        return ZStack {
            RoundedRectangle(cornerRadius: bgHeight / 2, style: .continuous)
                .foregroundColor(bgColor)
                .shadow(color: bgShadowColor.opacity(0.85), radius: 9.0, x: 0, y: 0)
            
            HStack {
                Spacer(minLength: 22)
                HStack {
                    
                    Circle()
                        .overlay(
                            Circle()
                                .stroke(blueFill ? .clear : blueColor, style: StrokeStyle(lineWidth: 3.5, lineCap: .round, lineJoin: .round)))
                        .foregroundColor(blueFill ? blueColor: .clear)
                        .frame(width: 16, height: 16)
                        .onTapGesture {
                            self.blueFill = true
                            self.labelText = self.caloriesCount
                            self.greenFill = false
                            self.orangeFill = false
                            self.redFill = false
                    }
                    .animation(.interactiveSpring())
                    
                    
                    
                    Circle()
                        .overlay(
                            Circle()
                                .stroke(greenFill ? .clear : greenColor, style: StrokeStyle(lineWidth: 3.5, lineCap: .round, lineJoin: .round)))
                        .foregroundColor(greenFill ? greenColor : .clear)
                        .frame(width: 16, height: 16)
                        .onTapGesture {
                            self.greenFill = true
                            self.labelText = self.carbsCount
                            self.blueFill = false
                            self.orangeFill = false
                            self.redFill = false
                    }
                        .animation(.interactiveSpring())
                    
                    
                    
                    Circle()
                        .overlay(
                            Circle()
                                .stroke(orangeFill ? .clear : orangeColor, style: StrokeStyle(lineWidth: 3.5, lineCap: .round, lineJoin: .round)))
                        .foregroundColor(orangeFill ? orangeColor : .clear)
                        .frame(width: 16, height: 16)
                        .onTapGesture {
                            self.orangeFill = true
                            self.labelText = self.proteinCoiunt
                            self.blueFill = false
                            self.greenFill = false
                            self.redFill = false
                    }
                    .animation(.interactiveSpring())
                    
                    
                    
                    Circle()
                        .overlay(
                            Circle()
                                .stroke(redFill ? .clear : redColor, style: StrokeStyle(lineWidth: 3.5, lineCap: .round, lineJoin: .round)))
                        .foregroundColor(redFill ? redColor : .clear)
                        .frame(width: 16, height: 16)
                        .onTapGesture {
                            self.redFill = true
                            self.labelText = self.fatCount
                            self.blueFill = false
                            self.greenFill = false
                            self.orangeFill = false
                    }
                    .animation(.interactiveSpring())
                    
                }.frame(width: 88)
                
                HStack {
                    Text(labelText)
                        .foregroundColor(labelColor)
                        .font(Font.custom("Gaoel", size: 10))
                }.frame(width: 63, alignment: .center)
                    .onAppear {
                        self.labelText = self.caloriesCount
                }
                
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
