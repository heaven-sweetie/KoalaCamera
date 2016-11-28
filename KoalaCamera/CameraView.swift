//
//  CameraView.swift
//  KoalaCamera
//
//  Created by ParkSunJae on 28/11/2016.
//  Copyright © 2016 Koala. All rights reserved.
//

import UIKit
import AVFoundation

class CameraView: UIView {
    
    var captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?

    //    CaptureSession Configuration
    func setupCaptureSession() {
        if let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo), device.hasMediaType(AVMediaTypeVideo) {
            captureSession.sessionPreset = AVCaptureSessionPresetHigh
            do {
                let input = try AVCaptureDeviceInput(device: device)
                captureSession.addInput(input)
                let output = AVCapturePhotoOutput()
                captureSession.addOutput(output)
            } catch let error {
                print(error)
            }
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            if let previewLayer = previewLayer {
                previewLayer.frame = frame
                previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                layer.addSublayer(previewLayer)
                captureSession.startRunning()
            }
        } else {
            print("Device hasn't media type")
        }
    }
    
    func updatePreviewConstraints() {
        if let previewLayer = previewLayer {
            previewLayer.frame = frame
            if let videoOrientation = AVCaptureVideoOrientation(rawValue: UIDevice.current.orientation.rawValue) {
                previewLayer.connection.videoOrientation = videoOrientation
            }
        }
    }
    
    public func capturePhoto(delegate: AVCapturePhotoCaptureDelegate) {
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
                             kCVPixelBufferWidthKey as String: 512,
                             kCVPixelBufferHeightKey as String: 512,
                             ]
        
        settings.isHighResolutionPhotoEnabled = false
        settings.isAutoStillImageStabilizationEnabled = false
        settings.previewPhotoFormat = previewFormat
        
        if let photoOutput = captureSession.outputs.first as? AVCapturePhotoOutput {
            photoOutput.capturePhoto(with: settings, delegate: delegate)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupCaptureSession()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCaptureSession()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setupCaptureSession()
    }
}
