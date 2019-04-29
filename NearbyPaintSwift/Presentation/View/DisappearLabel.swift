//
//  DisappearLabel.swift
//  NearbyPaintSwift
//
//  Created by yuji shimada on 2018/12/24.
//  Copyright © 2018 yuji shimada. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class DisappearLabel: UILabel {
  
  @IBInspectable var borderWidth: CGFloat = 2.0
  @IBInspectable var cornerRadius: CGFloat = 8.0
  
  @IBInspectable var topInset: CGFloat = 8.0
  @IBInspectable var bottomInset: CGFloat = 8.0
  @IBInspectable var leftInset: CGFloat = 12.0
  @IBInspectable var rightInset: CGFloat = 12.0
  
  @IBInspectable var disappearDuration: Double = 1.0
  
  override var text: String? {
    didSet {
      if text != nil {
        disappearView()
      } else {
        print("DisappearLabel text is nil")
      }
    }
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    self.layer.borderWidth = borderWidth
    self.layer.cornerRadius = cornerRadius
    self.layer.borderColor = UIColor.lightGray.cgColor
    self.layer.masksToBounds = true
  }
  
  override func drawText(in rect: CGRect) {
    let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
    super.drawText(in: rect.inset(by: insets))
  }
  
  override var intrinsicContentSize: CGSize {
    let size = super.intrinsicContentSize
    return CGSize(width: size.width + leftInset + rightInset,
                  height: size.height + topInset + bottomInset)
  }
  
  func disappearView() {
    self.alpha = 1.0
    UIView.animate(withDuration: disappearDuration, delay: 0.0, options: [.curveEaseIn], animations: {
      self.alpha = 0.0
    }, completion: nil)
  }
}

