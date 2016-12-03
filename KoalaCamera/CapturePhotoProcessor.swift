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
import GLKit

class CapturePhotoProcessor: NSObject {
    
    let session = AVCaptureSession()
    var superview : GLRenderer!
    
    var device : AVCaptureDevice?
    
    var photoSampleBuffer: CMSampleBuffer?
    var previewPhotoSampleBuffer: CMSampleBuffer?
    
    let mediaType = AVMediaTypeVideo
    let saveFileQueue = DispatchQueue(label: "save file")
    
    var filter : Filterable?
    
    override init() {
        super.init()
        
        setupCaptureSession()
    }
    
    //    CaptureSession Configuration
    func setupCaptureSession() {
        device = AVCaptureDevice.defaultDevice(withMediaType: mediaType)
        if let device = device, device.hasMediaType(mediaType) {
            session.sessionPreset = AVCaptureSessionPresetPhoto
            filter = NoFilter()
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

        saveFileQueue.async {
            guard let image = self.convertSampleBufferToUIImageWithFilter(sampleBuffer)
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
        if let image = convertSampleBufferToCIImageWithFilter(sampleBuffer) {
            DispatchQueue.main.async {
                self.superview?.renderImage(image: image)
            }
        }
    }
}

extension CapturePhotoProcessor {
    func convertSampleBufferToCIImageWithFilter(_ sampleBuffer: CMSampleBuffer) -> CIImage? {
        guard let cvPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("sampleBuffer does not contain a CVPixelBuffer.")
            return nil
        }
        
        if let filter = filter {
            let cameraImage = CIImage(cvPixelBuffer: cvPixelBuffer)
            filter.setImage(cameraImage)
            if let outputImage = filter.outputImage {
                return outputImage
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func convertSampleBufferToUIImageWithFilter(_ sampleBuffer: CMSampleBuffer) -> UIImage? {
        let softwareContext = CIContext(options:[kCIContextUseSoftwareRenderer: true])
        if let outputImage = convertSampleBufferToCIImageWithFilter(sampleBuffer),
           let cgimg = softwareContext.createCGImage(outputImage, from: outputImage.extent) {
            if let imageOrientation = UIDevice.current.imageOrientation {
                return UIImage(cgImage: cgimg, scale: 1.0, orientation: imageOrientation)
//            } else if let lastImageOrientation = superview.image?.imageOrientation {
//                return UIImage(cgImage: cgimg, scale: 1.0, orientation: lastImageOrientation)
            } else {
                return UIImage(cgImage: cgimg, scale: 1.0, orientation: .right)
            }
        }
        return nil
    }
}

extension UIDevice {
    
    var imageOrientation: UIImageOrientation? {
        switch self.orientation {
        case .portrait: return .right
//        case .portraitUpsideDown: return .right
        case .landscapeLeft: return .up
        case .landscapeRight: return .down
        default: return nil
        }
    }
    
}

extension CapturePhotoProcessor {
    func setFilter(_ filter: Filterable) {
        if filter is FilterDeviceNeeded, var filter = filter as? FilterDeviceNeeded {
            filter.device = device
        }
        self.filter = filter
        
    }
}
