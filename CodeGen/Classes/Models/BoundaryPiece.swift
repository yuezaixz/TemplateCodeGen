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
    
    var calcItem: CalcBoundartModel?
    
    init(_ model: CalcBoundartModel) {
        frameRect = "{{\(model.frameRect.origin.x),\(model.frameRect.origin.y)},{\(model.frameRect.size.width),\(model.frameRect.size.height)}}"
        calcItem = model
        translateDirection = model.translateDirection
        
    }
    
    func add(_ model: CalcBoundartModel) {
        if let calcItem = calcItem {
            if calcItem.translateDirection == "1" {
                calcItem.frameRect = CGRect(origin: calcItem.frameRect.origin, size: CGSize(width: calcItem.frameRect.size.width + model.frameRect.size.width, height: calcItem.frameRect.size.height))
            } else {
                calcItem.frameRect = CGRect(origin: calcItem.frameRect.origin, size: CGSize(width: calcItem.frameRect.size.width, height: calcItem.frameRect.size.height + model.frameRect.size.height))
            }
            frameRect = "{{\(calcItem.frameRect.origin.x),\(calcItem.frameRect.origin.y)},{\(calcItem.frameRect.size.width),\(calcItem.frameRect.size.height)}}"
        }
    }
}

