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
    var imageView : UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    func setupPreview() {
        guard let previewLayer = captureProcessor.previewLayer else {
            fatalError()
        }
        
        previewLayer.frame = frame
        // layer.addSublayer(previewLayer)
        self.addSubview(imageView)
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        setupImageView()
        self.previewLayer = previewLayer
        
        captureProcessor.superview = imageView
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

    // FIXME:
    func setupImageView() {
        NSLayoutConstraint.activate([topAnchor.constraint(equalTo: imageView.topAnchor),
                                     bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
                                     leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
                                     trailingAnchor.constraint(equalTo: imageView.trailingAnchor)])
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
