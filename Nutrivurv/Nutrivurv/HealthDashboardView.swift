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
    @ObservedObject var activeCalories: Calories
    @ObservedObject var restingCalories: Calories
    @ObservedObject var caloriesConsumed: Calories
    
    var body: some View {
        
        return NavigationView {
            VStack {
                CaloriesView(calories: activeCalories, title: "Active Calories", legend: "This Week", style: Styles.barChartStyleOrangeLight, form: ChartForm.extraLarge)
                    .shadow(color: Color.gray.opacity(0.2), radius: 8, x: 0, y: 0)
                
                HStack {
                    CaloriesView(calories: restingCalories, title: "Resting Calories", legend: "This Week", style: Styles.barChartStyleNeonBlueLight, form: ChartForm.medium)
                    .shadow(color: Color.gray.opacity(0.2), radius: 8, x: 0, y: 0)
                    
                    CaloriesView(calories: caloriesConsumed, title: "Calories Consumed", legend: "This Week", style: Styles.barChartMidnightGreenLight, form: ChartForm.medium)
                    .shadow(color: Color.gray.opacity(0.2), radius: 8, x: 0, y: 0)
                }
            }
        }.navigationBarTitle("your health dashboard", displayMode: .inline)
    }
}

struct HealthDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        HealthDashboardView(activeCalories: Calories(), restingCalories: Calories(), caloriesConsumed: Calories())
    }
}
