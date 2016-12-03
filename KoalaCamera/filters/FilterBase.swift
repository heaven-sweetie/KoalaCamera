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

class FilterBase : Filterable {
    let colorClamp : CIFilter! = CIFilter(name: "CIColorClamp")
    let colorControls : CIFilter! = CIFilter(name: "CIColorControls")
    let colorMatrix : CIFilter! = CIFilter(name: "CIColorMatrix")
    
    var clamp : (CIVector?, CIVector?) = (nil, nil)
    
    var saturation : NSNumber?
    var brightness : NSNumber?
    var contrast : NSNumber?
    
    var matrix: (CIVector?, CIVector?, CIVector?, CIVector?, CIVector?) = (nil, nil, nil, nil, nil)
    
    var image : CIImage!
    var device : AVCaptureDevice!
    
    var outputImage: CIImage? {
        setup()
        setupClampFilter()
        setupControlsFilter()
        setupMatrixFilter()
        return resultImage()
    }
    
    init(_ device: AVCaptureDevice) {
        self.device = device
    }
    
    func setup() {
        
    }
    
    func resultImage() -> CIImage? {
        colorClamp.setValue(image, forKey: kCIInputImageKey)
        colorControls.setValue(colorClamp.outputImage, forKey: kCIInputImageKey)
        colorMatrix.setValue(colorControls.outputImage, forKey: kCIInputImageKey)
        return colorMatrix.outputImage
    }
    
    func setImage(_ image: CIImage) {
        self.image = image
    }
    
    func setupClampFilter() {
        if let lowerLevel = clamp.0 {
            colorClamp.setValue(lowerLevel, forKey: "inputMinComponents")
        }
        if let upperLevel = clamp.1 {
            colorClamp.setValue(upperLevel, forKey: "inputMaxComponents")
        }
    }
    
    func setupControlsFilter() {
        if let saturation = saturation {
            colorControls.setValue(saturation, forKey: "inputSaturation")
        }
        if let brightness = brightness {
            colorControls.setValue(brightness, forKey: "inputBrightness")
        }
        if let contrast = contrast {
            colorControls.setValue(contrast, forKey: "inputContrast")
        }
    }
    
    func setupMatrixFilter() {
        if let vector = matrix.0 {
            colorMatrix.setValue(vector, forKey: "inputRVector")
        }
        if let vector = matrix.1 {
            colorMatrix.setValue(vector, forKey: "inputGVector")
        }
        if let vector = matrix.2 {
            colorMatrix.setValue(vector, forKey: "inputBVector")
        }
        if let vector = matrix.3 {
            colorMatrix.setValue(vector, forKey: "inputAVector")
        }
        if let vector = matrix.4 {
            colorMatrix.setValue(vector, forKey: "inputBiasVector")
        }
    }
    
    func calcDeviceExposure () -> CGFloat {
        let mExposure : CGFloat = 59977000 - 24000
        let exposure = (CGFloat) (device.exposureDuration.value - 24000)
        return exposure / mExposure
    }
    
    func calcDeviceIso () -> CGFloat {
        let mIso : CGFloat = 2177 - 34
        let iso = (CGFloat) (device.iso - 34)
        return iso / mIso
    }
    
    func calcDeviceBrightness() -> CGFloat {
        return calcDeviceExposure() * calcDeviceIso()
    }

    func calcDeviceWhiteBalanceGain() -> CGFloat {
        let t = device.temperatureAndTintValues(forDeviceWhiteBalanceGains: device.deviceWhiteBalanceGains)
        return CGFloat(t.temperature)
    }
}
