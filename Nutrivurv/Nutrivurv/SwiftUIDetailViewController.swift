//
//  SwiftUIDetailViewController.swift
//  Nutrivurv
//
//  Created by Dillon on 8/9/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import SwiftUI

class SwiftUIDetailViewController: UIHostingController<FoodDetailView> {
    
    var foodLogEntry: FoodLogEntry?
    
    required init?(coder aDecoder: NSCoder) {
        let currentMacros = FoodLogController.shared.totalDailyMacrosModel
        let newMacros = DailyMacros()
        
        newMacros.caloriesCount = currentMacros.caloriesCount
        newMacros.caloriesPercent = currentMacros.caloriesPercent
        
        newMacros.carbsCount = currentMacros.carbsCount
        newMacros.carbsPercent = currentMacros.carbsPercent
        
        newMacros.proteinCount = currentMacros.proteinCount
        newMacros.proteinPercent = currentMacros.proteinPercent
        
        newMacros.fatCount = currentMacros.fatCount
        newMacros.fatPercent = currentMacros.fatPercent
        
        super.init(coder: aDecoder, rootView: FoodDetailView(currentDailyMacros: currentMacros, newDailyMacros: newMacros))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
