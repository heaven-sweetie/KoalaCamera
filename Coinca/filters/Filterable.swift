//
//  Filterable.swift
//  Coinca
//
//  Created by KimYong Gyun on 4/12/2016.
//  Copyright © 2016 Koala. All rights reserved.
//

import Photos

protocol Filterable {
    var outputImage: CIImage? { get }
    func setImage(_ image: CIImage)
}
