//
//  ObjectGL.swift
//  OpenGLLearning
//
//  Created by Pavel Kozlov on 04/09/2018.
//  Copyright © 2018 Pavel Kozlov. All rights reserved.
//

import Foundation
import OpenGLES
import GLKit

class ObjectGL: NSObject {
    
    struct VertexData {
        var x: GLfloat
//        var r, g, b: GLfloat
        static let colorOffset = MemoryLayout<GLfloat>.size * 3
    }
    
    private let context: GLContext
    
    private var bufferId: GLuint = 0
    private var shader: ShaderProgram
    
    private var vaoHandle = GLuint()
    
    
    init(_ context: GLContext) {
        self.context = context
        shader = context.getShader(vert: "basic.vert", frag: "basic.frag")!

        super.init()
        
        let positionData: [GLfloat] = [
            -1.0, -1.0, 0.0,
            1.0, -1.0, 0.0,
            0.0, 0.0, 0.0
        ]
        let colorData: [GLfloat] = [
            1.0, 0.0, 0.0,
            0.0, 1.0, 0.0,
            0.0, 0.0, 1.0
        ]
        
        var vboHandles: [GLuint] = Array.init(repeating: 0, count: 2)
        glGenBuffers(2, &vboHandles)
        let positionBufferHandle = vboHandles[0]
        let colorBufferHandle = vboHandles[1]

        glBindBuffer(GLenum(GL_ARRAY_BUFFER), positionBufferHandle)
        glBufferData(GLenum(GL_ARRAY_BUFFER), MemoryLayout<GLfloat>.size * positionData.count, positionData, GLenum(GL_STATIC_DRAW))
        
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), colorBufferHandle)
        glBufferData(GLenum(GL_ARRAY_BUFFER), MemoryLayout<GLfloat>.size * colorData.count, colorData, GLenum(GL_STATIC_DRAW))
        
        glGenVertexArrays(1, &vaoHandle)
        glBindVertexArray(vaoHandle)
        
        let vertexPositionLocation = shader.getAttributeLocation("a_position")!
        glEnableVertexAttribArray(vertexPositionLocation)
        let vertexColorLocation = shader.getAttributeLocation("a_color")!
        glEnableVertexAttribArray(vertexColorLocation)
        
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), positionBufferHandle)
        glVertexAttribPointer(vertexPositionLocation, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, UnsafeRawPointer(bitPattern: 0))
        
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), colorBufferHandle)
        glVertexAttribPointer(vertexColorLocation, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, UnsafeRawPointer(bitPattern: 0))
        
        glBindVertexArray(0)
    }
    
    func draw() {
        context.currentShader = shader
        glBindVertexArray(vaoHandle)
        glDrawArrays(GLenum(GL_TRIANGLES), 0, 9)
    }
}
