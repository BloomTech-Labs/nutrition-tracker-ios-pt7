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
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    CaloriesView(calories: activeCalories, title: "Active Calories", legend: "This Week", style: Styles.barChartStyleOrangeLight, form: ChartForm.extraLarge)
                        
                    
                    HStack {
                        CaloriesView(calories: restingCalories, title: "Resting Calories", legend: "This Week", style: Styles.barChartStyleNeonBlueLight, form: ChartForm.medium)
                        
                        CaloriesView(calories: caloriesConsumed, title: "Calories Consumed", legend: "This Week", style: Styles.barChartMidnightGreenLight, form: ChartForm.medium)
                    }
                }.padding()
            }
        }.navigationBarTitle("your health dashboard", displayMode: .inline)
    }
}

struct HealthDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        HealthDashboardView(activeCalories: Calories(), restingCalories: Calories(), caloriesConsumed: Calories())
    }
}
