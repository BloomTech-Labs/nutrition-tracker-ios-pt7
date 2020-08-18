//
//  HealthDashboardView.swift
//  Nutrivurv
//
//  Created by Dillon on 8/11/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import SwiftUI
import SwiftUICharts

struct HealthDashboardView: View {
    @ObservedObject var healthKitController: HealthKitController = .shared
    
    var body: some View {
        
        return VStack {
            Text("your health")
                .font(Font.custom("Gaoel", size: 13))
                .foregroundColor(Color(UIColor(named: "light-label")!))
                .padding(.top, UIScreen.main.bounds.height * 0.065)
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack {
                    
                    CaloriesView(calories: healthKitController.activeCalories, title: "Active Calories", legend: healthKitController.activeCalories.average == 0 ? "Last 7 Days" : "Last 7 Days · avg \(healthKitController.activeCalories.average) cals", style: Styles.barChartStyleNeonBlueLight , form: ChartForm.extraLarge)

                    HStack {
                        CaloriesView(calories: healthKitController.consumedCalories, title: "Calories Consumed", legend: healthKitController.consumedCalories.average == 0 ? "Last 7 Days" : "Last 7 Days\navg \(healthKitController.consumedCalories.average) cals", style: Styles.barChartStyleNeonBlueLight, form: ChartForm.medium)

                        TodaysCalorieView(dailyMacros: healthKitController.todaysCalorieConsumption)
                    }

//                    CaloriesView(calories: caloricDeficit, title: "Caloric Deficit", legend: "Last 7 Days", style: Styles.barChartStyleNeonBlueLight, form: ChartForm.extraLarge)
                    
                    LineChartView(data: healthKitController.weight.weightReadings, title: "Weight", legend: "last 30 days", form: ChartForm.large, rateValue: healthKitController.weight.rateChange)
                    
                    LineChartView(data: healthKitController.bodyFat.weightReadings, title: "% Body Fat", legend: "last 30 days", form: ChartForm.large, rateValue: healthKitController.bodyFat.rateChange, valueSpecifier: "%.2f")
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .foregroundColor(Color(UIColor(named: "bg-color")!))
                            .shadow(color: Color(UIColor(named: "daily-vibe-shadow")!), radius: 8.0, x: 0, y: 0)
                        
                        VStack {
                            Text("what is a caloric deficit?")
                                .foregroundColor(Color(UIColor(named: "light-label")!))
                                .font(Font.custom("Gaoel", size: 14))
                                .frame(alignment: .leading)
                                .padding(.vertical, 6)
                            
                            Text("A caloric deficit is when the number of calories consumed is less than the number of total calories burned on any given day. The total calories burned is equal to the sum of both your active calories (calories burned during exercise) and your basal metabolic rate (BMR). Your BMR is the number of calories necessary for essential bodily functions, i.e. the base number of calories burned by your body every day even when you don't exercise. A caloric deficit is necessary in order to lose weight, and its currently accepted in the scientific community that one pound of fat is equivalent to roughly ~3,500 calories. This means that for every 3,500 calories in deficit, you'll lose approximately 1 pound.")
                                .foregroundColor(Color.gray)
                                .font(Font.custom("QuattrocentoSans-Bold", size: 13))
                                .frame(alignment: .leading)
                                .padding(.vertical, 6)
                        }
                        .frame(width: 320, alignment: .leading)
                        
                    }.frame(height:  260)
                    
                }
                .padding(.horizontal, 28)
                .padding(.top, 16)
                .padding(.bottom, 90)
                
            }
            .background(Color(UIColor(named: "bg-color")!))
            
            
        }.background(Color(UIColor(named: "bg-color")!))
            .edgesIgnoringSafeArea(.all)
    }
}

struct HealthDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        HealthDashboardView(healthKitController: HealthKitController.shared)
    }
}
