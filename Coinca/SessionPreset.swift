//
//  PhotoPresetBuilder.swift
//  KoalaCamera
//
//  Created by ParkHanul on 1/12/16.
//  Copyright © 2016 Koala. All rights reserved.
//

import AVFoundation

enum SessionPreset {
    case photo
    case high
    case medium
    case low
    case res352x288
    case res640x480
    case res1280x720
    case res1920x1080
    case res3840x2160
    case frame960x540
    case frame1280x720
    
    var preset: String {
        switch self {
        case .photo: return AVCaptureSessionPresetPhoto
        case .high: return AVCaptureSessionPresetHigh
        case .medium: return AVCaptureSessionPresetMedium
        case .low: return AVCaptureSessionPresetLow
        case .res352x288: return AVCaptureSessionPreset352x288
        case .res640x480: return AVCaptureSessionPreset640x480
        case .res1280x720: return AVCaptureSessionPreset1280x720
        case .res1920x1080: return AVCaptureSessionPreset1920x1080
        case .res3840x2160: return AVCaptureSessionPreset3840x2160
        case .frame960x540: return AVCaptureSessionPresetiFrame960x540
        case .frame1280x720: return AVCaptureSessionPresetiFrame1280x720
        }
    }
}
