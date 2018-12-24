//
//  PaintView.swift
//  NearbyPaintSwift
//
//  Created by yuji shimada on 2018/12/01.
//  Copyright © 2018 yuji shimada. All rights reserved.
//

import Foundation
import UIKit

protocol PaintViewDelegate {
    func onDrawEnd(paintData: PaintData)
}

class PaintView: UIView {
    var delegate: PaintViewDelegate?
    
    var lines: [Line] = []
    var currentLine: Line? = nil
    
    var frameWidth: Int!
    var frameHeight: Int!
    
    var downPoint: CGPoint = CGPoint()
    
    var elementMode = ElementMode.MODE_LINE
    var brushColor: CGColor = UIColor.black.cgColor
    var thickness: Int = 0
    
    // init from story board
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        print("init from story board")
        
        frameWidth = Int(self.frame.width)
        frameHeight = Int(self.frame.height)
        
        print("frameWidth : ", frameWidth)
        print("frameHeight : ", frameHeight)
    }
    
    // init from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        print("init from code")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        downPoint = touches.first!.location(in: self)
        currentLine = Line(color: brushColor, width: CGFloat(thickness))
        
        switch elementMode {
        case .MODE_ERASER:
            fallthrough
        case .MODE_LINE:
            currentLine?.points.append(downPoint)
        case .MODE_STAMP_SQUARE:
            print("square")
        case .MODE_STAMP_RECTANGLE:
            print("rectangle")
        default:
            print("default")
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first!.location(in: self)
        
        switch elementMode {
        case .MODE_ERASER:
            fallthrough
        case .MODE_LINE:
            self.currentLine?.points.append(point)
        case .MODE_STAMP_SQUARE:
            makeSquareStamp(downPoint: downPoint, point: point)
        case .MODE_STAMP_RECTANGLE:
            makeRectangleStamp(downPoint: downPoint, point: point)
        default:
            print("default")
        }
        
        self.setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Line needs two or more points
        if currentLine?.points.count ?? 0 > 1 {
            lines.append(currentLine!)
            
            let paintData = PaintData(width: frameWidth, height: frameHeight, points: (currentLine?.points)!, eraser: 0, thickness: Int(currentLine!.width), color: brushColor)
            // post data
            delegate?.onDrawEnd(paintData: paintData)
        }
        
        currentLine = nil
        self.setNeedsDisplay()
    }
    
    func resetContext(context: CGContext) {
        context.clear(self.bounds)
        if let color = self.backgroundColor {
            color.setFill()
        } else {
            UIColor.white.setFill()
        }
        context.fill(self.bounds)
    }
    
    // draw
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        // reset
        resetContext(context: context!)
        
        // drawn lines
        for line in lines {
            line.drawOnContext(context: context!)
        }
        
        // current line
        if let line = currentLine {
            line.drawOnContext(context: context!)
        }
    }
    
    func updateView(paintData: PaintData) {
        
        // eraser
        if paintData.eraserFlg == 1 {
            clearView()
            return
        }
        
        let line = Line(color: paintData.color, width: CGFloat(paintData.thickness))
        
        for point in paintData.points {
            line.points.append(CGPoint(
                x: point.x / CGFloat(paintData.canvasWidth) * CGFloat(frameWidth),
                y: point.y / CGFloat(paintData.canvasHeight) * CGFloat(frameHeight)))
            
            print("x : " + point.x.description)
            print("y : " + point.y.description)
        }
        lines.append(line)
        
        self.setNeedsDisplay()
    }
    
    func clearView() {
        lines = []
        
        self.setNeedsDisplay()
    }
    
    func setElementMode(elementMode: ElementMode) {
        self.elementMode = elementMode
        if (elementMode == .MODE_ERASER) {
            brushColor = UIColor.white.cgColor
        } else {
            brushColor = UIColor.black.cgColor
        }
    }
    
    func addThickness(value: Int) -> Int {
        thickness += value
        if (thickness < 1) {
            thickness = 1
        }
        return thickness
    }
    
    func getCapture() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    private func makeSquareStamp(downPoint: CGPoint, point: CGPoint) {
        let diffX = point.x - downPoint.x
        let diffY = point.y - downPoint.y
        let dx = pow(diffX, 2)
        let dy = pow(diffY, 2)
        
        let radius = sqrt(dx + dy)
        
        let topPoint = CGPoint(x: downPoint.x, y: downPoint.y - radius)
        let pointToTopDiffX = point.x - topPoint.x
        let pointToTopDiffY = point.y - topPoint.y
        let pointToTopDx = pow(pointToTopDiffX, 2)
        let pointToTopDy = pow(pointToTopDiffY, 2)
        let pointToTopDistance = sqrt(pointToTopDx + pointToTopDy)
        
        let ratio = (radius * radius + radius * radius - pointToTopDistance * pointToTopDistance) / ( 2 * radius * radius)
        var degree = acos(ratio) * CGFloat(180 / Double.pi)
        
        if (downPoint.x < point.x) {
            degree = -degree
        }
        
        let leftTopRadian = (degree + 315) * CGFloat(Double.pi / 180)
        let newLeftTopX = downPoint.x + radius * cos(leftTopRadian)
        let newLeftTopY = downPoint.y - radius * sin(leftTopRadian)
        let newLeftTop = CGPoint(x: newLeftTopX, y: newLeftTopY)
        
        let leftBottomRadian = (degree + 225) * CGFloat(Double.pi / 180)
        let newLeftBottomX = downPoint.x + radius * cos(leftBottomRadian)
        let newLeftBottomY = downPoint.y - radius * sin(leftBottomRadian)
        let newLeftBottom = CGPoint(x: newLeftBottomX, y: newLeftBottomY)
        
        let rightBottomRadian = (degree + 135) * CGFloat(Double.pi / 180)
        let newRightBottomX = downPoint.x + radius * cos(rightBottomRadian)
        let newRightBottomY = downPoint.y - radius * sin(rightBottomRadian)
        let newRightBottom = CGPoint(x: newRightBottomX, y: newRightBottomY)
        
        let rightTopRadian = (degree + 45) * CGFloat(Double.pi / 180)
        let newRightTopX = downPoint.x + radius * cos(rightTopRadian)
        let newRightTopY = downPoint.y - radius * sin(rightTopRadian)
        let newRightTop = CGPoint(x: newRightTopX, y: newRightTopY)
        
        currentLine?.points.removeAll()
        currentLine?.points.append(newLeftTop)
        currentLine?.points.append(newLeftBottom)
        currentLine?.points.append(newRightBottom)
        currentLine?.points.append(newRightTop)
        currentLine?.points.append(newLeftTop)
    }
    
    private func makeRectangleStamp(downPoint: CGPoint, point: CGPoint) {
        let diffX = point.x - downPoint.x
        let diffY = point.y - downPoint.y
        
        currentLine?.points.removeAll()
        currentLine?.points.append(CGPoint(x: downPoint.x - diffX, y: downPoint.y - diffY))
        currentLine?.points.append(CGPoint(x: downPoint.x - diffX, y: downPoint.y + diffY))
        currentLine?.points.append(CGPoint(x: downPoint.x + diffX, y: downPoint.y + diffY))
        currentLine?.points.append(CGPoint(x: downPoint.x + diffX, y: downPoint.y - diffY))
        currentLine?.points.append(CGPoint(x: downPoint.x - diffX, y: downPoint.y - diffY))
    }
}
