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

class CapturePhotoProcessor: NSObject, AVCapturePhotoCaptureDelegate {
    
    var photoSampleBuffer: CMSampleBuffer?
    var previewPhotoSampleBuffer: CMSampleBuffer?
    
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
