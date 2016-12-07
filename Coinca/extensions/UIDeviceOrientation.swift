//
//  UIDeviceOrientation.swift
//  Coinca
//
//  Created by ParkHanul on 6/12/16.
//  Copyright © 2016 Koala. All rights reserved.
//

import Foundation
import UIKit

extension UIDeviceOrientation {
    var orientationAngle: Float32 {
        switch UIDevice.current.orientation {
        case .landscapeLeft:
            return 90.0 * Float(M_PI) / 180.0
        case .landscapeRight:
            return -90.0 * Float(M_PI) / 180.0
        default:
            return 0.0
        }
    }
}
