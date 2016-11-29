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
    }
    
    func render(_ elements: [UIView]) {
        for element in elements {
            view.addSubview(element)
            if let element = element as? ViewRepresentation {
                element.activateConstraint(in: view)
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
