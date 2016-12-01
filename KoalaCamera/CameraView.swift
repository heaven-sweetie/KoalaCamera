//
//  CameraView.swift
//  KoalaCamera
//
//  Created by ParkSunJae on 28/11/2016.
//  Copyright © 2016 Koala. All rights reserved.
//

import UIKit
import AVFoundation

class CameraView: UIView, FullScreenRepresentation {
    
    let captureProcessor = CapturePhotoProcessor()
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    func setupPreview() {
        guard let previewLayer = captureProcessor.previewLayer else {
            fatalError()
        }
        
        previewLayer.frame = frame
        layer.addSublayer(previewLayer)
        
        self.previewLayer = previewLayer
        
        captureProcessor.startRunning()
    }
    
    func initAuthorizeFailedCameraView() {
        print("Permission to use camera denied!")
    }

    public func capturePhoto() {
        captureProcessor.capture()
    }

    func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        configure()
        setupPreview()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
        setupPreview()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        configure()
        setupPreview()
    }
    
}
