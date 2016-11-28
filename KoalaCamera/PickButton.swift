//
//  PickButton.swift
//  KoalaCamera
//
//  Created by KimYong Gyun on 28/11/2016.
//  Copyright © 2016 Koala. All rights reserved.
//

import UIKit

class PickButton : UIButton {
    let title = "Pick"
    let bgcolor = UIColor.magenta

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }

    func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = bgcolor.withAlphaComponent(0.5)
        self.setTitle(self.title, for: .normal)
    }
}
