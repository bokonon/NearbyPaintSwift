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
    
    @IBOutlet weak var thicknessNumberLabel: DisappearLabel!
    
    @IBOutlet weak var captureResultLabel: DisappearLabel!
    
    private static let UserDefaultThicnessKey = "thickness"
    
    @IBOutlet weak var increaseThicnessButton: UIButton!
    
    @IBOutlet weak var reduceThicknessButton: UIButton!
    
    @IBOutlet weak var squareButton: UIButton!
    
    @IBOutlet weak var rectangleButton: UIButton!
    
    @IBOutlet weak var eraserButton: UIButton!
    
    var buttons: [UIButton] = []
    
    @IBAction func onTappedClear(_ sender: Any) {
        paintView.clearView()
        nearbyUseCase.publish(paintData: PaintData(width: 0, height: 0, clearFlg: 1, elementMode: 0, points: [], thickness: 0, red: 0, green: 0, blue: 0, alpha: 0))
    }
    
    @IBAction func onTappedBrush(_ sender: Any) {
        addThickness(value: 1)
        setButtonBackground(button: increaseThicnessButton)
    }
    
    @IBAction func onTappedBrushThin(_ sender: Any) {
        addThickness(value: -1)
        setButtonBackground(button: reduceThicknessButton)
    }
    
    @IBAction func onTappedSquare(_ sender: Any) {
        paintView.setElementMode(elementMode: .MODE_STAMP_SQUARE)
        setButtonBackground(button: squareButton)
    }
    
    @IBAction func onTappedRectangle(_ sender: Any) {
        paintView.setElementMode(elementMode: .MODE_STAMP_RECTANGLE)
        setButtonBackground(button: rectangleButton)
    }
    
    @IBAction func onTappedEraser(_ sender: Any) {
        paintView.setElementMode(elementMode: .MODE_ERASER)
        setButtonBackground(button: eraserButton)
    }
    
    @IBAction func onTappedSave(_ sender: Any) {
        if let image = paintView.getCapture() {
            captureUseCase.capture(image: image, sender: self, action: #selector(saveImageComplete(_:didFinishSavingWithError:contextInfo:)))
        }
    }
    
    @objc func saveImageComplete(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            print(error!.localizedDescription)
            captureResultLabel.text = "Capture failed :" + error!.localizedDescription
        } else {
            captureResultLabel.text = "Capture success"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UserDefaults.standard.register(defaults: [ViewController.UserDefaultThicnessKey : 2])
        let thickness = UserDefaults.standard.integer(forKey: ViewController.UserDefaultThicnessKey)
        thicknessNumberLabel.text = String(thickness)
        paintView.thickness = thickness
        paintView.delegate = self
        nearbyUseCase.delegate = self
        nearbyUseCase.subscribe()
        
        initButtons()
        setButtonBackground(button: increaseThicnessButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    private func addThickness(value: Int) {
        paintView.setElementMode(elementMode: .MODE_LINE)
        let thickness = paintView.addThickness(value: value)
        thicknessNumberLabel.text = String(thickness)
        UserDefaults.standard.set(thickness, forKey: ViewController.UserDefaultThicnessKey)
    }
    
    private func initButtons() {
        buttons.append(increaseThicnessButton)
        buttons.append(reduceThicknessButton)
        buttons.append(squareButton)
        buttons.append(rectangleButton)
        buttons.append(eraserButton)
        
        for button in buttons {
            button.layer.cornerRadius = 8
        }
    }
    
    private func setButtonBackground(button: UIButton) {
        for button in buttons {
            button.backgroundColor = UIColor.clear
        }
        
        button.backgroundColor = UIColor.lightGray
    }
    
}
