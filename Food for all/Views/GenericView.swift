//
//  GenericView.swift
//  Food for all
//
//  Created by Michael Maher on 2/6/20.
//  Copyright © 2020 MichaelMaher. All rights reserved.
//

import UIKit
import SnapKit

class GenericView: UIView {

    
    //==============
    //MARK: Show Error Message For Time
    //==============
    
    static func showErrorMsgForTime(errorMsg:String?, removeAfter:Double = 3.0) {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight: CGFloat = 100.0
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.9)
        view.alpha = 0
        
        let errorImageView = UIImageView(image: UIImage(named: "errorImage"))
        errorImageView.contentMode = .scaleAspectFit
        view.addSubview(errorImageView)
        errorImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(50)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
        }
        
        let errorLabel = UILabel()
        errorLabel.text = errorMsg ?? "Something went wrong !!"
        errorLabel.textColor = .white
        errorLabel.font = UIFont.boldSystemFont(ofSize: 15)
        errorLabel.numberOfLines = 0
        errorLabel.lineBreakMode = .byWordWrapping
        view.addSubview(errorLabel)
        errorLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(errorImageView.snp.trailing).offset(10)
            make.centerY.equalTo(errorImageView)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        UIApplication.shared.windows.first?.addSubview(view)
        UIView.animate(withDuration: 1.5, animations: {
            view.alpha = 1
        }, completion: { (_) in
            view.removeFromMainWindow(removeAfter: removeAfter)
        })
    }
    
}
