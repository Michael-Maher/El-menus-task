//
//  UINavigationBar.swift
//  Food for all
//
//  Created by Michael Maher on 2/7/20.
//  Copyright © 2020 MichaelMaher. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    
    func setupMainNavigationBar() {
        self.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationBar.shadowImage = nil
        self.navigationBar.barTintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 0.9686697346)
        self.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white,
                                                                        .font: UIFont.boldSystemFont(ofSize: 18)]
    }
    
    func setupClearNavigationBar() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black,
                                                                   .font : UIFont.boldSystemFont(ofSize: 17)]
    }
}
