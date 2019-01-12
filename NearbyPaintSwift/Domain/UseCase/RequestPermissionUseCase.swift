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
        let title = "Allow Nearby Paint to use Nearby?"
        let message = "Permission is required to share paint with nearby devices."
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let allowButton = "allow"
        let allowAction = UIAlertAction(title: allowButton, style: UIAlertAction.Style.default, handler:{(action: UIAlertAction!) in
            completion(true)
        })
        alertController.addAction(allowAction)
        
        let cancelButton = "cancel"
        let cancelAction = UIAlertAction(title: cancelButton, style: UIAlertAction.Style.default, handler:{(action: UIAlertAction!) in
            completion(false)
        })
        alertController.addAction(cancelAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
}
