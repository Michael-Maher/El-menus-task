//
//  TagsTableCell.swift
//  Food for all
//
//  Created by Michael Maher on 2/5/20.
//  Copyright © 2020 MichaelMaher. All rights reserved.
//

import Foundation
import UIKit

class TagsTableCell: UITableViewCell {
    
    static let identifier = "TagsTableCell"
    
    lazy var tagsCollectionView: UICollectionView = {
        let width = UIScreen.main.bounds.width * 0.25
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: width, height: 50)
        
//        layout.sectionInset = UIEdgeInsets(top: 44, left: 10, bottom: 10, right: 10)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 5 // or any value you want
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .red
        collectionView.isPagingEnabled = true
        
        collectionView.register(TagsCollectionCell.self, forCellWithReuseIdentifier: TagsCollectionCell.identifier)
        return collectionView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCellLayout()
        //        configureFontsAndUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TagsTableCell {
    func configureCellLayout() {
     
        self.addSubview(tagsCollectionView)
        tagsCollectionView.snp.makeConstraints { (make) in
            make.height.equalTo(100)
            make.edges.equalToSuperview()
        }
    }
}

