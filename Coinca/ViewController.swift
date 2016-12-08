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
    
    var layoutManager: LayoutManager!
    
    var pickButton = PickButton()
    var filterButton = FilterButton()
    var overlayFlashView = OverlayFlashView()
    var cameraView = CameraView()
    
    var notAuthorizedView = NotAuthorizedView()

    var filterIndex: Int = 0
    var filterList = [
        ("😬", NoFilter()),
        ("🐨", KoalaFilter()),
        ("🤔", Proto1Filter()),
        ("🕵", Proto2Filter())
    ]
        as [(String, Filterable)]

    private var lastOrientation = UIDeviceOrientation.portrait
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    //    UI Configuration
    func pickButtonConfigure() {
        pickButton.addTarget(self, action: #selector(tappedPickButton(sender:)), for: .touchUpInside)
    }
    
    func filterButtonConfigure() {
        filterButton.addTarget(self, action: #selector(tappedFilterButton(sender:)), for: .touchUpInside)
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
        nextFilterIndex()
        setCurrentFilter()
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

        layoutManager.add([cameraView, overlayFlashView, pickButton, filterButton, notAuthorizedView])
        layoutManager.render()

        pickButtonConfigure()
        filterButtonConfigure()
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
        if let defaultIndex = UserDefaults.standard.value(forKey: "filter") as? Int {
            filterIndex = defaultIndex
        }
        setCurrentFilter()
    }

    func nextFilterIndex() {
        filterIndex += 1
        if filterIndex == filterList.count {
            filterIndex = 0
        }
        UserDefaults.standard.set(filterIndex, forKey: "filter")
    }

    func setCurrentFilter() {
        let filter = filterList[filterIndex]
        filterButton.setTitle(filter.0, for: .normal)
        cameraView.captureProcessor.filter = filter.1
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
