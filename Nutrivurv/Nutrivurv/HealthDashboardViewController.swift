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
        super.init(coder: aDecoder, rootView: HealthDashboardView(healthKitController: HealthKitController.shared, activeCalories: HealthKitController.shared.activeCalories, consumedCalories: HealthKitController.shared.consumedCalories, caloricDeficits: HealthKitController.shared.caloricDeficits, weight: HealthKitController.shared.weight, bodyFat: HealthKitController.shared.bodyFat, delegate: HealthDashboardDelegate()))
    }
    
    //MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if HealthKitController.shared.noData {
            rootView.delegate.noHealthData = true
        } else {
            rootView.delegate.noHealthData = false
        }
    }
}
