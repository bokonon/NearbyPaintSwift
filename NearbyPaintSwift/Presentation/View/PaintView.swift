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
    var paintViewDelegate: PaintViewDelegate?
    
    var lines: [Line] = []
    var currentLine: Line? = nil
    
    var frameWidth: Int!
    var frameHeight: Int!
    
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
        let point = touches.first!.location(in: self)
        currentLine = Line(color: UIColor.black.cgColor, width: 1)
        currentLine?.points.append(point)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first!.location(in: self)
        currentLine?.points.append(point)
        self.setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Line needs two or more points
        if currentLine?.points.count ?? 0 > 1 {
            lines.append(currentLine!)
            
            let paintData = PaintData(width: frameWidth, height: frameHeight, points: (currentLine?.points)!, eraser: 0)
            // post data
            self.paintViewDelegate?.onDrawEnd(paintData: paintData)
        }
        
        currentLine = nil
        self.setNeedsDisplay()
    }
    
    func setDelegate(delegate: PaintViewDelegate) {
        self.paintViewDelegate = delegate
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
        
        let line = Line(color: UIColor.black.cgColor, width: 1)
        
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
    
    func getCapture() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
