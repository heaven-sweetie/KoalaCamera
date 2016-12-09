//
//  CaptureDevice.swift
//  Coinca
//
//  Created by ParkHanul on 1/12/16.
//  Copyright © 2016 Koala. All rights reserved.
//

import AVFoundation

enum Device {
    case back
    case front
}

class CaptrueDeivce {
    
    private var backDevice: AVCaptureDevice!
    private var frontDevice: AVCaptureDevice!
    
    var currentDevice: AVCaptureDevice!
    private var position: AVCaptureDevicePosition = .unspecified
    var currentPosition: Device {
        get {
            switch position {
            case .back:
                return .back
            case .front, .unspecified:
                return .front
            }
        }
    }
    
    init() {
        configureDefaultDevice()
        configureDevice()
    }
    
    private func configureDefaultDevice() {
        let defaultVideoDevice: AVCaptureDevice? = {
            if let dualCameraDevice = AVCaptureDevice.defaultDevice(withDeviceType: .builtInDuoCamera, mediaType: AVMediaTypeVideo, position: .back) {
                self.position = .back
                return dualCameraDevice
            } else if let backCameraDevice = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .back) {
                // If the back dual camera is not available, default to the back wide angle camera.
                self.position = .back
                return backCameraDevice
            } else if let frontCameraDevice = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .front) {
                // In some cases where users break their phones, the back wide angle camera is not available. In this case, we should default to the front wide angle camera.
                self.position = .front
                return frontCameraDevice
            } else {
                self.position = .unspecified
                return nil
            }
        }()
        
        guard let videoDevice = defaultVideoDevice else {
            return
        }
        
        currentDevice = videoDevice
    }
    
    private func configureDevice() {
        let deviceTypes = [
            AVCaptureDeviceType.builtInDuoCamera,
            AVCaptureDeviceType.builtInWideAngleCamera
        ]
        
        self.backDevice = AVCaptureDeviceDiscoverySession(deviceTypes: deviceTypes,
                                                          mediaType: AVMediaTypeVideo,
                                                          position: .back).devices.first
        
        self.frontDevice = AVCaptureDeviceDiscoverySession(deviceTypes: deviceTypes,
                                                           mediaType: AVMediaTypeVideo,
                                                           position: .front).devices.first
    }
    
    func switchDevice(devicePosition: Device) {
        switch devicePosition {
        case .back:
            position = .back
            currentDevice = backDevice
        case .front:
            position = .front
            currentDevice = frontDevice
        }
    }
}
