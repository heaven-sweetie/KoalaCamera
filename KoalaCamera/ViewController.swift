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

class ViewController: UIViewController {
    
    var layoutManager: LayoutManager!
    
    var pickButton = PickButton()
    var overlayFlashView = OverlayFlashView()
    var cameraView = CameraView()

    //    UI Configuration
    func pickButtonConfigure() {
        pickButton.addTarget(self, action: #selector(tappedPickButton(sender:)), for: .touchUpInside)
    }
    
    //    Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        layoutManager = LayoutManager(layout: DefaultLayout(view))

        layoutManager.add([cameraView, overlayFlashView, pickButton])
        layoutManager.render()

        pickButtonConfigure()
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
}
