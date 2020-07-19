//
//  BoundaryPiece.swift
//  CodeGen
//
//  Created by 吴迪玮 on 2020/7/19.
//  Copyright © 2020 starmel. All rights reserved.
//

import Cocoa

class BoundaryPiecesWraper: Codable {
    var boundaryPiece: [BoundaryPiece] = []
}

class BoundaryPiece: Codable {
    var patchIndex: String = ""
    var frameRect: String
    /// 移动方向，取值1：水平移动；取值2：竖直移动
    var translateDirection: String = "1"
    var patchesDividedBy: String = "0,1"
    var topBoundarys: String = "-1"
    var leftBoundarys: String = "-1"
    var bottomBoundarys: String = "-1"
    var rightBoundarys: String = "-1"
    
    init(_ startPoint: CGPoint, endPoint: CGPoint, isH: Bool) {
        if isH {
            translateDirection = "1"
            frameRect = "{{\(startPoint.x - kBoundartWidth/2),\(startPoint.y)},{\(kBoundartWidth),\(endPoint.y - startPoint.y)}}"
        } else {
            translateDirection = "2"
            frameRect = "{{\(startPoint.x),\(startPoint.y - kBoundartWidth/2)},{\(endPoint.x - startPoint.x),\(kBoundartWidth)}}"
        }
        
    }
}

