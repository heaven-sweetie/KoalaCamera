//
//  NotAuthorizedView.swift
//  KoalaCamera
//
//  Created by KimYong Gyun on 30/11/2016.
//  Copyright © 2016 Koala. All rights reserved.
//

import UIKit

class NotAuthorizedView: UIView, FullScreenRepresentation {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }

    func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.red
    }
    
}
