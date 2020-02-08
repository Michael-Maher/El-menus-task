//
//  UIView.swift
//  Repos manger
//
//  Created by Michael Maher on 1/9/20.
//  Copyright © 2020 Michael Maher. All rights reserved.
//

import Foundation
import UIKit
import Lottie
import SnapKit

enum AnimationJSON : String {
    case foodAnimation = "FoodAnimation"
}

extension UIView {
    
    //==================================
    //MARK: Add Activity Indicator View
    //==================================
    func addActivityIndicator() {
        if let foundView = self.viewWithTag(ViewsTag.kLoadingBackGroundViewTag.rawValue) {
            foundView.removeFromSuperview()
        }
        let loadingView = UIActivityIndicatorView(style: .whiteLarge)
        loadingView.color = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        loadingView.tag = ViewsTag.kActivityIndicatorTag.rawValue
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.5)
        backgroundView.layer.cornerRadius = 15
        backgroundView.tag = ViewsTag.kLoadingBackGroundViewTag.rawValue

        addSubview(backgroundView)
        backgroundView.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        backgroundView.addSubview(loadingView)
        loadingView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        loadingView.startAnimating()
    } // addAnimatedLoadingView
       
       
       //==================================
       //MARK: Remove Activity Indicator View
       //==================================
       func removeActivityIndicatorView() {
        guard let backGroundLoadingView = viewWithTag(ViewsTag.kLoadingBackGroundViewTag.rawValue),
            let loadingView = backGroundLoadingView.viewWithTag(ViewsTag.kActivityIndicatorTag.rawValue) as? UIActivityIndicatorView else { return }
           
           UIView.animate(withDuration: 0.2, animations: {
               backGroundLoadingView.alpha = 0
           }) { _ in
               loadingView.stopAnimating()
               backGroundLoadingView.removeFromSuperview()
           }
       } // removeAnimatedLoadingView
    
    //===============================
    //MARK: Add Animated Loading View
    //===============================
    func addAnimatedLoadingView(animationJSON : AnimationJSON) {
        if let foundView = self.viewWithTag(ViewsTag.kAnimationViewTag.rawValue) {
            foundView.removeFromSuperview()
        }
        let loadingView = AnimationView(name: animationJSON.rawValue)
        loadingView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.loopMode = .loop
        loadingView.tag = ViewsTag.kAnimationViewTag.rawValue
        
        addSubview(loadingView)
 
        loadingView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.snp.edges)
        }
        
        loadingView.play()
        
    } // addAnimatedLoadingView
    
    
    //==================================
    //MARK: Remove Animated Loading View
    //==================================
    func removeAnimatedLoadingView() {
        guard let loadingView = viewWithTag(ViewsTag.kAnimationViewTag.rawValue) as? AnimationView else { return }
        
        UIView.animate(withDuration: 0.2, animations: {
            loadingView.alpha = 0
        }) { _ in
            loadingView.removeFromSuperview()
        }
    } // removeAnimatedLoadingView
    
    //=================
    //MARK: Mask Circle
    //=================
    func makeCircle(contentMode: ContentMode) {
        switch contentMode {
        case .scaleAspectFit :
            self.contentMode = UIView.ContentMode.scaleAspectFit
        case .center :
            self.contentMode = UIView.ContentMode.center
        default :
            self.contentMode = UIView.ContentMode.scaleAspectFill
        }
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
        // make square(* must to make circle),
        // resize(reduce the kilobyte) and
        // fix rotation.
    }// maskCircle
    
    //=================
    //MARK: Drop Shadow
    //=================
    func dropShadow() {
        layer.shadowOpacity = 1
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        layer.shadowRadius = 4

    } // dropShadow
    
    //=================
    //MARK: Remove From Main Window
    //=================
    func removeFromMainWindow(removeAfter: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + removeAfter) {
            UIView.animate(withDuration: 1.5, animations: {
                self.alpha = 0
            }) { (_) in
                self.removeFromSuperview()
            }
        }
    }
}
