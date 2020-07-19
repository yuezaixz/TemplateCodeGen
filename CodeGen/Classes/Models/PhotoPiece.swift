//
//  PhotoPiece.swift
//  CodeGen
//
//  Created by 吴迪玮 on 2020/7/19.
//  Copyright © 2020 starmel. All rights reserved.
//

import Cocoa

class PhotoPiecesWraper: Codable {
    var photoPuzzle: [PhotoPiece] = []
}

class PhotoPiece: Codable {
    let contentMode: String = "2"
    var photoIndex: String = "0"
    var borderHasNeighbors: String = "0,0,0,0"
    var topBoundarys: String = "-1"
    var leftBoundarys: String = "-1"
    var bottomBoundarys: String = "-1"
    var rightBoundarys: String = "-1"
    var frameRectArray: [String] = []
}
