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

class PhotoPiece: Codable, SortedKeysable {
    let maskPath: String = ""
    let filterPath: String = ""
    let backgroundImagePath: String = ""
    let backgroundImageInnerFrame: String = ""
    let contentMode: String = "2"
    var photoIndex: String = "0"
    var borderHasNeighbors: String = "0,0,0,0"
    var topBoundarys: String = "-1"
    var leftBoundarys: String = "-1"
    var bottomBoundarys: String = "-1"
    var rightBoundarys: String = "-1"
    var frameRectArray: [String: [String]] = ["frameRect": []]
    
    var origin: CGPoint?
    var size: CGSize?
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case maskPath, filterPath, backgroundImagePath, backgroundImageInnerFrame
        case contentMode, photoIndex, borderHasNeighbors
        case topBoundarys, leftBoundarys, bottomBoundarys
        case rightBoundarys, frameRectArray
    }
    
    var sortedKeys: [String] {
        return PhotoPiece.CodingKeys.allCases.map { $0.rawValue }
    }
}
