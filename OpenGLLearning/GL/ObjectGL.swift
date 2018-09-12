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
    deinit {
        glDeleteBuffers(1, &bufferId)
        glDeleteVertexArrays(1, &vaoHandle)
    }
    
    struct VertexData {
        var x, y, z: GLfloat
        var x2, y2, z2: GLfloat
        var r, g, b: GLfloat
        static let colorOffset = MemoryLayout<GLfloat>.size * 3
    }
    
    private let context: GLContext
    private var shader: ShaderProgram
    
    private var bufferId: GLuint = 0
    private var vaoHandle = GLuint()
    private var rotationMatrix = Matrix4()
    private var angle: Float = 0
    
    init(_ context: GLContext) {
        self.context = context
        shader = context.getShader(vert: "basic_uniformblock_41.vert", frag: "basic_uniformblock_41.frag")!

        super.init()
        
        let positionData: [VertexData] = [
            VertexData(x: -0.5, y: -0.5, z: 0.0, x2: 1.0, y2: 0.0, z2: 0.0, ),
            VertexData(x: 0.5, y: -0.5, z: 0.0, r: 0.0, g: 1.0, b: 0.0),
            VertexData(x: 0.0, y: 0.0, z: 0.0, r: 0.0, g: 0.0, b: 1.0)
        ]
        
        glGenVertexArrays(1, &vaoHandle)
        glBindVertexArray(vaoHandle)
        
        glGenBuffers(1, &bufferId)
        
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), bufferId)
        glBufferData(GLenum(GL_ARRAY_BUFFER), MemoryLayout<VertexData>.stride * positionData.count, positionData, GLenum(GL_STATIC_DRAW))
        
        
        let vertexPositionLocation = shader.getAttributeLocation("a_position")!
        glEnableVertexAttribArray(vertexPositionLocation)
        glVertexAttribPointer(vertexPositionLocation, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(MemoryLayout<VertexData>.stride), UnsafeRawPointer(bitPattern: 0))
        
        let vertexColorLocation = shader.getAttributeLocation("a_color")!
        glEnableVertexAttribArray(vertexColorLocation)
        glVertexAttribPointer(vertexColorLocation, 3, GLenum(GL_FLOAT), GLboolean(GL_TRUE), GLsizei(MemoryLayout<VertexData>.stride), UnsafeRawPointer(bitPattern: VertexData.colorOffset))
    }
    
    func draw() {
        context.currentShader = shader
        
        angle += 1.0 / 100.0
        if angle > 360 { angle -= 360 }
        rotationMatrix = Matrix4.rotationMatrix(angle: angle, x: 0.0, y: 0.0, z: 0.0)
        
        let rotationMatrixPosition = shader.getUniformLocation("RotationMatrix")!
        glUniformMatrix4fv(GLint(rotationMatrixPosition), 1, GLboolean(GL_TRUE), rotationMatrix.matrix)
        
        glBindVertexArray(vaoHandle)
        glDrawArrays(GLenum(GL_TRIANGLES), 0, 3)
    }
}
