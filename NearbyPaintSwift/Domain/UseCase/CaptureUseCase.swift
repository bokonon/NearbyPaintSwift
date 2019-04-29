//
//  CaptureUseCase.swift
//  NearbyPaintSwift
//
//  Created by yuji shimada on 2018/12/16.
//  Copyright © 2018 yuji shimada. All rights reserved.
//

import UIKit

class CaptureUseCase: NSObject {
  
  func capture(image: UIImage, sender: Any, action: Selector) {
    UIImageWriteToSavedPhotosAlbum(image, sender, action, nil)
  }
  
}

