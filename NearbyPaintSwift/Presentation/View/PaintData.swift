//
//  PaintData.swift
//  NearbyPaintSwift
//
//  Created by yuji shimada on 2018/12/01.
//  Copyright © 2018 yuji shimada. All rights reserved.
//

import UIKit
import CoreGraphics

class PaintData {
  
  var canvasWidth: Int
  
  var canvasHeight: Int
  
  var clearFlg: Int
  
  var elementMode: Int
  
  var points: [CGPoint]
  
  var thickness: Int
  
  var color: CGColor
  
  var red: CGFloat
  var green: CGFloat
  var blue: CGFloat
  var alpha: CGFloat
  
  // init paint data
  init(width: Int, height: Int, clearFlg: Int, elementMode: Int, points: [CGPoint], thickness: Int, color: CGColor) {
    self.canvasWidth = width
    self.canvasHeight = height
    self.clearFlg = clearFlg
    self.elementMode = elementMode
    self.points = points
    self.thickness = thickness
    
    self.color = color
    
    self.red = 0
    self.green = 0
    self.blue = 0
    self.alpha = 1.0
    UIColor(cgColor: color).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    
    // 0.0 ~ 1.0 to 0 ~ 255
    self.red = self.red * 255.0
    self.green = self.green * 255.0
    self.blue = self.blue * 255.0
    self.alpha = self.alpha * 255.0
  }
  
  init(width: Int, height: Int, clearFlg: Int, elementMode: Int, points: [CGPoint], thickness: Int, red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
    self.canvasWidth = width
    self.canvasHeight = height
    self.clearFlg = clearFlg
    self.elementMode = elementMode
    self.points = points
    self.thickness = thickness
    
    self.red = red
    self.green = green
    self.blue = blue
    self.alpha = alpha
    self.color = UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha / 255.0).cgColor
  }
  
}

