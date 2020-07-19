//
//  vectorNode.swift
//  CodeGen
//
//  Created by 吴迪玮 on 2020/7/19.
//  Copyright © 2020 starmel. All rights reserved.
//

import Foundation

enum VectorNodePosition: Int {
    case leftBottom = 0, leftTop, rightTop, rightBottom
}

class VectorNode {
    var photoIndexs: [String] = ["-1", "-1", "-1", "-1"]
    var origin: CGPoint
    
    init(photo: PhotoPiece, origin: CGPoint, position: VectorNodePosition) {
        photoIndexs[position.rawValue] = photo.photoIndex
        self.origin = origin
    }
    
    func isVector(photo: PhotoPiece, origin: CGPoint) -> Bool {
        self.origin.equalTo(origin)
    }
    
    func addPhotoIndexs(photoIndex: String, position: VectorNodePosition) {
        photoIndexs[position.rawValue] = photoIndex
    }
}
