//
//  CameraView.swift
//  KoalaCamera
//
//  Created by ParkSunJae on 28/11/2016.
//  Copyright © 2016 Koala. All rights reserved.
//

import UIKit
import AVFoundation
import GLKit

class CameraView: UIView, FullScreenRepresentation {

    let captureProcessor = CapturePhotoProcessor()

    var glRenderer: GLRenderer?

    // swiftlint:disable force_cast
    var previewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }

    func setupPreview(frame: CGRect) {
        self.previewLayer.session = captureProcessor.session
        glRenderer = GLRenderer(frame: frame, superview: self)

        setupImageView()
        captureProcessor.superview = glRenderer
        captureProcessor.startRunning()
    }

    var session: AVCaptureSession? {
        get {
            return previewLayer.session
        }
        set {
            previewLayer.session = newValue
        }
    }

    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }

    func initAuthorizeFailedCameraView() {
        print("Permission to use camera denied!")
    }

    public func capturePhoto() {
        captureProcessor.capture()
    }

    func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.black
    }

    // FIXME:
    func setupImageView() {
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    static func preferredCIImageTransformFrom(uiimage: UIImage) -> CGAffineTransform {
        if uiimage.imageOrientation == .up {
            return CGAffineTransform.identity
        }

        var transform = CGAffineTransform.identity;
        switch uiimage.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: uiimage.size.width, y: uiimage.size.height)
            transform = transform.rotated(by: CGFloat(M_PI))

        case .left, .leftMirrored:
            transform = transform.translatedBy(x: uiimage.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(M_PI_2))

        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: uiimage.size.height)
            transform = transform.rotated(by: CGFloat(-M_PI_2))
        //case .up, .upMirrored:
        default:
            break
        }

        switch uiimage.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: uiimage.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)

        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: uiimage.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)

        //case .up, .down, .left, .right:
        default:
            break
        }

        return transform
    }
}
