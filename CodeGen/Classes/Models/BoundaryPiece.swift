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

class BoundaryPiece: Codable, SortedKeysable {
    var patchIndex: String = ""
    var frameRect: String
    /// 移动方向，取值1：水平移动；取值2：竖直移动
    var translateDirection: String = "1"
    var patchesDividedBy: String = "0,1"
    var topBoundarys: String = "-1"
    var leftBoundarys: String = "-1"
    var bottomBoundarys: String = "-1"
    var rightBoundarys: String = "-1"
    
    var startPoint: CGPoint?
    var endPoint: CGPoint?
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case patchIndex, frameRect, translateDirection
        case patchesDividedBy, topBoundarys
        case leftBoundarys, bottomBoundarys, rightBoundarys
    }
    
    var sortedKeys: [String] {
        return BoundaryPiece.CodingKeys.allCases.map { $0.rawValue }
    }
    
    init(_ startPoint: CGPoint, endPoint: CGPoint, isH: Bool) {
        self.startPoint = startPoint
        self.endPoint = endPoint
        
        if isH {
            translateDirection = "1"
            frameRect = "{{\(Int(startPoint.x - kBoundartWidth/2)),\(Int(startPoint.y))},{\(Int(kBoundartWidth)),\(Int(endPoint.y - startPoint.y))}}"
        } else {
            translateDirection = "2"
            frameRect = "{{\(Int(startPoint.x)),\(Int(startPoint.y - kBoundartWidth/2))},{\(Int(endPoint.x - startPoint.x)),\(Int(kBoundartWidth))}}"
        }
        
    }
}

