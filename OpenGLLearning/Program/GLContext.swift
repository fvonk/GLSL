//
// Created by Yuri Drozdovski on 7/20/18.
// Copyright (c) 2018 drozdovsky. All rights reserved.
//

import Foundation
import GLKit

class GLContext {
    private var shaders = [TwoStringsKey: ShaderProgram]()
    private var textures = [CGImage: GLKTextureInfo]()

    init() {}

    func getShader(vert: String, frag: String) -> ShaderProgram? {
        let key = TwoStringsKey(string1: vert, string2: frag)
        if let shader = shaders[key] {
            return shader
        } else {
            if let shader = ShaderProgram(vert: vert, frag: frag) {
                shaders[key] = shader
                return shader
            }
        }
        return nil
    }

    private var _currentShader: ShaderProgram?
    var currentShader: ShaderProgram? {
        get {
            return _currentShader
        }
        set {
            if _currentShader != newValue {
                _currentShader = newValue
                newValue?.use()
            }
        }
    }

    func getTextureForImage(_ image: CGImage) -> GLKTextureInfo {
        if let texture = textures[image] {
            return texture
        } else {
            let texture = try! GLKTextureLoader.texture(with: image, options: [GLKTextureLoaderGenerateMipmaps: 1])
            print("getTextureForImage result:", glGetError())
            textures[image] = texture
            return texture
        }
    }
}

struct TwoStringsKey: Hashable {
    let string1: String
    let string2: String

    private(set) var hashValue: Int = 0

    init(string1: String, string2: String) {
        self.string1 = string1
        self.string2 = string2
        hashValue = string1.hashValue ^ string2.hashValue
    }

    static func ==(lhs: TwoStringsKey, rhs: TwoStringsKey) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

