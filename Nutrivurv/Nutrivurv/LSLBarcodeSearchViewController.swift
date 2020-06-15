//
//  LSLBarcodeSearchViewController.swift
//  Nutrivurv
//
//  Created by Dillon on 6/14/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//
import AVFoundation
import UIKit
import Vision

class LSLBarcodeSearchViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    var backCamera: AVCaptureDevice?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var captureOutput: AVCapturePhotoOutput?
    var captureSession: AVCaptureSession!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - AVCapture Device Set-Up
    
    private func checkPermissions() {
        let mediaType = AVMediaType.video
        let status = AVCaptureDevice.authorizationStatus(for: mediaType)
        
        switch status {
        case .denied, .restricted:
            displayNotAuthorizedAlert()
        case .notDetermined:
            // Prompt user for access to camera
            AVCaptureDevice.requestAccess(for: mediaType) { (granted) in
                guard granted != true else { return }
                
                DispatchQueue.main.async {
                    self.displayNotAuthorizedAlert()
                }
            }
        default:
            break
        }
    }
    
    
    // MARK: - Helper Functions
    
    @objc private func openSettings() {
        let settingsURL = URL(string: UIApplication.openSettingsURLString)!
        UIApplication.shared.open(settingsURL) { (_) in
            self.checkPermissions()
        }
    }
    
    // MARK: - Alerts and Alert Controllers
    
    private func displayNotAuthorizedAlert() {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.8, height: 20))
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "Please grant access to the camera for scanning barcodes."
        label.sizeToFit()

        let button = UIButton(frame: CGRect(x: 0, y: label.frame.height + 8, width: view.frame.width * 0.8, height: 35))
        button.layer.cornerRadius = 10
        button.setTitle("Grant Access", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: 4.0/255.0, green: 92.0/255.0, blue: 198.0/255.0, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(openSettings), for: .touchUpInside)

        let containerView = UIView(frame: CGRect(
            x: view.frame.width * 0.1,
            y: (view.frame.height - label.frame.height + 8 + button.frame.height) / 2,
            width: view.frame.width * 0.8,
            height: label.frame.height + 8 + button.frame.height
            )
        )
        containerView.addSubview(label)
        containerView.addSubview(button)
        view.addSubview(containerView)
    }
    
    private func createAndDisplayAlertController(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - Vision Framework Methods
    
    lazy var detectBarcodeRequest: VNDetectBarcodesRequest = {
        return VNDetectBarcodesRequest { (request, error) in
            guard error == nil else {
                print("Error scanning barcode")
                // Alert user of error
                return
            }
            
            self.processClassification(for: request)
        }
    }()
    
    func processClassification(for request: VNRequest) {
        // Extract payload
    }

}
