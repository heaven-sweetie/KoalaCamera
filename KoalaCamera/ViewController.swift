//
//  ViewController.swift
//  KoalaCamera
//
//  Created by ParkSunJae on 26/11/2016.
//  Copyright © 2016 Koala. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var pickButton: UIButton = {
        var pickButton = UIButton()
        pickButton.translatesAutoresizingMaskIntoConstraints = false
        pickButton.setTitle("Pick", for: .normal)
        pickButton.backgroundColor = UIColor.magenta.withAlphaComponent(0.5)
        return pickButton
    }()

    var cameraView: UIView = {
        var cameraView = UIView()
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        return cameraView
    }()
    
    var previewLayer: AVCaptureVideoPreviewLayer?

//    UI Configuration
    func cameraViewConfigure() {
        view.addSubview(cameraView)

        NSLayoutConstraint.activate([cameraView.topAnchor.constraint(equalTo: view.topAnchor),
                                     cameraView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                     cameraView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     cameraView.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
    }

    func pickButtonConfigure() {
        view.addSubview(pickButton)

        NSLayoutConstraint.activate([pickButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                     pickButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     pickButton.widthAnchor.constraint(equalTo: view.widthAnchor),
                                     pickButton.heightAnchor.constraint(equalToConstant: 100)])
    }

//    CaptureSession Configuration
    func setupCaptureSession() {
        let captureSession = AVCaptureSession()
        if let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo), device.hasMediaType(AVMediaTypeVideo) {
            captureSession.sessionPreset = AVCaptureSessionPresetMedium
            do {
                let input = try AVCaptureDeviceInput(device: device)
                captureSession.addInput(input)
                let output = AVCaptureVideoDataOutput()
                captureSession.addOutput(output)
                
                let queue = DispatchQueue(label: "CameraOutputQueue")
                output.setSampleBufferDelegate(self, queue: queue)
            } catch let error {
                print(error)
            }
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            if let previewLayer = previewLayer {
                previewLayer.frame = self.cameraView.frame
                previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                self.cameraView.layer.addSublayer(previewLayer)
                captureSession.startRunning()
            }
        } else {
            print("Device hasn't media type")
        }
    }

    func updatePreviewConstraints() {
        if let previewLayer = previewLayer {
            previewLayer.frame = cameraView.frame
            if let videoOrientation = AVCaptureVideoOrientation(rawValue: UIDevice.current.orientation.rawValue) {
                previewLayer.connection.videoOrientation = videoOrientation
            }
        }
    }

//    Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraViewConfigure()
        pickButtonConfigure()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupCaptureSession()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updatePreviewConstraints()
    }
}

extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    public func captureOutput(_ captureOutput: AVCaptureOutput!,
                              didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        
    }
    
    public func captureOutput(_ captureOutput: AVCaptureOutput!,
                              didDrop sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        
    }
    
}
