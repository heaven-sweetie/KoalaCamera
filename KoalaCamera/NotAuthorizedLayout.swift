//
//  NotAuthorizedLayout.swift
//  KoalaCamera
//
//  Created by KimYong Gyun on 30/11/2016.
//  Copyright © 2016 Koala. All rights reserved.
//

import UIKit
import AVFoundation

struct NotAuthorizedLayout: Layout {
    
    var view: UIView!
    
    init(_ view: UIView) {
        self.view = view
        print("NotAuthorizedLayout")
    }
    
    func render(_ elements: [UIView]) {
        for element in elements {
            if let element = element as? NotAuthorizedView {
                view.addSubview(element)
                element.activateConstraint(in: view)
            } else {
                element.removeFromSuperview()
            }
        }
    }
    
    func viewDidLayoutSubviews(_ elements: [UIView]) {
    }
}
