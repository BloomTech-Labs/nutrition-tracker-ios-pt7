//
//  LSLDietTableViewCell.swift
//  Nutrition Tracker
//
//  Created by Michael Stoffer on 2/29/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class LSLDietTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets and Properties
    
    @IBOutlet var dietRadioButton: UIButton!
    @IBOutlet var dietLabel: UILabel!
    
    var diet: LSLDietPreference? {
        didSet {
            self.updateViews()
        }
    }
    
    weak var delegate: LSLDietTableViewCellDelegate?
    
    private func updateViews() {
        guard let diet = self.diet else { return }
        
        self.dietRadioButton.isSelected = diet.isSelected
        self.dietLabel.text = diet.name
        
        if diet.isSelected == true {
            self.dietRadioButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        } else {
            self.dietRadioButton.setImage(UIImage(systemName: "circle"), for: .normal)
        }
    }

    @IBAction func selectDiet(_ sender: UIButton) {
        delegate?.tappedRadioButton(on: self)
    }
}
