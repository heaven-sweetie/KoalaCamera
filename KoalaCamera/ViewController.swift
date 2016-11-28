//
//  ViewController.swift
//  KoalaCamera
//
//  Created by ParkSunJae on 26/11/2016.
//  Copyright © 2016 Koala. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class ViewController: UIViewController {
    
    var photoSampleBuffer: CMSampleBuffer?
    var previewPhotoSampleBuffer: CMSampleBuffer?

    var layout : Layout!
    var layoutManager : LayoutManager!
    
    var pickButton = PickButton()
    var overlayFlashView = OverlayFlashView()
    var cameraView: CameraView = {
        var cameraView = CameraView()
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        return cameraView
    }()

    //    UI Configuration
    func pickButtonConfigure() {
        pickButton.addTarget(self, action: #selector(tappedPickButton(sender:)), for: .touchUpInside)
    }
    
    //    Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        layout = DefaultLayout(view)
        layoutManager = LayoutManager(layout: layout)

        layoutManager.add([cameraView, overlayFlashView, pickButton])
        layoutManager.render()

        pickButtonConfigure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutManager.viewDidLayoutSubviews()
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

extension ViewController : AVCapturePhotoCaptureDelegate {
    
    public func tappedPickButton(sender: UIButton!) {
        print("Tapped")
        overlayFlashView.blink()
        cameraView.capturePhoto(delegate: self)
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
