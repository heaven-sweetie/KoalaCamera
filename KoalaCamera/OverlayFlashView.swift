//
//  overlayFlashView.swift
//  KoalaCamera
//
//  Created by KimYong Gyun on 28/11/2016.
//  Copyright © 2016 Koala. All rights reserved.
//

import UIKit

class OverlayFlashView : UIView {
    let flashColor = UIColor.white

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }

    func blink() {
        self.backgroundColor = self.flashColor.withAlphaComponent(1.0)
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = self.flashColor.withAlphaComponent(0)
        }
    }

    func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = self.flashColor.withAlphaComponent(0.0)
    }

    func addAsSubview(view: UIView) {
        view.addSubview(self)
        NSLayoutConstraint.activate([self.topAnchor.constraint(equalTo: view.topAnchor),
                                     self.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                     self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     self.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
    }
}
