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
import CoreImage

class LSLBarcodeSearchViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    var backCamera: AVCaptureDevice?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var captureOutput: AVCapturePhotoOutput?
    var captureSession: AVCaptureSession!
    
    var shutterButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkPermissions()
        setUpCameraLiveView()
        addShutterButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Ensure we have access to the camera each time the user accesses the view in order to prevent app from crashing
        checkPermissions()
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
    
    private func setUpCameraLiveView() {
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
        
        // Ensure the camera is a back camera on this particular iPhone
        guard let backCamera = backCamera else {
            createAndDisplayAlertController(title: "Camera error", message: "We couldn't find a camera to use on your device")
            return
        }
        
        // Establish input stream
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: backCamera)
            self.captureSession.addInput(captureDeviceInput)
        } catch {
            createAndDisplayAlertController(title: "Camera error", message: "This camera cannot be used to scan food items")
            return
        }
        
        // Initialize the capture ouput and add to capture session
        self.captureOutput = AVCapturePhotoOutput()
        captureOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])],
                                                     completionHandler: nil)
        
        guard let captureOutput = captureOutput else {
            createAndDisplayAlertController(title: "Camera error", message: "There was an error generating an image from your camera's output")
            return
        }
        self.captureSession.addOutput(captureOutput)
        
        // Add a preview layer for session
        self.cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = .resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = .portrait
        cameraPreviewLayer?.frame = view.frame
        
        guard let previewLayer = cameraPreviewLayer else {
            createAndDisplayAlertController(title: "Camera error", message: "A preview couldn't be genrated for your device's camera")
            return
        }
        self.view.layer.insertSublayer(previewLayer, at: 0)
        
        // Start the capture session
        self.captureSession.startRunning()
    }
    
    
    // MARK: - AVCapture Output and Image Processsing
    
    @objc func captureOutputImage() {
        let settings = AVCapturePhotoSettings()
        self.captureOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) {
            // Vision framework expects a CI Image, so we need to first convert UIImage to CIImage
            guard let ciImage = CIImage(image: image) else {
                createAndDisplayAlertController(title: "Scanner error", message: "We were unable to process this barcode, please try again.")
                return
            }
            
            // perform the request using the CIImage on background thread to ensure app performance
            DispatchQueue.global(qos: .userInitiated).async {
                let handler = VNImageRequestHandler(ciImage: ciImage,
                                                    orientation: .up)
                
                do {
                    try handler.perform([self.detectBarcodeRequest])
                } catch {
                    // TODO: Once development of this feature is complete, change this error to be more user friendly for end user
                    self.createAndDisplayAlertController(title: "Error decoding barcode", message: "\(error.localizedDescription)")
                }
            }
        }
    }
    
    
    // MARK: - Helper Functions
    
    @objc private func openSettings() {
        let settingsURL = URL(string: UIApplication.openSettingsURLString)!
        UIApplication.shared.open(settingsURL) { (_) in
            self.checkPermissions()
        }
    }
    
    
    // MARK: - User Interface Functionality
    
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
    
    private func addShutterButton() {
        let width: CGFloat = 75
        let height = width
        self.shutterButton = UIButton(frame: CGRect(x: (view.frame.width - width) / 2,
                                               y: view.frame.height - height - 32,
                                               width: width,
                                               height: height
            )
        )
        self.shutterButton.layer.cornerRadius = width / 2
        self.shutterButton.backgroundColor = UIColor.init(displayP3Red: 1, green: 1, blue: 1, alpha: 0.8)
        self.shutterButton.showsTouchWhenHighlighted = true
        self.shutterButton.addTarget(self, action: #selector(captureOutputImage), for: .touchUpInside)
        view.addSubview(shutterButton)
    }

    
    
    // MARK: - Alert Controllers
    
    private func createAndDisplayAlertController(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - Vision Framework Methods
    
    lazy var detectBarcodeRequest: VNDetectBarcodesRequest = {
        return VNDetectBarcodesRequest { (request, error) in
           if let error = error {
                // TODO: Once development of this feature is complete, change this error to be more user friendly for end user
                self.createAndDisplayAlertController(title: "Barcode error", message: "\(error.localizedDescription)")
                return
            }
            
            self.processClassification(for: request)
        }
    }()
    
    func processClassification(for request: VNRequest) {
        // Switch back to main thread once Vision receives request in order to extract the payload
        DispatchQueue.main.async {
            if let bestResult = request.results?.first as? VNBarcodeObservation,
                let payload = bestResult.payloadStringValue {
                // This is where we will get the barcodes information, to then be able to search the edama API
                // for now we will just present it as an alert
                self.createAndDisplayAlertController(title: "Barcode Result", message: payload)
            } else {
                self.createAndDisplayAlertController(title: "Couldn't get barcode", message: "We were unable to extract barcode information from the data")
            }
        }
    }

}