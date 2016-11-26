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
    
    var flashOverlayView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        return view
    }()

    var previewLayer: AVCaptureVideoPreviewLayer?
    var captureSession = AVCaptureSession()

//    UI Configuration
    func cameraViewConfigure() {
        view.addSubview(cameraView)

        NSLayoutConstraint.activate([cameraView.topAnchor.constraint(equalTo: view.topAnchor),
                                     cameraView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                     cameraView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     cameraView.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
    }

    func flashOverlayViewConfigure() {
        view.addSubview(flashOverlayView)

        NSLayoutConstraint.activate([flashOverlayView.topAnchor.constraint(equalTo: view.topAnchor),
                                     flashOverlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                     flashOverlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     flashOverlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
    }

    func pickButtonConfigure() {
        view.addSubview(pickButton)

        NSLayoutConstraint.activate([pickButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                     pickButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     pickButton.widthAnchor.constraint(equalTo: view.widthAnchor),
                                     pickButton.heightAnchor.constraint(equalToConstant: 100)])
        
        pickButton.addTarget(self, action: #selector(tappedPickButton(sender:)), for: UIControlEvents.touchUpInside)
    }

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
        flashOverlayViewConfigure()
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

extension ViewController {
    public func blinkScreen() {
        flashOverlayView.backgroundColor = flashOverlayView.backgroundColor?.withAlphaComponent(1.0)
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.flashOverlayView.backgroundColor = self.flashOverlayView.backgroundColor?.withAlphaComponent(0.0)
        })
    }
}

extension ViewController : AVCapturePhotoCaptureDelegate {

    public func tappedPickButton(sender: UIButton!) {
        print("Tapped")
        blinkScreen()
        capturePhoto()
    }

    public func capturePhoto() {
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
            photoOutput.capturePhoto(with: settings, delegate: self)
        }
    }
    
    // swiftlint:disable function_parameter_count
    func capture(_ captureOutput: AVCapturePhotoOutput,
                 didFinishProcessingPhotoSampleBuffer
                 photoSampleBuffer: CMSampleBuffer?,
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

    // swiftlint:disable line_length
    // https://developer.apple.com/library/prerelease/content/documentation/AudioVideo/Conceptual/PhotoCaptureGuide/index.html#//apple_ref/doc/uid/TP40017511-CH1-DontLinkElementID_19
    func capture(_ captureOutput: AVCapturePhotoOutput,
                 didFinishCaptureForResolvedSettings
                 resolvedSettings: AVCaptureResolvedPhotoSettings,
                 error: Error?) {

        guard error == nil else {
            print("Error in capture process: \(error)")
            return
        }

        if let photoSampleBuffer = self.photoSampleBuffer {
            saveSampleBufferToPhotoLibrary(photoSampleBuffer,
                                           previewSampleBuffer: self.previewPhotoSampleBuffer,
                                           completionHandler: { success, error in
                                            if success {
                                                print("Added JPEG photo to library.")
                                            } else {
                                                print("Error adding JPEG photo to library: \(error)")
                                            }
            })
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
