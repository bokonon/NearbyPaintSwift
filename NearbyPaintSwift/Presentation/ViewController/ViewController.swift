//
//  ViewController.swift
//  NearbyPaintSwift
//
//  Created by yuji shimada on 2018/12/01.
//  Copyright © 2018 yuji shimada. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NearbyUseCaseDelegate, PaintViewDelegate {
    
    let nearbyUseCase = NearbyUseCase()
    
    let captureUseCase = CaptureUseCase()
    
    @IBOutlet weak var paintView: PaintView!
    
    @IBAction func didClear(_ sender: Any) {
        paintView.clearView()
        nearbyUseCase.publish(paintData: PaintData(width: 0, height: 0, points: [], eraser: 1))
    }
    
    @IBAction func didSave(_ sender: Any) {
        if let image = paintView.getCapture() {
            captureUseCase.capture(image: image)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paintView.setDelegate(delegate: self)
        nearbyUseCase.setDelegate(delegate: self)
        nearbyUseCase.subscribe()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        nearbyUseCase.unsubscribe()
    }
    
    // Delegate
    func subscribe(paintData: PaintData) {
        paintView.updateView(paintData: paintData)
    }
    
    func onDrawEnd(paintData: PaintData) {
        print("onDrawEnd")
        nearbyUseCase.publish(paintData: paintData)
    }
    
}

