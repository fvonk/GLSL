//
// Created by Yuri Drozdovski on 5/16/18.
// Copyright (c) 2018 drozdovsky. All rights reserved.
//

import Foundation
import Accelerate

struct Matrix4 {
    var matrix: [Float]

    init() {
        matrix = [
            1.0, 0.0, 0.0, 0.0,
            0.0, 1.0, 0.0, 0.0,
            0.0, 0.0, 1.0, 0.0,
            0.0, 0.0, 0.0, 1.0
        ]
    }

    init(sX: Float, sY: Float, sZ: Float = 1.0, tX: Float, tY: Float, tZ: Float = 0.0) {
        matrix = [
            sX, 0.0, 0.0, 0.0,
            0.0, sY, 0.0, 0.0,
            0.0, 0.0, sZ, 0.0,
            tX, tY, tZ, 1.0
        ]
    }

    static func perspectiveMatrix(fov: Float, aspect: Float, near: Float, far: Float) -> Matrix4 {
        var matrix = Matrix4()
        let f = 1.0 / tanf(fov / 2.0)

        matrix.matrix[0] = f / aspect
        matrix.matrix[5] = f
        matrix.matrix[10] = (far + near) / (near - far)
        matrix.matrix[11] = -1.0
        matrix.matrix[14] = (2.0 * far * near) / (near - far)
        matrix.matrix[15] = 0.0

        return matrix
    }

    static func orthoMatrix(left: Float, right: Float, top: Float, bottom: Float) -> Matrix4 {
        var matrix = Matrix4()

        matrix.matrix[0] = 2.0 / (right - left)
        matrix.matrix[5] = 2.0 / (top - bottom)
        matrix.matrix[12] = -(right + left) / (right - left)
        matrix.matrix[13] = -(top + bottom) / (top - bottom)

        return matrix
    }

    static func translationMatrix(x: Float, y: Float, z: Float) -> Matrix4 {
        var matrix = Matrix4()

        matrix.matrix[12] = x
        matrix.matrix[13] = y
        matrix.matrix[14] = z

        return matrix
    }

    static func scaleMatrix(x: Float, y: Float, z: Float) -> Matrix4 {
        var matrix = Matrix4()

        matrix.matrix[0] = x
        matrix.matrix[5] = y
        matrix.matrix[10] = z

        return matrix
    }

    static func rotationMatrix(angle: Float, x: Float, y: Float, z: Float) -> Matrix4 {
        var matrix = Matrix4()

        let c = cosf(angle)
        let ci = 1.0 - c
        let s = sinf(angle)

        let xy = x * y * ci
        let xz = x * z * ci
        let yz = y * z * ci
        let xs = x * s
        let ys = y * s
        let zs = z * s

        matrix.matrix[0] = x * x * ci + c
        matrix.matrix[1] = xy + zs
        matrix.matrix[2] = xz - ys
        matrix.matrix[4] = xy - xz
        matrix.matrix[5] = y * y * ci + c
        matrix.matrix[6] = yz + xs
        matrix.matrix[8] = xz + ys
        matrix.matrix[9] = yz - xs
        matrix.matrix[10] = z * z * ci + c

        return matrix
    }

    mutating func invert() {
        var N:__CLPK_integer = __CLPK_integer(4)
        var pivots:[__CLPK_integer] = [__CLPK_integer](repeating: 0, count: Int(N))
        var workspace: [Float] = [Float](repeating: 0.0, count: Int(N))
        var error: __CLPK_integer   = 0
        withUnsafeMutablePointer(to: &N) { (p: UnsafeMutablePointer<__CLPK_integer>) -> Void in
            sgetrf_(p, p, &matrix, p, &pivots, &error)
            sgetri_(p, &matrix, p, &pivots, &workspace, p, &error)
        }
    }

    func inverted() -> Matrix4 {
        var result = self
        result.invert()
        return result

    }
}

func * (left: Matrix4, right: Matrix4) -> Matrix4 {
    var result = Matrix4()
    cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, 4, 4, 4, 1.0, left.matrix, 4, right.matrix, 4, 0.0, &result.matrix, 4)
    return result
}
