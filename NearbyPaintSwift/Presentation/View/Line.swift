//
//  Line.swift
//  NearbyPaintSwift
//
//  Created by yuji shimada on 2018/12/01.
//  Copyright © 2018 yuji shimada. All rights reserved.
//

import UIKit

class Line {
    var points: [CGPoint]
    var elementMode: ElementMode
    var color :CGColor
    var width: CGFloat
    
    init(elementMode: ElementMode, color: CGColor, width: CGFloat) {
        self.elementMode = elementMode
        self.color = color
        self.width = width
        self.points = []
    }
    
    func draw() {
        // with UIBezierPath
        let path = UIBezierPath()
        if self.points.count > 1 {
            for (index, point) in self.points.enumerated() {
                if index == 0 {
                    path.move(to: point)
                } else {
                    if (elementMode == .MODE_ERASER
                        || elementMode == .MODE_LINE) {
                        // with addQuadCurve
                        let prePoint = points[index - 1]
                        let controllPoint = CGPoint(x: (prePoint.x + point.x) / 2, y: (prePoint.y + point.y) / 2)
                        path.addQuadCurve(to: point, controlPoint: controllPoint)
                    } else {
                        // with addLine
                        path.addLine(to: point)
                    }
                    
                }
            }
        }
        
        UIColor(cgColor: color).setStroke()
        path.stroke()
    }
    
}
