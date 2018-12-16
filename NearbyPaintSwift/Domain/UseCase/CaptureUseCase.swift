//
//  CaptureUseCase.swift
//  NearbyPaintSwift
//
//  Created by yuji shimada on 2018/12/16.
//  Copyright © 2018 yuji shimada. All rights reserved.
//

import UIKit

class CaptureUseCase: NSObject {
    
    func capture(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveImageComplete(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func saveImageComplete(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            print(error!)
        }
    }
}
