//
//  ViewController.swift
//  KoalaCamera
//
//  Created by ParkSunJae on 26/11/2016.
//  Copyright © 2016 Koala. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class ViewController: UIViewController, CameraAuthorizationTrait, PhotoAuthorizationTrait {
    
    var layoutManager: LayoutManager!
    
    var pickButton = PickButton()
    var overlayFlashView = OverlayFlashView()
    var cameraView = CameraView()
    
    var notAuthorizedView = NotAuthorizedView()

    //    UI Configuration
    func pickButtonConfigure() {
        pickButton.addTarget(self, action: #selector(tappedPickButton(sender:)), for: .touchUpInside)
    }
    
    //    Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.applicationDidBecomeActive(notification:)),
                                               name: NSNotification.Name.UIApplicationDidBecomeActive,
                                               object: nil)
        setupLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        layoutManager.viewDidLayoutSubviews()
    }

    //  Action
    public func tappedPickButton(sender: UIButton!) {
        print("Tapped")
        
        overlayFlashView.blink()
        cameraView.capturePhoto()
    }

    func applicationDidBecomeActive(notification: NSNotification) {
        updateLayout()
    }

    func setupLayout() {
        var layout: Layout!

        checkCameraAuthorization { authorized in
            if !authorized {
                layout = NotAuthorizedLayout(self.view)
            }
        }

        checkPhotoAuthorization { authorized in
            if layout == nil && !authorized {
                layout = NotAuthorizedLayout(self.view)
            }
        }

        if layout == nil {
            layout = DefaultLayout(self.view)
        }

        layoutManager = LayoutManager(layout: layout)

        layoutManager.add([cameraView, overlayFlashView, pickButton, notAuthorizedView])
        layoutManager.render()

        pickButtonConfigure()
    }
    
    func updateLayout() {
        var layout: Layout!

        checkCameraAuthorization { authorized in
            if !authorized {
                layout = NotAuthorizedLayout(self.view)
            }
        }

        checkPhotoAuthorization { authorized in
            if layout == nil && !authorized {
                layout = NotAuthorizedLayout(self.view)
            }
        }

        if layout == nil {
            layout = DefaultLayout(self.view)
        }

        layoutManager.updateLayout(layout: layout)
    }
}
