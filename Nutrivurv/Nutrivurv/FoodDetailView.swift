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
    
    @State var showNutrients: Bool = false
    
    var caloriesColor = UIColor(named: "nutrivurv-blue-new")!
    var carbsColor = UIColor(named: "nutrivurv-green-new")!
    var proteinColor = UIColor(named: "nutrivurv-orange-new")!
    var fatColor = UIColor(named: "nutrivurv-red-new")!
    
    var shadowColor = UIColor(named: "detail-view-card-shadow")!
    var bgColor = UIColor(named: "detail-view-main-bg")!
    
    var body: some View {
        NavigationView {
            VStack {
                Image("avocado")
                    .frame(height: UIScreen.main.bounds.height / 3, alignment: .bottom)
                    .scaledToFill()
                
                ZStack {
                    // Main card background view
                    RoundedRectangle(cornerRadius: 30.0, style: .continuous)
                        .foregroundColor(Color(bgColor))
                        .shadow(color: Color(shadowColor), radius: 8.0, x: 0, y: -3)
                    
                    VStack {
                        
                        HStack {
                            TableViewSectionHeader(dailyMacrosModel: DailyMacros())
                                .scaleEffect(1.10)
                                .frame(width: 245, height: 43)
                            
                            Spacer()
                            
                            Image("add-meal-button-icon")
                                .frame(width: 60, height: 60)
                                .scaleEffect(1.0)
                                .shadow(color: Color(shadowColor), radius: 8.0, x: 0, y: -3)
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
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 6, trailing: 0))
                        
                        
                        ProgressSwitcherView(currentProgress: $currentProgresss)
                            .frame(width: 180, height: 60, alignment: .center)
                            .padding(EdgeInsets(top: 0, leading: 117, bottom: 0, trailing: 117))
                        
                        ZStack {
                            HStack(spacing: 20) {
                                //                            MacrosDetailView(count: dailyMacros.caloriesCount, progressPercent: dailyMacros.caloriesPercent, uiColor: UIColor(named: "nutrivurv-blue-new")!)
                                //                            Spacer()
                                //                            MacrosDetailView(count: dailyMacros.carbsCount, progressPercent: dailyMacros.carbsPercent, uiColor: UIColor(named: "nutrivurv-green-new")!)
                                //                            Spacer()
                                //                            MacrosDetailView(count: dailyMacros.proteinCount, progressPercent: dailyMacros.proteinPercent, uiColor: UIColor(named: "nutrivurv-orange-new")!)
                                //                            Spacer()
                                //                            MacrosDetailView(count: dailyMacros.fatCount, progressPercent: dailyMacros.fatPercent, uiColor: UIColor(named: "nutrivurv-red-new")!)
                                
                                MacrosDetailView(count: currentProgresss ? 689 : 1178, progressPercent: currentProgresss ? 29 : 46, macroDescription: " cals", uiColor: caloriesColor)
                                
                                MacrosDetailView(count: currentProgresss ? 120 : 189, progressPercent: currentProgresss ? 48 : 73, macroDescription: "g carbs", uiColor: carbsColor)
                                
                                MacrosDetailView(count: currentProgresss ? 98 : 126, progressPercent: currentProgresss ? 72 : 88,macroDescription: "g protein", uiColor: proteinColor)
                                
                                MacrosDetailView(count: currentProgresss ? 82 : 106, progressPercent: currentProgresss ? 28 : 54,macroDescription: "g fat", uiColor: fatColor)
                                
                            }
                            .frame(width: UIScreen.main.bounds.width - 58, height: 97)
                            .offset(x: -4, y: currentProgresss ? -20 : 0)
                            
                            HStack(spacing: 6) {
                                BubbleView(currentProgress: $currentProgresss, showNutrients: $showNutrients, index: 1, percentDifference: 4)
                                Spacer()
                                BubbleView(currentProgress: $currentProgresss, showNutrients: $showNutrients, index: 2, percentDifference: 3)
                                Spacer()
                                BubbleView(currentProgress: $currentProgresss, showNutrients: $showNutrients, index: 3, percentDifference: 9)
                                Spacer()
                                BubbleView(currentProgress: $currentProgresss, showNutrients: $showNutrients, index: 4, percentDifference: 2)
                            }
                            .frame(width: UIScreen.main.bounds.width - 80, height: 46, alignment: .center)
                            .padding(EdgeInsets(top: 0, leading: 37, bottom: 104, trailing: 0))
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 220, alignment: .top)
                    .offset(x: 0, y: -30)
                    
                    NutritionFactsView(showNutrients: $showNutrients)
                        .offset(y: showNutrients ? 168 : 370)
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 220, alignment: .bottom)
                .offset(y: showNutrients ? -180 : -40)
            }
        }.navigationBarTitle("Test", displayMode: .inline)
    }
}

struct FoodDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FoodDetailView(dailyMacros: DailyMacros())
    }
}
