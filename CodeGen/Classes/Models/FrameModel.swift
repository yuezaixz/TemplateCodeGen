//
//  FrameModel.swift
//  CodeGen
//
//  Created by 吴迪玮 on 2020/7/19.
//  Copyright © 2020 starmel. All rights reserved.
//

import Cocoa

enum PhotoCountType: Int {
    case one = 1, two, three, four, five, six, seven, eight, nine
    
    var radioTypes: [FrameRadioType] {
        switch self {
        case .one:
            return [.r3_4, .r1_1, .r4_3, .rfull, .r1_2, .r16_9, .r2_1, .r3_1, .r4_1]
        case .two:
            return [.r3_4, .r1_1, .r4_3, .rfull, .r1_2, .r16_9, .r2_1]
        case .three:
            return [.r3_4, .r1_1, .r4_3, .rfull, .r1_3, .r16_9, .r3_1]
        case .four:
            return [.r3_4, .r1_1, .r4_3, .rfull, .r1_4, .r16_9, .r4_1]
        case .five:
            return [.r3_4, .r1_1, .r4_3, .rfull, .r16_9]
        case .six:
            return [.r3_4, .r1_1, .r4_3, .r2_3, .rfull, .r16_9, .r3_2]
        default:
            return [.r3_4, .r1_1, .r4_3, .r16_9]
        }
    }
}

enum FrameRadioType: Int {
    case r3_4 = 0
    case r1_1
    case r4_3
    case rfull
    case r1_2
    case r1_3
    case r1_4
    case r2_3
    case r16_9
    case r3_2
    case r2_1
    case r3_1
    case r4_1

    //        "{{334,0},{666,1000}}"
    func frameSize() -> CGSize {
        var width: CGFloat = 1200, height: CGFloat = 1200
        switch self {
        case .r1_2:
            width = 600
        case .r1_3:
            width = 400
        case .r1_4:
            width = 300
        case .r2_1:
            height = 600
        case .r2_3:
            width = 800
        case .r3_1:
            height = 400
        case .r3_2:
            height = 800
        case .r3_4:
            height = 900
        case .r4_1:
            height = 300
        case .r4_3:
            height = 900
        case .r16_9:
            height = 675
        default:
            width = 1200
            height = 1200
        }
        return CGSize(width: width, height: height)
    }
    
    func frameRect(_ frameModel: FrameModel) -> CGRect {
        let size = self.frameSize()
        let width: CGFloat = size.width, height: CGFloat = size.height
        
        let originX = Int(frameModel.origin.x * width) + Int(frameModel.origin.x) != 0 ? 1 : 0
        let originY = Int(frameModel.origin.y * height) + Int(frameModel.origin.y) != 0 ? 1 : 0
        let sizeWidth = Int(frameModel.size.width * width)
        let sizeheight = Int(frameModel.size.height * width)
        
        return CGRect(origin: CGPoint(x: originX, y: originY), size: CGSize(width: sizeWidth, height: sizeheight))
    }
    
    func frameStrs(_ frameModel: FrameModel) -> String {
        let size = self.frameSize()
        let width: CGFloat = size.width, height: CGFloat = size.height
        
        let originX = Int(frameModel.origin.x * width)
        let originY = Int(frameModel.origin.y * height)
        let sizeWidth = Int(frameModel.size.width * width)
        let sizeheight = Int(frameModel.size.height * width)
        
        return "{{\(originX),\(originY)},{\(sizeWidth),\(sizeheight)}}"
    }
    
    var radio: CGFloat {
        switch self {
        case .r1_2:
            return 1 / 2
        case .r1_3:
            return 1 / 3
        case .r1_4:
            return 1 / 4
        case .r2_1:
            return 2 / 1
        case .r2_3:
            return 2 / 3
        case .r3_1:
            return 3 / 1
        case .r3_2:
            return 3 / 2
        case .r3_4:
            return 3 / 4
        case .r4_1:
            return 4 / 1
        case .r4_3:
            return 4 / 3
        case .r16_9:
            return 16 / 9
        default:
            return 1
        }
    }
}

struct FrameModel {
    let origin: CGPoint
    let size: CGSize
    
    let hStr: String
    let vStr: String
    
    func vectors(frameSize: CGSize) -> [CGPoint] {
        var results: [CGPoint] = []
        
        results.append(CGPoint(x: origin.x * frameSize.width, y: origin.y * frameSize.height))
        results.append(CGPoint(x: origin.x * frameSize.width, y: (origin.y + size.height) * frameSize.height))
        results.append(CGPoint(x: (origin.x + size.width) * frameSize.width, y: (origin.y + size.height) * frameSize.height))
        results.append(CGPoint(x: (origin.x + size.width) * frameSize.width, y: origin.y * frameSize.height))
        
        return results
    }
}
