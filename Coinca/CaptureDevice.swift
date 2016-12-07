//
//  CaptureDevice.swift
//  KoalaCamera
//
//  Created by ParkHanul on 1/12/16.
//  Copyright © 2016 Koala. All rights reserved.
//

import AVFoundation

class CaptrueDeivce {
    private var backDevice: AVCaptureDevice!
    private var frontDevice: AVCaptureDevice!
    var currentDevice: AVCaptureDevice?
    var currentPosition: AVCaptureDevicePosition = .unspecified
    
    init() {
        initializeDevices()
        initializeDevicePosition()
    }
    
    private func initializeDevices() {
        let deviceTypes = [
                            AVCaptureDeviceType.builtInDuoCamera,
                            AVCaptureDeviceType.builtInTelephotoCamera,
                            AVCaptureDeviceType.builtInWideAngleCamera
                          ]
        
        backDevice = AVCaptureDeviceDiscoverySession(deviceTypes: deviceTypes,
                                                     mediaType: AVMediaTypeVideo,
                                                     position: AVCaptureDevicePosition.back).devices.first
        
        frontDevice = AVCaptureDeviceDiscoverySession(deviceTypes: deviceTypes,
                                                      mediaType: AVMediaTypeVideo,
                                                      position: AVCaptureDevicePosition.front).devices.first
    }
    
    private func initializeDevicePosition() {
        currentDevice = backDevice
    }
}
