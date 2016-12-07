//
//  Proto2Filter.swift
//  Coinca
//
//  Created by KimYong Gyun on 4/12/2016.
//  Copyright © 2016 Koala. All rights reserved.
//

import Foundation
import Photos
import AVKit

class Proto2Filter: FilterBase {
    override func setup() {
        let b = calcDeviceIso()
        saturation = (0.65 + 0.3 * (1 - b)) as NSNumber?
        contrast = (0.65 + 0.3 * (1 - b)) as NSNumber?
    }
}
