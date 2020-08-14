//
//  HealthDashboardViewController.swift
//  Nutrivurv
//
//  Created by Dillon on 8/12/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import SwiftUI
import Combine
import HealthKit

class HealthDashboardViewController: UIHostingController<HealthDashboardView> {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: HealthDashboardView(activeCalories: Calories(), caloricDeficit: Calories(), dailyMacros: FoodLogController.shared.totalDailyMacrosModel))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        self.navigationController?.navigationBar.tintColor = UIColor(named: "bg-color")!
        self.navigationController?.navigationBar.backgroundColor = UIColor(named: "bg-color")!
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "bg-color")!
        
        getActiveCaloriesForWeek()
    }
    
    private func getActiveCaloriesForWeek() {
        guard let activeCalsSampleType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned) else {
            return
        }
        
        HealthKitController.getCumulativeStatsCollectionUsingOneDayInterval(for: activeCalsSampleType) { (statsCollection, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let statsCollection = statsCollection else {
                print("error with stats collection data")
                return
            }
            
            let endDate = Date()
            
            guard let startDate = Calendar.current.date(byAdding: .day, value: -6, to: endDate) else {
                print("error getting start date for statistics collection")
                return
            }
            
            var activeCaloriesByDay: [(String, Int)] = []
            
            statsCollection.enumerateStatistics(from: startDate, to: endDate) { (statistics, stop) in
                if let caloriesSum = statistics.sumQuantity() {
                    let date = statistics.startDate
                    let weekDay = Calendar.current.component(.weekday, from: date)
                    
                    let dateFormatter = DateFormatter()
                    let weekDayString = dateFormatter.weekdaySymbols[weekDay - 1]
                    
                    let calorieDouble = caloriesSum.doubleValue(for: HKUnit.kilocalorie())
                    let calorieInt = Int(calorieDouble)
                    
                    activeCaloriesByDay.append((weekDayString, calorieInt))
                }
            }
            
            self.rootView.activeCalories.day1Label = activeCaloriesByDay[0].0
            self.rootView.activeCalories.day1Count = activeCaloriesByDay[0].1
            
            self.rootView.activeCalories.day2Label = activeCaloriesByDay[1].0
            self.rootView.activeCalories.day2Count = activeCaloriesByDay[1].1
            
            self.rootView.activeCalories.day3Label = activeCaloriesByDay[2].0
            self.rootView.activeCalories.day3Count = activeCaloriesByDay[2].1
            
            self.rootView.activeCalories.day4Label = activeCaloriesByDay[3].0
            self.rootView.activeCalories.day4Count = activeCaloriesByDay[3].1
            
            self.rootView.activeCalories.day5Label = activeCaloriesByDay[4].0
            self.rootView.activeCalories.day5Count = activeCaloriesByDay[4].1
            
            self.rootView.activeCalories.day6Label = activeCaloriesByDay[5].0
            self.rootView.activeCalories.day6Count = activeCaloriesByDay[5].1
            
            self.rootView.activeCalories.day7Label = activeCaloriesByDay[6].0
            self.rootView.activeCalories.day7Count = activeCaloriesByDay[6].1
        }
    }

    private func getWeeklyCaloriesConsumed() {
        
    }
}
