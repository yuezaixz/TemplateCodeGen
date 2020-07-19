//
//  ViewController.swift
//  CodeGen
//
//  Created by admin on 09.04.18.
//  Copyright © 2018 starmel. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTextFieldDelegate {
    
    private var spaceModel = SpaceModel()
    
    private var radioType: FrameRadioType = .r4_3

    @IBOutlet weak var containerView: NSView!
    @IBOutlet weak var hPerTextField: NSTextField!
    @IBOutlet weak var vPerTextField: NSTextField!
    @IBOutlet var containerConstraint: NSLayoutConstraint?
    
    fileprivate func setupContainerColor() {
        let containerLayer = CALayer()
        containerView.wantsLayer = true
        containerView.layer = containerLayer
        containerLayer.backgroundColor = NSColor.black.cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContainerColor()
        containerView.addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(containerViewClickAction(gesture:))))
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        regenerateContentViews()
    }
    
    @objc func containerViewClickAction(gesture: NSClickGestureRecognizer) {
        guard spaceModel.insertPoints.count >= 1 else {
            spaceModel.currentPointIndex = spaceModel.insertPoints.count == 0 ? nil : 1
            return
        }
        let point = gesture.location(in: containerView)
        let percentPoint = CGPoint(x: point.x/containerView.bounds.size.width, y: point.y/containerView.bounds.size.height)
        for (index, insertPoint) in spaceModel.insertPoints.enumerated() {
            if percentPoint.distance(point: insertPoint) < 0.1 {
                spaceModel.currentPointIndex = index
                regenerateContentViews()
                return
            }
        }
    }
    
    let backgroundColors: [NSColor] = [.gray, .green, .blue, .cyan, .yellow, .magenta, .orange, .purple, .brown]
    
    func regenerateContentViews() {
        containerView.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        let containerViewWidth = containerView.bounds.size.width
        let containerViewHeight = containerView.bounds.size.height
        
        for (index, frameModel) in spaceModel.datas.enumerated() {
            let label = NSTextField()
            label.frame = CGRect(origin: CGPoint(x: frameModel.origin.x * containerViewWidth, y: frameModel.origin.y * containerViewHeight), size: CGSize(width: frameModel.size.width * containerViewWidth, height: frameModel.size.height * containerViewHeight))
            label.stringValue = "\(frameModel.hStr)\n\(frameModel.vStr)"
            label.backgroundColor = backgroundColors[index]
            label.isBezeled = false
            label.isEditable = false
            containerView.addSubview(label)
        }
        if let currentPoint = spaceModel.currentPoint {
            let label = NSTextField()
            label.frame = CGRect(origin: CGPoint(x: currentPoint.x * containerViewWidth, y: currentPoint.y * containerViewHeight), size: CGSize(width: 2, height: 2))
            label.backgroundColor = .red
            label.isBezeled = false
            label.isEditable = false
            containerView.addSubview(label)
        }
        
    }
    
    @IBAction func changeRadioAction(_ sender: NSPopUpButton) {
        if let containerConstraint = containerConstraint {
            containerView.removeConstraint(containerConstraint)
        }
        radioType = FrameRadioType(rawValue: sender.selectedItem?.tag ?? FrameRadioType.r4_3.rawValue) ?? FrameRadioType.r4_3
        containerConstraint = NSLayoutConstraint(item: containerView as Any, attribute: .width, relatedBy: .equal, toItem: containerView, attribute: .height, multiplier: radioType.radio, constant: 0)
        containerView.addConstraint(containerConstraint!)
    }
    
    @IBAction func addAction(_ sender: Any) {
//        print("\(hPerTextField.stringValue),\(vPerTextField.stringValue)")
        if let insertPoint = spaceModel.currentPoint, let hValue = transferToNumber(str: hPerTextField.stringValue), let vValue = transferToNumber(str: vPerTextField.stringValue) {
            guard hValue <= spaceModel.remainH + 0.01 && vValue <= spaceModel.remainV + 0.01 else {
                return
            }
            // TODO 这里其实还要验证下，插入的位置，是个凹槽，右边会不会空间有限。
            print("\(hValue),\(vValue)")
            
            let frameModel = FrameModel(origin: insertPoint, size: CGSize(width: hValue, height: vValue), hStr: hPerTextField.stringValue, vStr: vPerTextField.stringValue)
            spaceModel.datas.append(frameModel)
            spaceModel.generateInsertPoints()
            
            regenerateContentViews()
        }
    }
    
    func transferToNumber(str: String) -> CGFloat? {
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
    
    @IBAction func cleanAction(_ sender: Any) {
        spaceModel = SpaceModel()
        regenerateContentViews()
    }
    
    fileprivate func generateTempBoundary(_ frameRect: CGRect, _ tempBoundary: inout [CalcBoundartModel]) {
        let calcBoundartItem = CalcBoundartModel()
        if frameRect.origin.x != 0 {
            calcBoundartItem.frameRect = CGRect(origin: CGPoint(x: frameRect.origin.x - kBoundartWidth / 2, y: frameRect.origin.y), size: CGSize(width: kBoundartWidth, height: frameRect.size.height))
            calcBoundartItem.translateDirection = "2"
        }
        if frameRect.origin.y != 0 {
            calcBoundartItem.frameRect = CGRect(origin: CGPoint(x: frameRect.origin.x, y: frameRect.origin.y - kBoundartWidth / 2), size: CGSize(width: frameRect.size.width, height: kBoundartWidth))
            calcBoundartItem.translateDirection = "1"
        }
        if frameRect.origin.x + frameRect.size.width < 0.99 {
            calcBoundartItem.frameRect = CGRect(origin: CGPoint(x: frameRect.origin.x + frameRect.size.width - kBoundartWidth / 2, y: frameRect.origin.y), size: CGSize(width: kBoundartWidth, height: frameRect.size.height))
            calcBoundartItem.translateDirection = "2"
        }
        if frameRect.origin.y + frameRect.size.height < 0.99 {
            calcBoundartItem.frameRect = CGRect(origin: CGPoint(x: frameRect.origin.x, y: frameRect.origin.y + frameRect.size.height - kBoundartWidth / 2), size: CGSize(width: frameRect.size.width, height: kBoundartWidth))
            calcBoundartItem.translateDirection = "1"
        }
        tempBoundary.append(calcBoundartItem)
    }
    
    fileprivate func generateBorderHasNeighbors(_ frameModel: FrameModel, _ photoPiece: PhotoPiece) {
        var borderHasNeighbors = ""
        borderHasNeighbors += frameModel.origin.x != 0 ? "1," : "0,"
        borderHasNeighbors += (frameModel.origin.y + frameModel.size.height < 0.99) ? "1," : "0,"
        borderHasNeighbors += (frameModel.origin.x + frameModel.size.width < 0.99) ? "1," : "0,"
        borderHasNeighbors += frameModel.origin.y != 0 ? "1" : "0"
        photoPiece.borderHasNeighbors = borderHasNeighbors
    }
    
    @IBAction func saveAction(_ sender: Any) {
        
        let encoder = XMLEncoder()
        do {
            let puzzle = Puzzle()
            let frameSize = radioType.frameSize()
            puzzle.width = "\(frameSize.width)"
            puzzle.height = "\(frameSize.height)"
            puzzle.photoAmount = "\(spaceModel.datas.count)"
            
            var photoPuzzles: [PhotoPiece] = []
            
            var tempBoundary: [CalcBoundartModel] = []
            
            var vectorNodes: [VectorNode] = []
            
            for (index, frameModel) in spaceModel.datas.enumerated() {
                let photoPiece = PhotoPiece()
                
                //frames
                photoPiece.frameRectArray = [radioType.frameStrs(frameModel)]
                
                let frameRect = radioType.frameRect(frameModel)
                
                // 生成未进行合并的boundart集合
                generateTempBoundary(frameRect, &tempBoundary)
                
                photoPiece.photoIndex = "\(index)"
                // 生成左上右下是否有邻居
                generateBorderHasNeighbors(frameModel, photoPiece)
                
                //TODO topBoundarys
                
                photoPuzzles.append(photoPiece)
            }
            var boundarys: [BoundaryPiece] = []
            for bundaryItem in tempBoundary {
                var findIndex: Int?
                for (addedItemIndex, addedItem) in boundarys.enumerated() {
                    if let calcItem = addedItem.calcItem, calcItem.translateDirection == bundaryItem.translateDirection {
                        if calcItem.frameRect.origin.x + calcItem.frameRect.size.width == bundaryItem.frameRect.origin.x && calcItem.frameRect.origin.y + calcItem.frameRect.size.height == bundaryItem.frameRect.origin.y {
                            findIndex = addedItemIndex
                            break
                        }
                    }
                }
                if let findIndex = findIndex {
                    let addingItem = boundarys[findIndex]
                    addingItem.add(bundaryItem)
                } else {
                    let addingItem = BoundaryPiece(bundaryItem)
                    boundarys.append(addingItem)
                }
            }
            
            for (itemIndex, boundartItem) in boundarys.enumerated() {
                boundartItem.patchIndex = "1\(itemIndex)"
                
                // TODO patchesDividedBy分割的照片部件
                // 去frameModel去找，是在边界则添加
                // 两个模型的topBoundarys等也在这里生成
                
                // 清空，不进行导出
                boundartItem.calcItem = nil
            }
            puzzle.photoPuzzlePieces.photoPuzzle = photoPuzzles
            puzzle.boundaryPieces.boundaryPiece = boundarys
            
            let data = try encoder.encode(puzzle, withRootKey: "puzzle") //根节点标签为data
            let xml = String(data: data, encoding: .utf8)
            print(xml!)
        } catch {
            print(error)
        }
    }
}

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

class CalcBoundartModel: Codable {
    var frameRect: CGRect = CGRect.null
    /// 移动方向，取值1：水平移动；取值2：竖直移动
    var translateDirection: String  = "1"
}
