//
//  UIApplication.swift
//  Repos manger
//
//  Created by Michael Maher on 1/13/20.
//  Copyright © 2020 Michael Maher. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    
    //=========================
    //MARK: Top View Controller
    //=========================
    
    /// Get an instance of the top view controller which appeares on screen.
    ///
    /// - Parameter baseViewController: parent class to start with it and make recursion operation to get top view controller
    /// - Returns: an instance of the top view controller
    
    class func topViewController(baseViewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        guard let navigationController = baseViewController as? UINavigationController else {
            if let tabBarViewController = baseViewController as? UITabBarController {
                
                let moreNavigationController = tabBarViewController.moreNavigationController
                if let mostTopViewController = moreNavigationController.topViewController, mostTopViewController.view.window != nil {
                    return topViewController(baseViewController:mostTopViewController)
                } else if let selectedViewController = tabBarViewController.selectedViewController {
                    return topViewController(baseViewController: selectedViewController)
                }
            }
            
            guard let splitViewController = baseViewController as? UISplitViewController, splitViewController.viewControllers.count == 1 else {
                guard let presentedViewController = baseViewController?.presentedViewController else {
                    return baseViewController
                }
                return topViewController(baseViewController: presentedViewController)
            }
            return topViewController(baseViewController: splitViewController.viewControllers[0])
        }
        return topViewController(baseViewController: navigationController.visibleViewController)

    } // topViewController
} // UIApplication
