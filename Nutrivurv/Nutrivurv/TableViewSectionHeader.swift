//
//  TableViewSectionHeader.swift
//  Nutrivurv
//
//  Created by Dillon on 7/31/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import SwiftUI

struct TableViewSectionHeader: View {
    @ObservedObject var dailyMacrosModel: DailyMacros
    @State var selectedIndex: Int = 0
    
    var bgHeight: CGFloat = 36
    
    // Primary colors for circles/rings
    var blueColor = Color(UIColor(named: "nutrivurv-blue-new")!)
    var greenColor = Color(UIColor(named: "nutrivurv-green-new")!)
    var orangeColor = Color(UIColor(named: "nutrivurv-orange-new")!)
    var redColor = Color(UIColor(named: "nutrivurv-red-new")!)
    
    // Secondary colors for backgrounds & text
    var bgColor = Color(UIColor(named: "food-log-label-bg")!)
    var bgShadowColor = Color(UIColor(named: "daily-vibe-shadow")!)
    var labelColor = Color(UIColor(named: "food-log-label-text")!)
    
    var body: some View {
        
        return ZStack {
            RoundedRectangle(cornerRadius: bgHeight / 2, style: .continuous)
                .foregroundColor(bgColor)
                .shadow(color: bgShadowColor.opacity(0.85), radius: 9.0, x: 0, y: 0)
            
            HStack {
                Spacer(minLength: 22)
                HStack {
                    MacrosTableView(index: 0, color: blueColor, selected: $selectedIndex)
                    MacrosTableView(index: 1, color: greenColor, selected: $selectedIndex)
                    MacrosTableView(index: 2, color: orangeColor, selected: $selectedIndex)
                    MacrosTableView(index: 3, color: redColor, selected: $selectedIndex)
                }.frame(width: 92)
                
                HStack {
                    Text(
                        "\(getValueForMacro()) \(selectedIndex == 0 ? "Cals" : "Grams")"
                    )
                        .foregroundColor(labelColor)
                        .font(Font.custom("Gaoel", size: 11))
                }.frame(width: 82, alignment: .center)
                
                Spacer(minLength: 18)
            }
            .frame(width: 156, height: 18, alignment: .center)
        }
        .frame(width: 204, height: bgHeight)
    }
    
    func getValueForMacro() -> String {
        switch selectedIndex {
        case 0:
            return "\(Int(self.dailyMacrosModel.caloriesCount))"
        case 1:
            return "\(Int(self.dailyMacrosModel.carbsCount))"
        case 2:
            return "\(Int(self.dailyMacrosModel.proteinCount))"
        case 3:
            return "\(Int(self.dailyMacrosModel.fatCount))"
        default:
            return "0"
        }
    }
}

struct MacrosMealHeader_Previews: PreviewProvider {
    static var previews: some View {
        TableViewSectionHeader(dailyMacrosModel: DailyMacros())
    }
}

struct MacrosTableView: View {
    // Used to change opacity and animation properties if in dark mode for improved look
    @Environment(\.colorScheme) var colorScheme
    @State var index: Int
    @State var color: Color
    @Binding var selected: Int
    
    var body: some View {
        let animation = Animation.interactiveSpring(response: colorScheme == .dark ? 0.3 : 0.16, dampingFraction: colorScheme == .dark ? 0.55 : 0.48, blendDuration: colorScheme == .dark ? 0.5 : 0.02)
        
        return Circle()
            .overlay(
                Circle()
                    .stroke(selected == index ? .clear : color.opacity(colorScheme == .dark ? 1.0 : 0.8), style: StrokeStyle(lineWidth: 3.5, lineCap: .round, lineJoin: .round))
                    .animation(animation.speed(1.25)))
            .foregroundColor(selected == index ? color.opacity(colorScheme == .dark ? 1.0 : 0.8) : .clear)
            .frame(width: 18, height: 18)
            .onTapGesture {
                self.selected = self.index
        }
        .scaleEffect(selected == index ? 0.95 : 1.0)
        .animation(animation)
    }
}
