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
    var color :CGColor
    var width: CGFloat
    
    init(color: CGColor, width: CGFloat){
        self.color = color
        self.width = width
        self.points = []
    }
    
    func drawOnContext(context: CGContext){
        UIGraphicsPushContext(context)
        
        context.setStrokeColor(self.color)
        context.setLineWidth(self.width)
        context.setLineCap(CGLineCap.round)
        
        // Line needs two or more points
        if self.points.count > 1 {
            for (index, point) in self.points.enumerated() {
                if index == 0 {
                    context.move(to: point)
                } else {
                    context.addLine(to: point)
                }
            }
        }
        context.strokePath()
        
        UIGraphicsPopContext()
    }
}
