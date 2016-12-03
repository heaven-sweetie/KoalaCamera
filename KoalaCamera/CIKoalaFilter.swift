//
//  CIKoalaFilter.swift
//  KoalaCamera
//
//  Created by KimYong Gyun on 3/12/2016.
//  Copyright © 2016 Koala. All rights reserved.
//

import Foundation
import Photos
import AVKit

class CIKoalaFilter : CIFilterBase {
    override func setup() {
        clamp = (
            CIVector(x: 0.1 * calcDeviceBrightness(),
                     y: 0,
                     z: 0.1 * (1 - calcDeviceBrightness()),
                     w: 0),
            CIVector(x: 1 - 0.1 * calcDeviceBrightness(),
                     y: 1 - (0.1 * calcDeviceBrightness() * calcDeviceBrightness()),
                     z: 1,
                     w: 1)
        )
        saturation = (0.01 * calcDeviceBrightness() + 1) as NSNumber?
        brightness = (0.07 * calcDeviceBrightness() * calcDeviceBrightness()) as NSNumber?
        contrast = (1 - 0.05 * calcDeviceBrightness()) as NSNumber?
    }
}
