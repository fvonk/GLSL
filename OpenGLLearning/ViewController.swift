//
//  ViewController.swift
//  OpenGLLearning
//
//  Created by Pavel Kozlov on 04/09/2018.
//  Copyright © 2018 Pavel Kozlov. All rights reserved.
//

import UIKit
import GLKit
import OpenGLES


class ViewController: UIViewController {
    @IBOutlet weak var glkView: GLKView!
    
    private var context: EAGLContext!
    var glContext: GLContext!
    var objectGL: ObjectGL!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.glContext = GLContext()
        context = EAGLContext(api: .openGLES3)!
        glkView.context = context
        glkView.isOpaque = true
//        glView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        glkView.drawableMultisample = .multisample4X
        glkView.drawableColorFormat = .RGBA8888
        EAGLContext.setCurrent(self.context)
        
        objectGL = ObjectGL(glContext)
    
        glkView.display()
    }
}


extension ViewController: GLKViewDelegate {
    func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClearColor(1.0, 1.0, 1.0, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        objectGL.draw()
    }
}
