//
//  ActiveCaloriesView.swift
//  Nutrivurv
//
//  Created by Dillon on 8/11/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import SwiftUI
import SwiftUICharts

struct CaloriesView: View {
    @ObservedObject var calories: Calories
    
    var title: String = "Calories"
    var legend: String = "Last 7 Days"
    var style: ChartStyle = Styles.barChartStyleOrangeLight
    var form: CGSize = ChartForm.medium
    var image: Image = Image(systemName: "waveform.path.ecg")
    var valueSpecifier: String = "%.0f"
    
    var body: some View {
        let caloriesData = ChartData(values: [(calories.day1Label, calories.day1Count), (calories.day2Label, calories.day2Count), (calories.day3Label, calories.day3Count), (calories.day4Label, calories.day4Count), (calories.day5Label, calories.day5Count), (calories.day6Label, calories.day6Count), (calories.day7Label, calories.day7Count)])
        
        return VStack {
            BarChartView(data: caloriesData, title: title, legend: legend, style: style, form: form, dropShadow: true, cornerImage: image, valueSpecifier: valueSpecifier)
        }
    }
}

struct ActiveCaloriesView_Previews: PreviewProvider {
    static var previews: some View {
        CaloriesView(calories: Calories())
    }
}
