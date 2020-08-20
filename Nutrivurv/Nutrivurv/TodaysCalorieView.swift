//
//  TodaysCalorieView.swift
//  Nutrivurv
//
//  Created by Dillon P on 8/17/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import SwiftUI

struct TodaysCalorieView: View {
    @ObservedObject var dailyMacros: DailyMacros
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .foregroundColor(Color(UIColor(named: "bg-color")!))
                .shadow(color: Color(UIColor(named: "daily-vibe-shadow")!), radius: 8.0, x: 0, y: 0)

            RingView(showRings: .constant(true), showMacrosDetail: .constant(true), uiColor: UIColor(named: "nutrivurv-blue-new")!, width: 100, height: 100, progressPercent: dailyMacros.caloriesPercent, lineWidth: 16).padding(.top, 13)

            VStack{
                HStack {
                    Text("calories consumed")
                        .font(Font.custom("Gaoel", size: 14))
                        .padding(.leading, 6)

                    Spacer()

                    Image("tableware")
                        .renderingMode(.template)
                        .foregroundColor(Color.gray)
                        .padding(.trailing, 6)

                }.frame(width: 160, alignment: .leading)

                Spacer()

                Text("\(String(format: "%.1f", dailyMacros.caloriesPercent)) %")
                    .font(Font.custom("Gaoel", size: 18))

                Spacer()

                HStack {
                    Text("today")
                        .font(Font.custom("Gaoel", size: 12))
                        .foregroundColor(Color.gray)
                        .padding(.leading, 6)

                    Spacer()

                    Text("\(String(format: "%.0f", dailyMacros.caloriesCount)) cals")
                        .font(Font.custom("Gaoel", size: 12))
                        .foregroundColor(Color.gray)
                        .padding(.trailing, 6)

                }.frame(width: 160, alignment: .leading)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 10)
        }
    }
}

struct TodaysCalorieView_Previews: PreviewProvider {
    static var previews: some View {
        TodaysCalorieView(dailyMacros: DailyMacros())
    }
}
