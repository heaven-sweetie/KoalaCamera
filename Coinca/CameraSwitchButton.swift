//
//  PreviewSwitchButton.swift
//  Coinca
//
//  Created by ParkHanul on 8/12/16.
//  Copyright © 2016 Koala. All rights reserved.
//

import UIKit

class CameraSwitchButton: UIButton {
    
    let title = "🔃"
    let bgcolor = UIColor.clear
    
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
        
        titleLabel?.numberOfLines = 0
        titleLabel?.lineBreakMode = .byWordWrapping
    }
}

extension CameraSwitchButton: ViewRepresentation {
    func activateConstraint(in view: UIView) {
        let size: CGFloat = 50
        NSLayoutConstraint.activate([topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
                                     rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
                                     widthAnchor.constraint(equalToConstant: size),
                                     heightAnchor.constraint(equalToConstant: size)])
    }
}
