//
//  SpaceModel.swift
//  CodeGen
//
//  Created by 吴迪玮 on 2020/7/19.
//  Copyright © 2020 starmel. All rights reserved.
//

import Cocoa

class SpaceModel {
    var currentPointIndex: Int? = 0
    var currentPoint: CGPoint? {
        currentPointIndex != nil ? insertPoints[currentPointIndex!] : nil
    }
    var remainH: CGFloat {
        currentPointIndex != nil ? (1.0 - currentPoint!.x) : 0.0
    }
    var remainV: CGFloat {
        currentPointIndex != nil ? (1.0 - currentPoint!.y) : 0.0
    }
    var datas: [FrameModel] = []
    
    var insertPoints: [CGPoint] = [CGPoint(x: 0, y: 0)]
    
    func generateInsertPoints() {
        currentPointIndex = nil
        let points = datas.flatMap { [CGPoint(x: $0.origin.x, y: $0.origin.y), CGPoint(x: $0.origin.x, y: $0.origin.y + $0.size.height), CGPoint(x: $0.origin.x + $0.size.width, y: $0.origin.y + $0.size.height), CGPoint(x: $0.origin.x + $0.size.width, y: $0.origin.y)] }
        
        var pointSet: Set<CGPoint> = []
        
        for point in points {
            if point.equalTo(CGPoint.zero) {
                continue
            }
            if pointSet.contains(point) {
                pointSet.remove(point)
            } else {
                pointSet.insert(point)
            }
        }
        insertPoints = [CGPoint](pointSet)
    }
}
