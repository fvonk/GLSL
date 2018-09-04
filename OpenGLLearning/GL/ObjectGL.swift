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
        var x, y, z: GLfloat
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
        
        let positionData: [VertexData] = [
            VertexData(x: 1.0, y: -1.0, z: 0.0),
            VertexData(x: 1.0, y: -1.0, z: 0.0),
            VertexData(x: 0.0, y: 0.0, z: 0.0)
        ]
        let colorData: [VertexData] = [
            VertexData(x: 1.0, y: 0.0 , z: 0.0),
            VertexData(x: 0.0, y: 1.0 , z: 0.0),
            VertexData(x: 0.0, y: 0.0 , z: 1.0)
        ]
        
        glGenVertexArrays(1, &vaoHandle)
        glBindVertexArray(vaoHandle)
        
        var vboHandles: [GLuint] = Array.init(repeating: 0, count: 2)
        glGenBuffers(2, &vboHandles)
//        glGenBuffers(1, &bufferId)
        let positionBufferHandle = vboHandles[0]
        let colorBufferHandle = vboHandles[1]
        
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), positionBufferHandle)
        glBufferData(GLenum(GL_ARRAY_BUFFER), MemoryLayout<VertexData>.stride * positionData.count, positionData, GLenum(GL_STATIC_DRAW))
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), colorBufferHandle)
        glBufferData(GLenum(GL_ARRAY_BUFFER), MemoryLayout<VertexData>.stride * colorData.count, colorData, GLenum(GL_STATIC_DRAW))
                
        
        let vertexPositionLocation = shader.getAttributeLocation("a_position")!
        glEnableVertexAttribArray(vertexPositionLocation)
        glVertexAttribPointer(vertexPositionLocation, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<VertexData>.stride), UnsafeRawPointer(bitPattern: 0))
        
        let vertexColorLocation = shader.getAttributeLocation("a_color")!
        glEnableVertexAttribArray(vertexColorLocation)
        glVertexAttribPointer(vertexColorLocation, 3, GLenum(GL_UNSIGNED_BYTE), GLboolean(GL_TRUE), GLsizei(MemoryLayout<VertexData>.stride), UnsafeRawPointer(bitPattern: 0))
    }
    
    func draw() {
        context.currentShader = shader
        glBindVertexArray(vaoHandle)
        glDrawArrays(GLenum(GL_TRIANGLES), 0, 3)
    }
}
