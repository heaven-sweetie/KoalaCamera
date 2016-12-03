//
//  KoalaFilter.swift
//  KoalaCamera
//
//  Created by KimYong Gyun on 3/12/2016.
//  Copyright © 2016 Koala. All rights reserved.
//

import Foundation
import Photos
import AVKit

class KoalaFilter : FilterBase {
    override func setup() {
        let b = calcDeviceBrightness()
        clamp = (
            CIVector(x: 0.1 * b,
                     y: 0,
                     z: 0.1 * (1 - b),
                     w: 0),
            CIVector(x: 1 - 0.1 * b,
                     y: 1 - (0.1 * b * b),
                     z: 1,
                     w: 1)
        )
        saturation = (0.01 * b + 1) as NSNumber?
        brightness = (0.07 * b * b) as NSNumber?
        contrast = (1 - 0.05 * b) as NSNumber?
    }
}
