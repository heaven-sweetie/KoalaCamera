//
//  DefaultLayout.swift
//  KoalaCamera
//
//  Created by KimYong Gyun on 28/11/2016.
//  Copyright © 2016 Koala. All rights reserved.
//

import UIKit
import AVFoundation

class DefaultLayout : Layout {

    var view : UIView!

    init(_ view: UIView) {
        self.view = view
    }

    func render(_ elements: [UIView]) {
        
        for element in elements {
            if element is CameraView || element is OverlayFlashView {
                view.addSubview(element)
                fullScreenConstraint(element)
            }
            else if element is PickButton {
                view.addSubview(element)
                pickButtonConstraint(element)
            }
        }
    }

    func viewDidLayoutSubviews(_ elements: [UIView]) {
        for element in elements {
            if element is CameraView {
                updateCameraViewPreviewOrientation(element)
            }
        }
    }
    
    func fullScreenConstraint (_ element: UIView) {
        NSLayoutConstraint.activate([element.topAnchor.constraint(equalTo: view.topAnchor),
                                     element.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                     element.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     element.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
    }
    
    func pickButtonConstraint (_ element: UIView) {
        let height: CGFloat = 100
        NSLayoutConstraint.activate([element.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                     element.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     element.widthAnchor.constraint(equalTo: view.widthAnchor),
                                     element.heightAnchor.constraint(equalToConstant: height)])

    }

    func updateCameraViewPreviewOrientation(_ element: UIView) {
        if let cameraView = element as? CameraView {
            if let previewLayer = cameraView.previewLayer {
                previewLayer.frame = cameraView.frame
                if let videoOrientation = AVCaptureVideoOrientation(rawValue: UIDevice.current.orientation.rawValue) {
                    previewLayer.connection.videoOrientation = videoOrientation
                }
            }
        }
    }
}
