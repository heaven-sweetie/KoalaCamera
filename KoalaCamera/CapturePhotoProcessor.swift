//
//  CapturePhotoDelegate.swift
//  KoalaCamera
//
//  Created by ParkSunJae on 29/11/2016.
//  Copyright © 2016 Koala. All rights reserved.
//

import Foundation
import AVFoundation
import Photos

class CapturePhotoProcessor: NSObject {
    
    let session = AVCaptureSession()
    
    var photoSampleBuffer: CMSampleBuffer?
    var previewPhotoSampleBuffer: CMSampleBuffer?
    
    override init() {
        super.init()
        
        setupCaptureSession()
    }
    
    var previewLayer: AVCaptureVideoPreviewLayer? {
        if let layer = AVCaptureVideoPreviewLayer(session: session) {
            layer.videoGravity = AVLayerVideoGravityResizeAspectFill
            return layer
        } else {
            return nil
        }
    }
    
    //    CaptureSession Configuration
    func setupCaptureSession() {
        if let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo), device.hasMediaType(AVMediaTypeVideo) {
            session.sessionPreset = AVCaptureSessionPresetHigh
            do {
                let input = try AVCaptureDeviceInput(device: device)
                session.addInput(input)
                let output = AVCapturePhotoOutput()
                session.addOutput(output)
            } catch let error {
                print(error)
            }
        } else {
            print("Device hasn't media type")
        }
    }
    
    func startRunning() {
        session.startRunning()
    }
    
    func stopRunning() {
        session.stopRunning()
    }
    
    private func setting() -> AVCapturePhotoSettings {
        let settings = AVCapturePhotoSettings()
        
        var previewFormat = [kCVPixelBufferWidthKey as String: 512,
                             kCVPixelBufferHeightKey as String: 512]
        if let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first {
            previewFormat[kCVPixelBufferPixelFormatTypeKey as String] = previewPixelType.intValue
        }
        
        settings.isHighResolutionPhotoEnabled = false
        settings.isAutoStillImageStabilizationEnabled = false
        settings.previewPhotoFormat = previewFormat
        
        return settings
    }
    
    func capture() {
        if let output = session.outputs.first as? AVCapturePhotoOutput {
            output.capturePhoto(with: self.setting(), delegate: self)
        }
    }
    
    func saveSampleBufferToPhotoLibrary(_ sampleBuffer: CMSampleBuffer,
                                        previewSampleBuffer: CMSampleBuffer?,
                                        completionHandler: ((_ success: Bool, _ error: Error?) -> Void)?) {
        guard let jpegData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(
            forJPEGSampleBuffer: sampleBuffer,
            previewPhotoSampleBuffer: previewSampleBuffer)
            else {
                print("Unable to create JPEG data.")
                completionHandler?(false, nil)
                return
        }
        
        PHPhotoLibrary.shared().performChanges({
            let creationRequest = PHAssetCreationRequest.forAsset()
            creationRequest.addResource(with: PHAssetResourceType.photo, data: jpegData, options: nil)
        }) { success, error in
            DispatchQueue.main.async {
                completionHandler?(success, error)
            }
        }
    }

}

extension CapturePhotoProcessor: AVCapturePhotoCaptureDelegate {
    
    func capture(_ captureOutput: AVCapturePhotoOutput,
                 didFinishCaptureForResolvedSettings resolvedSettings: AVCaptureResolvedPhotoSettings,
                 error: Error?) {
        guard error == nil else {
            print("Error in capture process: \(error)")
            return
        }
        
        if let photoSampleBuffer = self.photoSampleBuffer {
            saveSampleBufferToPhotoLibrary(photoSampleBuffer, previewSampleBuffer: self.previewPhotoSampleBuffer) {
                success, error in
                if success {
                    print("Added JPEG photo to library.")
                } else {
                    print("Error adding JPEG photo to library: \(error)")
                }
            }
        }
    }
    
    // swiftlint:disable function_parameter_count
    func capture(_ captureOutput: AVCapturePhotoOutput,
                 didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?,
                 previewPhotoSampleBuffer: CMSampleBuffer?,
                 resolvedSettings: AVCaptureResolvedPhotoSettings,
                 bracketSettings: AVCaptureBracketedStillImageSettings?,
                 error: Error?) {
        if let error = error {
            print(error.localizedDescription)
        }
        
        self.photoSampleBuffer = photoSampleBuffer
        self.previewPhotoSampleBuffer = previewPhotoSampleBuffer
    }
}
