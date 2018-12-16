//
//  NearbyUseCase.swift
//  NearbyPaintSwift
//
//  Created by yuji shimada on 2018/12/16.
//  Copyright © 2018 yuji shimada. All rights reserved.
//

import Foundation
import CoreGraphics

protocol NearbyUseCaseDelegate {
    func subscribe(paintData: PaintData)
}

class NearbyUseCase {
    
    let messageManager = GNSMessageManager(apiKey: Constant.api_key)
    
    var publication: GNSPublication?
    
    var subscription: GNSSubscription?
    
    var delegate: NearbyUseCaseDelegate?
    
    func setDelegate(delegate: NearbyUseCaseDelegate) {
        self.delegate = delegate
    }
    
    func subscribe() {
        print("subscribe")
        subscription = messageManager?.subscription(messageFoundHandler: { (message: GNSMessage?) in
            self.subscribe(message: message)
        },
        messageLostHandler: { (message: GNSMessage?) in
            if let content = message?.content {
                print("Lost message: \(String(describing: String(data: content, encoding: String.Encoding.utf8)))")
            } else {
                print("cannot convert message.content to String")
            }
        })
    }
    
    func publish(paintData: PaintData) {
        let dict: [String: AnyObject] = [
            "canvasWidth": paintData.canvasWidth as AnyObject,
            "canvasHeight": paintData.canvasHeight as AnyObject,
            "points": self.convertCGPointsToArrayValue(points: paintData.points),
            "eraserFlg": paintData.eraserFlg as AnyObject
        ]
        
        var json: String = ""
        do {
            // Dict -> JSON
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [])
            json = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        } catch {
            print("Error!: \(error)")
        }
        
        let strData = json.data(using: String.Encoding.utf8)
        let message = GNSMessage(content: strData)
        publication = messageManager?.publication(with: message)
        
        print("json : %@", json)
    }
    
    func unsubscribe() {
        self.publication = nil
        self.subscription = nil
    }
    
    private func subscribe(message: GNSMessage?) {
        print("subscribe with message")
        if (message == nil) {
            return
        }
        let messageStr = String(data: message!.content, encoding: String.Encoding.utf8)
        
        print("messageStr : " + messageStr!)
        
        if let data = messageStr?.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            
            do {
                print("subscript!")
                
                let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSDictionary
                
                let canvasWidth = jsonData.value(forKey: "canvasWidth") as! NSInteger
                let canvasHeight = jsonData.value(forKey: "canvasHeight") as! NSInteger
                let array = jsonData.value(forKey: "points") as! NSArray
                let eraserFlg = jsonData.value(forKey: "eraserFlg") as! NSInteger
                
                print("canvasWidth : " + canvasWidth.description)
                print("canvasHeight : " + canvasHeight.description)
                print("array : " + array.count.description)
                print(array)
                print("eraserFlg : " + eraserFlg.description)
                
                let paintData = PaintData(width: canvasWidth, height: canvasHeight, points: self.convertJSONToCGPoints(list: array), eraser: eraserFlg)
                print(paintData.points)
                
                self.delegate?.subscribe(paintData: paintData)
                
            } catch {
                print("Error!: \(error)")
            }
        }
        else {
            print("data is nil")
        }
    }
    
    private func convertJSONToCGPoints(list: NSArray) -> [CGPoint] {
        var points: [CGPoint] = []
        for dic in list {
            if let itemDict = dic as? NSDictionary {
                if let x = itemDict["x"] as? NSNumber, let y = itemDict["y"] as? NSNumber {
                    points.append(CGPoint(x: CGFloat(x.floatValue), y: CGFloat(y.floatValue)))
                }
            }
        }
        return points
    }
    
    private func convertCGPointsToArrayValue(points: [CGPoint]) -> NSArray {
        var valueArray: [NSDictionary] = []
        for point in points {
            let itemDict: NSDictionary = NSMutableDictionary()
            itemDict.setValue(NSNumber(value: Float(point.x)), forKey: "x")
            itemDict.setValue(NSNumber(value: Float(point.y)), forKey: "y")
            valueArray.append(itemDict)
        }
        return valueArray as NSArray
    }
}
