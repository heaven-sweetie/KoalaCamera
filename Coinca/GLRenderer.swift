//
//  GLRenderer.swift
//  KoalaCamera
//
//  Created by ParkHanul on 2/12/16.
//  Copyright © 2016 Koala. All rights reserved.
//

import GLKit

class GLRenderer {
    
    var glView: GLKView
    var renderContext: CIContext!
    
    init(glView: GLKView) {
        self.glView = glView
        self.renderContext = CIContext(eaglContext: glView.context)
        self.glView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
    }
    
    convenience init(frame: CGRect, superview: UIView) {
        let view = GLKView(frame: frame, context: EAGLContext(api: .openGLES2))
        view.frame = frame
        view.translatesAutoresizingMaskIntoConstraints = false
        superview.addSubview(view)
        
        self.init(glView: view)
        
        layoutGLView(superview: superview)
    }
    
    func layoutGLView(superview: UIView) {
    }

    func renderImage(image: CIImage) {
        if let superview = glView.superview {
            glView.frame = superview.frame
        }
        glView.bindDrawable()
        if glView.context != EAGLContext.current() {
            EAGLContext.setCurrent(glView.context)
        }
        
        // Calculate the position and size of the image within the GLView
        // This code is equivalent to UIViewContentModeScaleAspectFit
        let imageSize = image.extent.size
        var drawFrame = CGRect(x: 0, y: 0, width: CGFloat(glView.drawableWidth), height: CGFloat(glView.drawableHeight))
        let imageAR = imageSize.width / imageSize.height
        let viewAR = drawFrame.width / drawFrame.height
        if imageAR > viewAR {
            drawFrame.size.height = drawFrame.width / imageAR
        } else {
            drawFrame.size.width = drawFrame.height * imageAR
        }
        
        // clear eagl view to black
        glClearColor(0.0, 0.0, 0.0, 1.0)
        glClear(0x00004000)

        // set the blend mode to "source over" so that CI will use that
        glEnable(0x0BE2)
        glBlendFunc(1, 0x0303)

        renderContext.draw(image, in: drawFrame, from: image.extent)
        
        glView.display()
    }
}
