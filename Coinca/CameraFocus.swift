//
//  CameraFocus.swift
//  Coinca
//
//  Created by ParkHanul on 1/12/16.
//  Copyright © 2016 Koala. All rights reserved.
//

import AVFoundation

public enum CameraFocus {
    case locked
    case autoFocus
    case continuousAutoFocus
    
    var focus: AVCaptureFocusMode {
        switch self {
        case .locked: return AVCaptureFocusMode.locked
        case .autoFocus: return AVCaptureFocusMode.autoFocus
        case .continuousAutoFocus: return AVCaptureFocusMode.continuousAutoFocus
        }
    }
    
    var description: String {
        switch self {
        case .locked: return "Locked"
        case .autoFocus: return "AutoFocus"
        case .continuousAutoFocus: return "ContinuousAutoFocus"
        }
    }
}
