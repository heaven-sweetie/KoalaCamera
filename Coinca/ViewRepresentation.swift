//
//  ViewRepresentation.swift
//  KoalaCamera
//
//  Created by ParkSunJae on 29/11/2016.
//  Copyright © 2016 Koala. All rights reserved.
//

import UIKit

protocol ViewRepresentation {
    
    func activateConstraint(in view: UIView)
    
}

protocol FullScreenRepresentation: ViewRepresentation {}

extension FullScreenRepresentation where Self: UIView {
    
    func activateConstraint(in view: UIView) {
        NSLayoutConstraint.activate([topAnchor.constraint(equalTo: view.topAnchor),
                                     bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                     leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     trailingAnchor.constraint(equalTo: view.trailingAnchor)])
    }
    
}
