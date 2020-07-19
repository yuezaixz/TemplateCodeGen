//
//  GenerateUtils.swift
//  CodeGen
//
//  Created by 吴迪玮 on 2020/7/19.
//  Copyright © 2020 starmel. All rights reserved.
//

import Foundation

class GenerateUtils {
    class func generateBorderHasNeighbors(_ frameModel: FrameModel, _ photoPiece: PhotoPiece) {
        var borderHasNeighbors = ""
        borderHasNeighbors += frameModel.origin.x != 0 ? "1," : "0,"
        borderHasNeighbors += (frameModel.origin.y + frameModel.size.height < 0.99) ? "1," : "0,"
        borderHasNeighbors += (frameModel.origin.x + frameModel.size.width < 0.99) ? "1," : "0,"
        borderHasNeighbors += frameModel.origin.y != 0 ? "1" : "0"
        photoPiece.borderHasNeighbors = borderHasNeighbors
    }
    
    class func transferToNumber(str: String) -> CGFloat? {
        if str.contains(Character("/")) {
            let splits = str.split(separator: Character("/"))
            if splits.count == 2 {
                if let fenzi = Float(String(splits[0]))
                    , let fenmu = Float(String(splits[1])) {
                    return CGFloat(fenzi / fenmu)
                }
                
            }
            return nil
        } else {
            return Float(str).map { CGFloat($0) }
        }
    }
}
