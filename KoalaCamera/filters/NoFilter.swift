//
//  NoFilter.swift
//  KoalaCamera
//
//  Created by KimYong Gyun on 4/12/2016.
//  Copyright © 2016 Koala. All rights reserved.
//

import Photos
import AVKit

class NoFilter: Filterable {

    var image: CIImage?
    var outputImage: CIImage? {
        return image
    }

    func setImage(_ image: CIImage) {
        self.image = image
    }
}
