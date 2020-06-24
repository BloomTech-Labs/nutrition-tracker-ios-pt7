//
//  BarcodeSearchViewController.swift
//  Nutrivurv
//
//  Created by Dillon on 6/14/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import AVFoundation
import UIKit

class BarcodeSearchViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    // MARK: - IBOutlets and Properties
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var backCamera: AVCaptureDevice?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var captureOutput: AVCapturePhotoOutput?
    var captureSession: AVCaptureSession!
    
    var shutterButton: UIButton!
    var notAuthorizedAlertContainerView: UIView!
    var barcodeScannerFrameView: UIView!
    
    var barcodeSearchDelegate: BarcodeSearchDelegate?
    var manualSearchDelegate: ManualSearchRequiredDelegate?
    var searchController: FoodSearchController?
    
    var permissionGranted: Bool = false
    
    
    // MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpActivityView()
        checkPermissions()
        setUpCameraLiveView()
        addBarcodeScannerFrameView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        #if targetEnvironment(simulator)
        
          self.dismiss(animated: true) {
              self.manualSearchDelegate?.unableToUseBarcodeScanningFeature()
          }
        
        #else
        // Ensure we have access to the camera each time the user accesses the view in order to prevent app from crashing
        checkPermissions()
        #endif
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // To prevent the view from adding duplicates, remove from the view here.
        // If permission is not yet granted, the alert will be displayed when checkPermissions() runs in viewDidAppear
        guard notAuthorizedAlertContainerView != nil else {
            return
        }
        notAuthorizedAlertContainerView.removeFromSuperview()
        
        if permissionGranted {
            if (captureSession?.isRunning == false) {
                captureSession.startRunning()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    // MARK: - Views & UI Setup
    
    private func setUpActivityView() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.7)
        activityIndicator.layer.cornerRadius = 4
    }
    
    private func startLoadingView() {
        self.activityIndicator.startAnimating()
        view.bringSubviewToFront(activityIndicator)
    }
    
    private func stopLoadingView() {
        self.activityIndicator.stopAnimating()
    }
    
    private func addBarcodeScannerFrameView() {
        barcodeScannerFrameView = UIView()
        barcodeScannerFrameView.layer.borderColor = UIColor(displayP3Red: 0.0, green: 66.0/255.0, blue: 108.0/255.0, alpha: 1.0).cgColor
        barcodeScannerFrameView.layer.borderWidth = 2
        view.addSubview(barcodeScannerFrameView)
        view.bringSubviewToFront(barcodeScannerFrameView)
    }
    
    private func displayNotAuthorizedAlert() {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.8, height: 20))
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.text = "Please grant access to the camera in order to scan barcodes."
        label.sizeToFit()
        
        let button = UIButton(frame: CGRect(x: 0, y: label.frame.height + 8, width: view.frame.width * 0.8, height: 35))
        button.layer.cornerRadius = 10
        button.setTitle("Grant Access", for: .normal)
        button.backgroundColor = UIColor(displayP3Red: 0.0, green: 66.0/255.0, blue: 108.0/255.0, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
        
        notAuthorizedAlertContainerView = UIView(frame: CGRect(
            x: view.frame.width * 0.1,
            y: (view.frame.height - label.frame.height + 8 + button.frame.height) / 2,
            width: view.frame.width * 0.8,
            height: label.frame.height + 8 + button.frame.height
            )
        )
        
        notAuthorizedAlertContainerView.addSubview(label)
        notAuthorizedAlertContainerView.addSubview(button)
        view.addSubview(notAuthorizedAlertContainerView)
    }
    
    
    // MARK: - AVCapture Device Set-Up
    
    private func checkPermissions() {
        let mediaType = AVMediaType.video
        let status = AVCaptureDevice.authorizationStatus(for: mediaType)
        
        switch status {
        case .denied, .restricted:
            self.permissionGranted = false
            displayNotAuthorizedAlert()
        case .notDetermined:
            // Prompt user for access to camera
            self.permissionGranted = false
            AVCaptureDevice.requestAccess(for: mediaType) { (granted) in
                guard granted != true else {
                    self.permissionGranted = true
                    return
                }
                DispatchQueue.main.async {
                    self.displayNotAuthorizedAlert()
                }
            }
        case .authorized:
              self.permissionGranted = true
            
        // Although all cases are covered for current API, we need a default if additional cases are added in the future.
        default:
            self.dismiss(animated: true) {
                self.manualSearchDelegate?.unableToUseBarcodeScanningFeature()
            }
            break
        }
    }
    
    private func setUpCameraLiveView() {
        // Ensure we have appropriate permissions before a capture session is established
        guard permissionGranted != false else {
            return
        }
        
        // Initialize capture session with appropriate camera
        self.captureSession = AVCaptureSession()
        self.captureSession.sessionPreset = .hd1920x1080
        
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera],
                                                                      mediaType: .video,
                                                                      position: .back)
        let devices = deviceDiscoverySession.devices
        for device in devices {
            if device.position == .back {
                self.backCamera = device
            }
        }
        
        guard let backCamera = backCamera else {
            createAndDisplayAlertController(title: "Camera error", message: "We couldn't find a camera to use on your device")
            return
        }
        
        // Establish input stream with appropriate device & add video input to capture session
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: backCamera)
        } catch {
            createAndDisplayAlertController(title: "Camera error", message: "This camera cannot be used to scan food items")
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            createAndDisplayAlertController(title: "Camera error", message: "Video could not be retrieved from the device's camera.")
            return
        }
        
        // Initialize metadata output device for detecting barcode objects automatically
        let metadataOutput = AVCaptureMetadataOutput()
        
        // Using this metadata output device eliminates the need for capturing & processing an image
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            // Object interpretation delegate must be on main queue
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            // Specificies which data types to interpret from output device (i.e. types of barcodes)
            // Only these types of meta data will be forwarded to the delegate (self)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
        } else {
            createAndDisplayAlertController(title: "Camera output error", message: "An output could not be established for the camera.")
            return
        }
        
        // Initialize & add preview layer for capture sesssion to establish an on screen view
        self.cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = .resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = .portrait
        cameraPreviewLayer?.frame = view.layer.bounds
        
        guard let previewLayer = cameraPreviewLayer else {
            createAndDisplayAlertController(title: "Camera error", message: "A preview couldn't be genrated for your device's camera")
            return
        }
        self.view.layer.addSublayer(previewLayer)
        
        // If we get here, it's safe to start the capture session
        self.captureSession.startRunning()
    }
    
    
    // MARK: - Helper Functions
    
    @objc private func openSettings() {
        let settingsURL = URL(string: UIApplication.openSettingsURLString)!
        UIApplication.shared.open(settingsURL) { (_) in
            self.checkPermissions()
        }
    }
    
    
    // MARK: - Alert Controllers
    
    private func createAndDisplayAlertController(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func createAndDisplayAlertControllerAndStartCaptureSession(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default) { (_) in
            self.captureSession.startRunning()
        }
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - Search by UPC
    
    // Uses the search controller object to initiate a search
    func searchForFoodByUPC(_ upc: String) {
        self.searchController?.searchForFoodItemWithUPC(searchTerm: upc) {
            DispatchQueue.main.async {
                
                // Update UI by removing scanner frame view and stop activity indicator
                self.barcodeScannerFrameView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
                self.stopLoadingView()
                if self.searchController?.foods.count == 0 {
                    
                    // Specialized alert controller that calls captureSession.startRunning() in the completion block
                    self.createAndDisplayAlertControllerAndStartCaptureSession(title: "No foods found", message: "We couldn't find any food matching this barcode. Please try again or search for this item manually.")
                } else {
                    self.barcodeSearchDelegate?.gotResultForFoodFromUPC()
                    self.dismiss(animated: true)
                }
            }
        }
    }
}


// MARK: - AVCapture Metadata Output Object Delegate

// Will inititiate a search by UPC automatically when barcode object is detected
extension BarcodeSearchViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        // Stop capture session to prevent multiple network calls prior to completion
        captureSession.stopRunning()
        
        // Displays activity indicator to user while a search is in progress
        startLoadingView()
        
        if let metadataObject = metadataObjects.first {
            
            // Interpret size of barcode on screen and set the scanner view box view to match that size
            let barcodeObject = self.cameraPreviewLayer?.transformedMetadataObject(for: metadataObject)
            barcodeScannerFrameView.frame = barcodeObject!.bounds
            
            // Convert metadata to a readable object and get string value to initiate a UPC search
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else {
                return
            }
            guard let stringValue = readableObject.stringValue else {
                return
            }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            searchForFoodByUPC(stringValue)
        }
    }
}
