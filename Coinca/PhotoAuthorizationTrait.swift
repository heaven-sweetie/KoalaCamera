//
//  PhotoAuthorizationTrait.swift
//  KoalaCamera
//
//  Created by KimYong Gyun on 30/11/2016.
//  Copyright © 2016 Koala. All rights reserved.
//

import Photos

protocol PhotoAuthorizationTrait {
    func checkPhotoAuthorization(_ completionHandler: @escaping ((_ authorized: Bool) -> Void))
}

extension PhotoAuthorizationTrait {
    func checkPhotoAuthorization(_ completionHandler: @escaping ((_ authorized: Bool) -> Void)) {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            // The user has previously granted access to the photo library.
            completionHandler(true)

        case .notDetermined:
            // The user has not yet been presented with the option to grant photo library access so request access.
            PHPhotoLibrary.requestAuthorization({ status in
                completionHandler((status == .authorized))
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
