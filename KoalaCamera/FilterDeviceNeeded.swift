//
//  FilterDeviceNeeded.swift
//  KoalaCamera
//
//  Created by KimYong Gyun on 4/12/2016.
//  Copyright © 2016 Koala. All rights reserved.
//

import Photos
import AVKit

protocol FilterDeviceNeeded {
    var device : AVCaptureDevice! { get set }
}
