//
//  Layout.swift
//  Coinca
//
//  Created by KimYong Gyun on 28/11/2016.
//  Copyright © 2016 Koala. All rights reserved.
//

import UIKit

protocol Layout {
    
    func render(_ elements: [UIView])
    func viewDidLayoutSubviews(_ elements: [UIView])
    
}
