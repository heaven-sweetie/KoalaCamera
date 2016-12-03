//
//  PickButton.swift
//  KoalaCamera
//
//  Created by KimYong Gyun on 28/11/2016.
//  Copyright © 2016 Koala. All rights reserved.
//

import UIKit

class PickButton: UIButton {
    
    let title = "📸"
    let bgcolor = UIColor(red: 0.17, green: 0.17, blue: 0.17, alpha: 1)

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configure()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }

    func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = bgcolor
        setTitle(title, for: .normal)
    }
    
}

extension PickButton: ViewRepresentation {
    
    func activateConstraint(in view: UIView) {
        let height: CGFloat = 100
        NSLayoutConstraint.activate([bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                     centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     widthAnchor.constraint(equalTo: view.widthAnchor),
                                     heightAnchor.constraint(equalToConstant: height)])
    }
    
}
