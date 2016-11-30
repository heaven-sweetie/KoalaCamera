//
//  LayoutManager.swift
//  KoalaCamera
//
//  Created by KimYong Gyun on 28/11/2016.
//  Copyright © 2016 Koala. All rights reserved.
//

import UIKit

class LayoutManager {
    
    var layout: Layout!
    var elements = [UIView]()

    init(layout: Layout) {
        self.layout = layout
    }

    func add(_ element: UIView) {
        elements.append(element)
    }
    
    func add(_ elements: [UIView]) {
        self.elements.append(contentsOf: elements)
    }

    func clearAll() {
        self.elements.removeAll()
    }

    func render() {
        layout.render(self.elements)
    }

    func viewDidLayoutSubviews() {
        layout.viewDidLayoutSubviews(elements)
    }

    func updateLayout(layout: Layout, eager: Bool = true) {
        self.layout = layout
        if eager && elements.count > 0 {
            render()
        }
    }
    
}
