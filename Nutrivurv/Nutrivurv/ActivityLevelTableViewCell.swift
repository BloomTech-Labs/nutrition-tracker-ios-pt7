//
//  ActivityLevelTableViewCell.swift
//  Nutrition Tracker
//
//  Created by Michael Stoffer on 3/10/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class ActivityLevelTableViewCell: UITableViewCell {
    
    @IBOutlet var activeRadioButton: UIButton!
    @IBOutlet var activeTitle: UILabel!
    @IBOutlet var activeDescription: UILabel!
    
    var activityLevel: ActivityLevel? {
        didSet {
            self.updateViews()
        }
    }
    
    weak var delegate: ActivityLevelCellDelegate?

    private func updateViews() {
        guard let activityLevel = self.activityLevel else { return }
        
        self.activeRadioButton.isSelected = activityLevel.isSelected
        self.activeTitle.text = activityLevel.name
        self.activeDescription.text = activityLevel.description
        
        if activityLevel.isSelected == true {
            self.activeRadioButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        } else {
            self.activeRadioButton.setImage(UIImage(systemName: "circle"), for: .normal)
        }
    }
    
    @IBAction func selectActiveness(_ sender: UIButton) {
        delegate?.tappedRadioButton(on: self)
    }
 }

protocol ActivityLevelCellDelegate: class {
    func tappedRadioButton(on cell: ActivityLevelTableViewCell)
}
