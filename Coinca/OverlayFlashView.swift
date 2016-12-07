//
//  overlayFlashView.swift
//  KoalaCamera
//
//  Created by KimYong Gyun on 28/11/2016.
//  Copyright © 2016 Koala. All rights reserved.
//

import UIKit

class OverlayFlashView: UIView, FullScreenRepresentation {
    
    let flashColor = UIColor.white

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }

    func blink() {
        self.backgroundColor = flashColor.withAlphaComponent(1.0)
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = self.flashColor.withAlphaComponent(0)
        }
    }

    func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = flashColor.withAlphaComponent(0.0)
    }

}
