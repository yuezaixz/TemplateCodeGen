//
//  Puzzle.swift
//  CodeGen
//
//  Created by 吴迪玮 on 2020/7/19.
//  Copyright © 2020 starmel. All rights reserved.
//

import Cocoa

class Puzzle: Codable {
    let resId: String = "2001902002"
    let version: String = "1"
    let name: String = "模板2-2"
    let iconPath: String = "thumbnail.post"
    let fullScreen: String = "0"
    var width: String = "1200"
    var height: String = "1200"
    var photoAmount: String = "0"
    let formatAmount: String = "1"
    let backgroundColor: String = "#ffffffff"
    let backgroundType: String = "0"
    let backgroundImagePath: String = ""
    let backgroundTile: String = ""
    let backgroundFilter: String = ""
    
    var photoPuzzlePieces: PhotoPiecesWraper = PhotoPiecesWraper()
    var boundaryPieces: BoundaryPiecesWraper = BoundaryPiecesWraper()
}
