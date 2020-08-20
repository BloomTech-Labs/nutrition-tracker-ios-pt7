//
//  CalculateBMIViewController.swift
//  Nutrivurv
//
//  Created by Michael Stoffer on 2/29/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class CalculateBMIViewController: UIViewController {
    
    // MARK: - IBOutlets and Properties
    
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBOutlet var standardUIView: UIView!
    @IBOutlet var metricUIView: UIView!
    @IBOutlet var currentBMILabel: UILabel!
    
    var profileController: ProfileCreationController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.styleSegmentControl()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: .bmiUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(bmiTextInputsNotNumbers), name: .bmiInputsNotNumbers, object: nil)
    }
    
    // MARK: - IBActions and Methods
    
    @IBAction func advanceToGettingPersonal(_ sender: CustomButton) {
        DispatchQueue.main.async {
            if self.segmentControl.selectedSegmentIndex == 0 {
                NotificationCenter.default.post(name: .calculateBMIStandard, object: nil)
            } else {
                NotificationCenter.default.post(name: .calculateBMIMetric, object: nil)
            }
            
            guard let profileController = self.profileController, profileController.bmi != nil else {
                self.createAndDisplayAlertController(title: "Missing Information", message: "Please input your height and weight (estimate if you're unsure) in order to calculate your BMI.")
                return
            }
        
            self.performSegue(withIdentifier: "ToGettingPersonal", sender: self)
        }
    }
    
    @IBAction func infoButtonTapped(_ sender: Any) {
        self.createAndDisplayAlertController(title: "Nutrivurv's Mission", message: "Our mission is to help you acheive your health & fitness goals, and teach you how to live a healthier lifestyle. To accomplish this, your height and weight are used to calculate key metrics that will help you better understand your body and track your progress over time!")
    }
    
    // MARK: - Segmented Control Methods
    
    private func styleSegmentControl() {
        guard let customFont = UIFont(name: "Muli-Regular", size: 13) else { return }
        
        let selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: customFont]
        self.segmentControl.setTitleTextAttributes(selectedTitleTextAttributes, for: .selected)
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font: customFont]
        self.segmentControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 1:
                self.standardUIView.isHidden = true
                self.metricUIView.isHidden = false
            default:
                self.standardUIView.isHidden = false
                self.metricUIView.isHidden = true
        }
    }
    
    // MARK: - Alert Controllers & Related Functions
    
    private func createAndDisplayAlertController(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func bmiTextInputsNotNumbers() {
        createAndDisplayAlertController(title: "Please enter numbers", message: "You'll need to enter numbers (not text) for your height & weight in order to create your profile.")
    }
    
    
    // MARK: - Update Views
    
    @objc func updateViews() {
        guard let profileController = self.profileController, let bmi = profileController.bmi else {
            print("No BMI")
            return
        }
        self.currentBMILabel.text = bmi
    }

    // MARK: - Navigation & Subview Setip
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToGettingPersonal" {
            guard let gpVC = segue.destination as? GettingPersonalViewController else { return }
            gpVC.profileController = self.profileController
            gpVC.modalPresentationStyle = .fullScreen
            
        } else if segue.identifier == "StandardBMI" {
            guard let standardVC = segue.destination as? StandardBMIViewController else { return }
            standardVC.profileController = self.profileController
            
        } else if segue.identifier == "MetricBMI" {
            guard let standardVC = segue.destination as? MetricBMIViewController else { return }
            standardVC.profileController = self.profileController
        }
    }
}
