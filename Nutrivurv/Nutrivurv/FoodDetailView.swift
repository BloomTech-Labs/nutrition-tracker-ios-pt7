//
//  FoodDetailView.swift
//  Nutrivurv
//
//  Created by Dillon on 8/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import SwiftUI

struct FoodDetailView: View {
    @ObservedObject var dailyMacros: DailyMacros
    @State var currentProgresss: Bool = true
    
    var body: some View {
        VStack {
        
            Image("avocado")
                .frame(height: 320, alignment: .top)
                .scaledToFill()
            
            ZStack {
                // Main card background view
                RoundedRectangle(cornerRadius: 30.0, style: .continuous)
                    .foregroundColor(Color(UIColor(named: "detail-view-main-bg")!))
                    .shadow(color: Color(UIColor(named: "detail-view-card-shadow")!), radius: 8.0, x: 0, y: -3)
                
                VStack {
                    
                    HStack {
                        TableViewSectionHeader(dailyMacrosModel: DailyMacros())
                            .scaleEffect(1.10)
                            .frame(width: 245, height: 43)
                        
                        Spacer()
                        
                        Image("add-meal-button-icon")
                            .frame(width: 60, height: 60)
                            .scaleEffect(1.0)
                            .shadow(color: Color(UIColor(named: "detail-view-card-shadow")!), radius: 8.0, x: 0, y: -3)
                    }
                    .frame(width: UIScreen.main.bounds.width - 24, height: 60)
                    
                    
                    HStack {
                        VStack{
                            Text("Avocados")
                                .font(Font.custom("Catamaran-Bold", size: 20))
                                .frame(alignment: .leading)
                                .minimumScaleFactor(0.6)
                                .lineLimit(1)
                            
                            Text("Generic Foods")
                                .font(Font.custom("QuattrocentoSans-Italic", size: 15))
                                .frame(alignment: .leading)
                                .padding(EdgeInsets(top: -5, leading: 4, bottom: 0, trailing: 0))
                        }
                        Spacer()
                        
                        Image("heart-icon")
                            .frame(width: 32, height: 29, alignment: .center)
                    }
                    .frame(width: UIScreen.main.bounds.width - 40, height: 44, alignment: .center)
                    .padding(EdgeInsets(top: -5, leading: 0, bottom: 8, trailing: 0))
                    
                    
                    ServingSizeSelectionView()
                        .frame(width: UIScreen.main.bounds.width - 50, height: 58, alignment: .center)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 14, trailing: 0))
                    
                    
                    ProgressSwitcherView(currentProgress: $currentProgresss)
                        .frame(width: 180, height: 60, alignment: .center)
                        .padding(EdgeInsets(top: 0, leading: 117, bottom: 8, trailing: 117))
                    
                    ZStack {
                        
                        HStack {
                            MacrosDetailView(count: dailyMacros.caloriesCount, progressPercent: dailyMacros.caloriesPercent, uiColor: UIColor(named: "nutrivurv-blue-new")!)
                            Spacer()
                            MacrosDetailView(count: dailyMacros.carbsCount, progressPercent: dailyMacros.carbsPercent, uiColor: UIColor(named: "nutrivurv-green-new")!)
                            Spacer()
                            MacrosDetailView(count: dailyMacros.proteinCount, progressPercent: dailyMacros.proteinPercent, uiColor: UIColor(named: "nutrivurv-orange-new")!)
                            Spacer()
                            MacrosDetailView(count: dailyMacros.fatCount, progressPercent: dailyMacros.fatPercent, uiColor: UIColor(named: "nutrivurv-red-new")!)
                        }
                        .frame(width: UIScreen.main.bounds.width - 60, height: 97, alignment: .center)
                        .offset(y: currentProgresss ? -24 : 0)
                        
                        HStack {
                            BubbleView(currentProgress: $currentProgresss)
                            Spacer()
                            BubbleView(currentProgress: $currentProgresss)
                            Spacer()
                            BubbleView(currentProgress: $currentProgresss)
                            Spacer()
                            BubbleView(currentProgress: $currentProgresss)
                        }
                        .frame(width: UIScreen.main.bounds.width - 48, height: 46, alignment: .center)
                        .padding(EdgeInsets(top: 0, leading: 36, bottom: 80, trailing: 0))
                        
                    }
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 220, alignment: .top)
                .offset(x: 0, y: -30)
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 220, alignment: .bottom)
            .offset(y: -40)
        }
    }
}

struct FoodDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FoodDetailView(dailyMacros: DailyMacros())
    }
}
