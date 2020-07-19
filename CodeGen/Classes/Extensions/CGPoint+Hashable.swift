//
//  CGPoint+Hashable.swift
//  CodeGen
//
//  Created by 吴迪玮 on 2020/7/19.
//  Copyright © 2020 starmel. All rights reserved.
//

import Cocoa

extension CGPoint : Hashable {
    func distance(point: CGPoint) -> Float {
        let dx = Float(x - point.x)
        let dy = Float(y - point.y)
        return sqrt((dx * dx) + (dy * dy))
    }
    
    func equal(point: CGPoint) -> Bool {
        return distance(point: point) < 0.000001
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x.hashValue << 32 ^ y.hashValue)
    }
    
    public var hashValue: Int {
        return x.hashValue << 32 ^ y.hashValue
    }
}
