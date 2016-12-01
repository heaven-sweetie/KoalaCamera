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
import UIKit

class CapturePhotoProcessor: NSObject {
    
    let session = AVCaptureSession()
    var superview : UIImageView!
    
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
                let videoOutput = AVCaptureVideoDataOutput()
                videoOutput.setSampleBufferDelegate(self,
                                                    queue: DispatchQueue(label: "sample buffer delegate"))
                session.addOutput(output)
                session.addOutput(videoOutput)

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
    
    private func setting(_ capturePhotoOutput: AVCapturePhotoOutput) -> AVCapturePhotoSettings {
        let pixelFormatType = NSNumber(value: kCVPixelFormatType_32BGRA)

        if !capturePhotoOutput.availablePhotoPixelFormatTypes.contains(pixelFormatType) {
            print("pixelFormatType not available")
        }

        let settings = AVCapturePhotoSettings(format: [
            kCVPixelBufferPixelFormatTypeKey as String : pixelFormatType
            ])

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
            output.capturePhoto(with: self.setting(output), delegate: self)
        }
    }
    
    func saveSampleBufferToPhotoLibrary(_ sampleBuffer: CMSampleBuffer,
                                        previewSampleBuffer: CMSampleBuffer?,
                                        completionHandler: ((_ success: Bool, _ error: Error?) -> Void)?) {

        guard let image = convertSampleBufferToUIImageWithFilter(sampleBuffer)
            else {
                print("Unable to apply the filter")
                completionHandler?(false, nil)
                return
        }

        guard let jpegData = UIImageJPEGRepresentation(image, 100)
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


extension CapturePhotoProcessor: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        if let image = convertSampleBufferToUIImageWithFilter(sampleBuffer) {
            DispatchQueue.main.async {
                self.superview.image = image
            }
        }
    }
}

extension CapturePhotoProcessor {
    func convertSampleBufferToUIImageWithFilter(_ sampleBuffer: CMSampleBuffer) -> UIImage? {

        guard let cvPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("sampleBuffer does not contain a CVPixelBuffer.")
            return nil
        }

        if let filter = CIFilter(name: "CICMYKHalftone") {
            let cameraImage = CIImage(cvPixelBuffer: cvPixelBuffer)

            filter.setValue(cameraImage, forKey: kCIInputImageKey)
            filter.setValue(5, forKey: kCIInputWidthKey)

            let softwareContext = CIContext(options:[kCIContextUseSoftwareRenderer: true])

            if let outputImage = filter.outputImage,
                let cgimg = softwareContext.createCGImage(outputImage, from: outputImage.extent) {
                // FIXME: Orientation is incorrect at the most of cases
                let filteredImage = UIImage(cgImage: cgimg, scale: 1.0, orientation: .right)
                return filteredImage
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
