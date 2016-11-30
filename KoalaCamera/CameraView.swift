//
//  CameraView.swift
//  KoalaCamera
//
//  Created by ParkSunJae on 28/11/2016.
//  Copyright © 2016 Koala. All rights reserved.
//

import UIKit
import AVFoundation

class CameraView: UIView, FullScreenRepresentation {
    
    var captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    let capturePhotoProcessor = CapturePhotoProcessor()

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
            
            if let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) {
                previewLayer.frame = frame
                previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                layer.addSublayer(previewLayer)
                captureSession.startRunning()
                
                self.previewLayer = previewLayer
            }
        } else {
            print("Device hasn't media type")
        }
    }
    
    func initAuthorizeFailedCameraView() {
        print("Permission to use camera denied!")
    }

    public func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        
        var previewFormat = [kCVPixelBufferWidthKey as String: 512,
                             kCVPixelBufferHeightKey as String: 512]
        if let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first {
            previewFormat[kCVPixelBufferPixelFormatTypeKey as String] = previewPixelType.intValue
        }
        
        settings.isHighResolutionPhotoEnabled = false
        settings.isAutoStillImageStabilizationEnabled = false
        settings.previewPhotoFormat = previewFormat
        
        if let photoOutput = captureSession.outputs.first as? AVCapturePhotoOutput {
            photoOutput.capturePhoto(with: settings, delegate: capturePhotoProcessor)
        }
    }

    func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        configure()
        setupCaptureSession()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
        setupCaptureSession()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        configure()
        setupCaptureSession()
    }
    
}
