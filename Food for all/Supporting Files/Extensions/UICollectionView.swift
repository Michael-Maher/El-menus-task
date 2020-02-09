//
//  UICollectionView.swift
//  Food for all
//
//  Created by Michael Maher on 2/9/20.
//  Copyright © 2020 MichaelMaher. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    func reloadCollectionView() {
        let indexPath = self.indexPathsForSelectedItems?.first //As we have single selection for tags collection so we need to keep selected item after reloadings
            self.reloadData()
            self.selectItem(at: indexPath, animated: false, scrollPosition: .init())
        }
}
