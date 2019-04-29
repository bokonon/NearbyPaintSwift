//
//  RequestPermissionUseCase.swift
//  NearbyPaintSwift
//
//  Created by yuji shimada on 2019/01/12.
//  Copyright © 2019 yuji shimada. All rights reserved.
//

import UIKit

extension UIApplication {
  class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
    if let navigationController = controller as? UINavigationController {
      return topViewController(controller: navigationController.visibleViewController)
    }
    if let tabController = controller as? UITabBarController {
      if let selected = tabController.selectedViewController {
        return topViewController(controller: selected)
      }
    }
    if let presented = controller?.presentedViewController {
      return topViewController(controller: presented)
    }
    return controller
  }
}

class RequestPermissionUseCase {
  
  func requestPermission(completion: @escaping (Bool) -> Void) {
    if let topController = UIApplication.topViewController() {
      showPermissionDialog(viewController: topController, completion: completion)
    }
  }
  
  private func showPermissionDialog(viewController: UIViewController, completion: @escaping (Bool) -> Void) {
    let title = "Allow Nearby Paint to access your location and microphone while using this app?"
    let message = "This allows us to use your location and microphone to provide you connecting to your nearby devices for sharing paint. We will not use those personal information for any purpose other than connecting to other devices."
    let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    
    let cancelButton = "Cancel"
    let cancelAction = UIAlertAction(title: cancelButton, style: UIAlertAction.Style.default, handler:{(action: UIAlertAction!) in
      completion(false)
    })
    alertController.addAction(cancelAction)
    
    let allowButton = "Allow"
    let allowAction = UIAlertAction(title: allowButton, style: UIAlertAction.Style.default, handler:{(action: UIAlertAction!) in
      completion(true)
    })
    alertController.addAction(allowAction)
    
    viewController.present(alertController, animated: true, completion: nil)
  }
  
}

