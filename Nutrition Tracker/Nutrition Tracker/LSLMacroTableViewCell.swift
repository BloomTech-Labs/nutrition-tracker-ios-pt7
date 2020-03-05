//
//  LSLMacroTableViewCell.swift
//  Nutrition Tracker
//
//  Created by Michael Stoffer on 2/29/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class LSLMacroTableViewCell: UITableViewCell {

    // MARK: - IBOutlets and Properties
    
    @IBOutlet var macroCheckbox: UIButton!
    @IBOutlet var macroLabel: UILabel!
    
    var macro: LSLMacroPreference? {
        didSet {
            self.updateViews()
        }
    }
    
    weak var delegate: LSLMacroTableViewCellDelegate?
    
    private func updateViews() {
        guard let macro = self.macro else { return }
        
        self.macroCheckbox.isSelected = macro.isSelected
        self.macroLabel.text = macro.name
        
        if macro.isSelected == true {
            self.macroCheckbox.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        } else {
            self.macroCheckbox.setImage(UIImage(systemName: "circle"), for: .normal)
        }
    }
    
    @IBAction func selectMacro(_ sender: UIButton) {
        delegate?.tappedCheckbox(on: self)
    }
}
