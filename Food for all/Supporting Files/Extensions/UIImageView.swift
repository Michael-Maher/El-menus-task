//
//  UIImageView.swift
//  Repos manger
//
//  Created by Michael Maher on 1/10/20.
//  Copyright © 2020 Michael Maher. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView {

//================================
//MARK: Create Image with URL path
//================================
    func setup(withImageUrlPath urlPath: String, cornerRadius: CGFloat?) {
    let encodedPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
    self.sd_imageTransition = .flipFromBottom
    self.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
    self.sd_setImage(with: URL(string: encodedPath ?? ""), placeholderImage: nil, options: [.retryFailed,.continueInBackground], completed: { (image, error, _, _) in
        DispatchQueue.main.async {
        if error == nil {
            print("download done")
            self.image = image
        } else {
            let anyImage = UIImage(named: "defaultUserAvatar")
            self.image = anyImage
            self.contentMode = .scaleAspectFill
            }
//            self.makeCircle(contentMode: .scaleAspectFit)
            if let radius = cornerRadius {
                self.layer.cornerRadius = radius
                self.clipsToBounds = true
            }
        }
    }) // setup image with URL path
    }
}
