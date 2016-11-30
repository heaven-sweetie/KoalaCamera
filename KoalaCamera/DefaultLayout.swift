//
//  DefaultLayout.swift
//  KoalaCamera
//
//  Created by KimYong Gyun on 28/11/2016.
//  Copyright © 2016 Koala. All rights reserved.
//

import UIKit
import AVFoundation

struct DefaultLayout: Layout {
    
    var view: UIView!
    
    init(_ view: UIView) {
        self.view = view
        print("DefaultLayout")
    }
    
    func render(_ elements: [UIView]) {
        for element in elements {
            if element is NotAuthorizedView {
                // @FIXME
                // Do nothing
            } else if let vrElement = element as? ViewRepresentation {
                view.addSubview(element)
                vrElement.activateConstraint(in: view)
            }
        }
    }
    
    func viewDidLayoutSubviews(_ elements: [UIView]) {
        for element in elements where element is CameraView {
            updateCameraViewPreviewOrientation(element)
        }
    }
    
    func updateCameraViewPreviewOrientation(_ element: UIView) {
        if let cameraView = element as? CameraView, let previewLayer = cameraView.previewLayer {
            previewLayer.frame = cameraView.frame
            if let videoOrientation = AVCaptureVideoOrientation(rawValue: UIDevice.current.orientation.rawValue) {
                previewLayer.connection.videoOrientation = videoOrientation
            }
        }
    }
    
}
