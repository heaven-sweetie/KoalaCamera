//
//  Proto1Filter.swift
//  KoalaCamera
//
//  Created by KimYong Gyun on 4/12/2016.
//  Copyright © 2016 Koala. All rights reserved.
//

import Foundation
import Photos
import AVKit

class Proto1Filter: FilterBase {
    override func setup() {
        let b = calcDeviceBrightness()
        clamp = (
            CIVector(x: -1 * (b - 0.1) * (b - 0.1) + 0.13,
                     y: -1 * b * b + 0.13,
                     z: -1 * (b + 0.1) * (b + 0.1) + 0.13,
                     w: 0),
            CIVector(x: 1,
                     y: 1,
                     z: 1 - ( -1 * (b + 0.1) * (b + 0.1) + 0.13),
                     w: 1)
        )
    }
}
