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
    
//    var data: ChartData = ChartData(values: [("Sunday", 523), ("Monday", 376), ("Tuesday", 298), ("Wednesday", 424), ("Thursday", 572), ("Friday", 0), ("Saturday", 0)])
    var title: String = "Calories"
    var legend: String = "This Week"
    var style: ChartStyle = Styles.barChartStyleOrangeLight
    var form: CGSize = ChartForm.medium
    var image: Image = Image(systemName: "waveform.path.ecg")
    var valueSpecifier: String = "%.0f"
    
    var body: some View {
        
        let caloriesData = ChartData(values: [("Sunday", calories.sundayCount), ("Monday", calories.mondayCount), ("Tuesday", calories.tuesdayCount), ("Wednesday", calories.wednesdayCount), ("Thursday", calories.thursdayCount), ("Friday", calories.fridayCount), ("Saturday", calories.saturdayCount)])
        
        return VStack {
            BarChartView(data: caloriesData, title: title, legend: legend, style: style, form: form, dropShadow: false, cornerImage: image, valueSpecifier: valueSpecifier)
        }
    }
}

struct ActiveCaloriesView_Previews: PreviewProvider {
    static var previews: some View {
        CaloriesView(calories: Calories())
    }
}
