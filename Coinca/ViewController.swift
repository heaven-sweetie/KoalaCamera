//
//  ViewController.swift
//  Coinca
//
//  Created by ParkSunJae on 26/11/2016.
//  Copyright © 2016 Koala. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class ViewController: UIViewController, CameraAuthorizationTrait, PhotoAuthorizationTrait {
    
    var filterManager: FilterManager!
    var layoutManager: LayoutManager!
    
    var pickButton = PickButton()
    var filterButton = FilterButton()
    var overlayFlashView = OverlayFlashView()
    var cameraView = CameraView()
    var cameraSwitchButton = CameraSwitchButton()
    
    var notAuthorizedView = NotAuthorizedView()

    private var lastOrientation = UIDeviceOrientation.portrait
    private var currentDevicePosition = Device.back
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    private let sessionQueue = DispatchQueue(label: "SessionQueue", attributes: [], target: nil) // Communicate with the session and other session objects on this queue.
    
    //    UI Configuration
    func pickButtonConfigure() {
        pickButton.addTarget(self, action: #selector(tappedPickButton(sender:)), for: .touchUpInside)
    }
    
    func filterButtonConfigure() {
        filterButton.addTarget(self, action: #selector(tappedFilterButton(sender:)), for: .touchUpInside)
    }
    
    func switchCameraButtonConfigure() {
        cameraSwitchButton.addTarget(self, action: #selector(changeCamera), for: .touchUpInside)
    }

    //    Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.applicationDidBecomeActive(notification:)),
                                               name: NSNotification.Name.UIApplicationDidBecomeActive,
                                               object: nil)
        setupLayout()
        setupFilter()
        
        cameraView.setupPreview(frame: self.view.frame)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        layoutManager.viewDidLayoutSubviews()
    }

    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(orientationChanged),
                                               name: NSNotification.Name.UIDeviceOrientationDidChange,
                                               object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    //  Action
    public func tappedPickButton(sender: UIButton!) {
        print("Pick Tapped")
        
        overlayFlashView.blink()
        cameraView.capturePhoto()
    }

    public func tappedFilterButton(sender: UIButton!) {
        print("Filter Tapped")
        
        filterManager.next()
    }
    
    func changeCamera() {
        pickButton.isEnabled = false
        filterButton.isEnabled = false
        cameraSwitchButton.isEnabled = false
        
        sessionQueue.async { [unowned self] in
            let position: Device = {
                if self.currentDevicePosition == .back {
                    return .front
                } else {
                    return .back
                }
            }()
            
            self.cameraView.captureProcessor.switchDevice(position: position) { device in
                self.currentDevicePosition = device
            }
            
            DispatchQueue.main.async { [unowned self] in
                self.pickButton.isEnabled = true
                self.filterButton.isEnabled = true
                self.cameraSwitchButton.isEnabled = true
            }
        }
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

        layoutManager.add([cameraView, overlayFlashView, pickButton, filterButton, cameraSwitchButton, notAuthorizedView])
        layoutManager.render()

        pickButtonConfigure()
        filterButtonConfigure()
        switchCameraButtonConfigure()
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
    
    func setupFilter() {
        filterManager = FilterManager()
        filterManager.changedCurrentFilter = updateCurrentFilter
        
        updateCurrentFilter(name: filterManager.current.0, filter: filterManager.current.1)
    }
    
    func updateCurrentFilter(name: String, filter: Filterable) {
        filterButton.setTitle(name, for: .normal)
        cameraView.captureProcessor.filter = filter
    }
    
// MARK: - Device Orientation
    
    func orientationChanged() {
        if lastOrientation == UIDevice.current.orientation {
            return
        }
        
        lastOrientation = UIDevice.current.orientation
        
        let transform = CGAffineTransform(rotationAngle: CGFloat(lastOrientation.orientationAngle))
        
        UIView.beginAnimations("rotateView", context: nil)
        UIView.setAnimationCurve(.easeOut)
        UIView.setAnimationDuration(0.35)
        
        pickButton.titleLabel?.transform = transform
        filterButton.titleLabel?.transform = transform
        
        UIView.commitAnimations()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
