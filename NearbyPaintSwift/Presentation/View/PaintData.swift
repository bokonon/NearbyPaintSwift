//
//  PaintData.swift
//  NearbyPaintSwift
//
//  Created by yuji shimada on 2018/12/01.
//  Copyright © 2018 yuji shimada. All rights reserved.
//

import CoreGraphics

class PaintData {
    
    var canvasWidth: Int
    
    var canvasHeight: Int
    
    var points: [CGPoint]
    
    var eraserFlg: Int
    
    // init paint data
    init(width: Int, height: Int, points: [CGPoint], eraser: Int) {
        self.canvasWidth = width
        self.canvasHeight = height
        self.points = points
        self.eraserFlg = eraser
    }
    
}
