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
            label.backgroundColor = kBackgroundColors[index]
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
        if let insertPoint = spaceModel.currentPoint, let hValue = GenerateUtils.transferToNumber(str: hPerTextField.stringValue), let vValue = GenerateUtils.transferToNumber(str: vPerTextField.stringValue) {
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
    
    @IBAction func cleanAction(_ sender: Any) {
        spaceModel = SpaceModel()
        regenerateContentViews()
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
            
//            var tempBoundary: [CalcBoundartModel] = []
            
            var vectorNodes: [VectorNode] = []
            
            for (index, frameModel) in spaceModel.datas.enumerated() {
                let photoPiece = PhotoPiece()
                
                //frames
                photoPiece.frameRectArray = [radioType.frameStrs(frameModel)]
                
//                let frameRect = radioType.frameRect(frameModel)
                
                // 生成未进行合并的boundart集合
//                generateTempBoundary(frameRect, &tempBoundary)
                
                photoPiece.photoIndex = "\(index)"
                // 生成左上右下是否有邻居
                GenerateUtils.generateBorderHasNeighbors(frameModel, photoPiece)
                
                let vectors = frameModel.vectors(frameSize: radioType.frameSize())
                for (positionIndex, vector) in vectors.enumerated() {
                    if let position = VectorNodePosition(rawValue: positionIndex) {
                        var exitVectorNode: VectorNode?
                        for vectorNode in vectorNodes {
                            if vectorNode.isVector(photo: photoPiece, origin: vector) {
                                exitVectorNode = vectorNode
                                break
                            }
                        }
                        if let exitVectorNode = exitVectorNode {
                            exitVectorNode.addPhotoIndexs(photoIndex: photoPiece.photoIndex, position: position)
                        } else {
                            vectorNodes.append(VectorNode(photo: photoPiece, origin: vector, position: position))
                        }
                    }
                }
                
                //TODO topBoundarys
                
                photoPuzzles.append(photoPiece)
            }
            
            var hVectors: [Int: [VectorNode]] = [:]
            var vVectors: [Int: [VectorNode]] = [:]
            for vectorItem in vectorNodes {
                let x = Int(vectorItem.origin.x)
                let y = Int(vectorItem.origin.y)
                if hVectors.keys.contains(x) {
                    hVectors[x]?.append(vectorItem)
                } else {
                    hVectors[x] = [vectorItem]
                }
                if vVectors.keys.contains(y) {
                    vVectors[y]?.append(vectorItem)
                } else {
                    vVectors[y] = [vectorItem]
                }
            }
            
            var boundarys: [BoundaryPiece] = []
            for x in hVectors.keys {
                if x == 0 || x == Int(radioType.frameSize().width) { // 0的位置和最右不需要设置边界
                    continue
                }
                if let currentVectors = hVectors[x], currentVectors.count > 1 { // 至少两个点，数据无异常情况不可能只有一个点
                    let (maxY, minY, photoIndexSet) = currentVectors.reduce((0, Int(radioType.frameSize().height), Set<String>())) { (tempResult, node) -> (Int, Int, Set<String>) in
                        return (max(tempResult.0, Int(node.origin.y)), min(tempResult.1, Int(node.origin.y)), tempResult.2.union(node.photoIndexs.filter { $0 != "-1" }))
                    }
                    let boundartItem = BoundaryPiece(CGPoint(x: x, y: minY), endPoint: CGPoint(x: x, y: maxY), isH: true)
                    boundartItem.patchesDividedBy = photoIndexSet.sorted().joined(separator: ",")
                    boundarys.append(boundartItem)
                }
            }
            for y in vVectors.keys {
                if y == 0 || y == Int(radioType.frameSize().height) { // 0的位置和最右不需要设置边界
                    continue
                }
                if let currentVectors = vVectors[y], currentVectors.count > 1 { // 至少两个点，数据无异常情况不可能只有一个点
                    let (maxX, minX, photoIndexSet) = currentVectors.reduce((0, Int(radioType.frameSize().width), Set<String>())) { (tempResult, node) -> (Int, Int, Set<String>) in
                        return (max(tempResult.0, Int(node.origin.x)), min(tempResult.1, Int(node.origin.x)), tempResult.2.union(node.photoIndexs.filter { $0 != "-1" }))
                    }
                    let boundartItem = BoundaryPiece(CGPoint(x: minX, y: y), endPoint: CGPoint(x: maxX, y: y), isH: false)
                    boundartItem.patchesDividedBy = photoIndexSet.sorted().joined(separator: ",")
                    boundarys.append(boundartItem)
                }
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
