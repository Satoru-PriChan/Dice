//
//  simd+extension.swift
//  Dice
//
//  Created by kento.yamazaki on 2024/03/14.
//

import Foundation
import simd

extension simd_float4x4 {
    var translation: simd_float3 {
        return simd_float3(columns.3.x, columns.3.y, columns.3.z)
    }
    var upper3x3 : simd_float3x3 {
       return simd_float3x3(columns.0.float3, columns.1.float3, columns.2.float3)
    }
}

extension simd_float4 {
    var float3 : simd_float3 {
        return simd_float3(x,y,z)
    }
}
