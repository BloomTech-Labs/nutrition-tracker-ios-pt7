//
//  LSLCalculateBMIViewController.swift
//  Nutrition Tracker
//
//  Created by Michael Stoffer on 2/29/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class LSLCalculateBMIViewController: UIViewController {
    
    // MARK: - IBOutlets and Properties
    
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBOutlet var standardUIView: UIView!
    @IBOutlet var metricUIView: UIView!
    @IBOutlet var currentBMILabel: UILabel!
    
    var nutritionController = LSLUserController()
    var createProfileDelegate: CreateProfileCompletionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true

        self.navigationItem.hidesBackButton = true
        self.styleSegmentControl()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: .bmiUpdated, object: nil)
    }
    
    // MARK: - IBActions and Methods
    
    @IBAction func advanceToGettingPersonal(_ sender: CustomButton) {
        DispatchQueue.main.async {
            if self.segmentControl.selectedSegmentIndex == 0 {
                NotificationCenter.default.post(name: .calculateBMIStandard, object: nil)
            } else {
                NotificationCenter.default.post(name: .calculateBMIMetric, object: nil)
            }
            self.performSegue(withIdentifier: "ToGettingPersonal", sender: self)
        }
    }
    
    private func styleSegmentControl() {
        guard let customFont = UIFont(name: "Muli-Regular", size: 13) else {
            fatalError("""
                Failed to load the "Muli-Regular" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        let selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: customFont]
        self.segmentControl.setTitleTextAttributes(selectedTitleTextAttributes, for: .selected)
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: customFont]
        self.segmentControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0:
                self.standardUIView.isHidden = false
                self.metricUIView.isHidden = true
            case 1:
                self.standardUIView.isHidden = true
                self.metricUIView.isHidden = false
            default:
                self.standardUIView.isHidden = false
                self.metricUIView.isHidden = true
        }
    }
    
    @objc func updateViews() {
        guard let bmi = LSLUserController.bmi, isViewLoaded else { return NSLog("View isn't loaded.") }
        self.currentBMILabel.text = bmi
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToGettingPersonal" {
            guard let gpVC = segue.destination as? LSLGettingPersonalViewController else { return }
            gpVC.nutritionController = self.nutritionController
            gpVC.createProfileDelegate = self.createProfileDelegate
        }
    }
}
