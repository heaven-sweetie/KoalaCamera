//
//  FilterButton.swift
//  Coinca
//
//  Created by KimYong Gyun on 4/12/2016.
//  Copyright © 2016 Koala. All rights reserved.
//

import UIKit

class FilterButton: UIButton {

    let title = "🎞"
    let bgcolor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)

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

extension FilterButton: ViewRepresentation {
    func activateConstraint(in view: UIView) {
        let size: CGFloat = 100
        NSLayoutConstraint.activate([bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                     rightAnchor.constraint(equalTo: view.rightAnchor),
                                     widthAnchor.constraint(equalToConstant: size),
                                     heightAnchor.constraint(equalToConstant: size)])
    }
}
