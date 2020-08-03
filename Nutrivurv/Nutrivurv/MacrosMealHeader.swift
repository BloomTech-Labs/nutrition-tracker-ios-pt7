//
//  MacrosMealHeader.swift
//  Nutrivurv
//
//  Created by Dillon on 7/31/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import SwiftUI

struct MacrosMealHeader: View {
    @ObservedObject var dailyMacrosModel: DailyMacros
    
    @State var blueFill = true
    @State var greenFill = false
    @State var orangeFill = false
    @State var redFill = false
    
    var bgHeight: CGFloat = 34
    
    var blueColor = Color(UIColor(named: "nutrivurv-blue-new")!).opacity(0.7)
    var greenColor = Color(UIColor(named: "nutrivurv-green-new")!).opacity(0.7)
    var orangeColor = Color(UIColor(named: "nutrivurv-orange-new")!).opacity(0.7)
    var redColor = Color(UIColor(named: "nutrivurv-red-new")!).opacity(0.7)
    
    var bgColor = Color(UIColor(named: "food-log-label-bg")!)
    var bgShadowColor = Color(UIColor(named: "daily-vibe-shadow")!)
    var labelColor = Color(UIColor(named: "food-log-label-text")!)
    
    @State var labelText: String = ""
    
    @State var initialLoad = true
    
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
                            self.labelText = "\(Int(self.dailyMacrosModel.caloriesCount)) cals"
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
                            self.labelText = "\(Int(self.dailyMacrosModel.carbsCount)) grams"
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
                            self.labelText = "\(Int(self.dailyMacrosModel.proteinCount)) grams"
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
                            self.labelText = "\(Int(self.dailyMacrosModel.fatCount)) grams"
                            self.blueFill = false
                            self.greenFill = false
                            self.orangeFill = false
                    }
                    .animation(.interactiveSpring())
                    
                }.frame(width: 88)
                
                HStack {
                    Text(self.labelText)
                        .foregroundColor(labelColor)
                        .font(Font.custom("Gaoel", size: 10))
                        .onAppear {
                            if self.initialLoad {
                                self.labelText = "\(Int(self.dailyMacrosModel.caloriesCount)) cals"
                                self.initialLoad = false
                            }
                    }
                }.frame(width: 63, alignment: .center)
                
                Spacer(minLength: 18)
                
            }
            .frame(width: 156, height: 16, alignment: .center)
            
        }.frame(width: 184, height: bgHeight)
        
    }
}

struct MacrosMealHeader_Previews: PreviewProvider {
    static var previews: some View {
        MacrosMealHeader(dailyMacrosModel: DailyMacros())
    }
}
