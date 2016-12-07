//
//  CameraAuthorizationTrait.swift
//  Coinca
//
//  Created by KimYong Gyun on 30/11/2016.
//  Copyright © 2016 Koala. All rights reserved.
//

import AVFoundation

protocol CameraAuthorizationTrait {
    func checkCameraAuthorization(_ completionHandler: @escaping ((_ authorized: Bool) -> Void))
}

extension CameraAuthorizationTrait {
    func checkCameraAuthorization(_ completionHandler: @escaping ((_ authorized: Bool) -> Void)) {
        switch AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) {
        case .authorized:
            //The user has previously granted access to the camera.
            completionHandler(true)
            
        case .notDetermined:
            // The user has not yet been presented with the option to grant video access so request access.
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { success in
                completionHandler(success)
            })
            
        case .denied:
            // The user has previously denied access.
            completionHandler(false)
            
        case .restricted:
            // The user doesn't have the authority to request access e.g. parental restriction.
            completionHandler(false)
        }
    }
}
