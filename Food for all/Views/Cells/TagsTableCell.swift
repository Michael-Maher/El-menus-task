//
//  TagsTableCell.swift
//  Food for all
//
//  Created by Michael Maher on 2/5/20.
//  Copyright © 2020 MichaelMaher. All rights reserved.
//

import Foundation
import UIKit

//==============
//MARK: These methods to handle actions from Tags Table Cell to home view model
//==============
protocol TagsTableCellToHomeModel {
        func didSelectTag (tagName: String)
        func fetchTagsNextPage()
}

class TagsTableCell: UITableViewCell {
    
    //========================
    //MARK: Variables
    //========================
    static let identifier = "TagsTableCell" // cell identifier
    var delegateTagsCellToHomeModel: TagsTableCellToHomeModel?
    var selectedIndexPath: IndexPath?
    let firstCell = IndexPath(row: 0, section: 0) // pre selected cell in the tags list
    
    var homeViewModel: HomeViewModel?
    
    //========================
    //MARK: Outlets
    //========================
    lazy var tagsCollectionView: UICollectionView = {
        let width = UIScreen.main.bounds.width * 0.25
        let height = width * 1.75
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: width, height: height)
        
        layout.sectionInset = UIEdgeInsets(top: 30, left: 10, bottom: 30, right: 0)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = false
        collectionView.allowsSelection = true
        
        collectionView.register(TagsCollectionCell.self, forCellWithReuseIdentifier: TagsCollectionCell.identifier)
        return collectionView
    }()
    
    //========================
    //MARK: Init methods
    //========================
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCellLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //========================
    //MARK: UI Configurations methods
    //========================
    func configureCellLayout() {
        self.addSubview(tagsCollectionView)
        tagsCollectionView.snp.makeConstraints { (make) in
            make.height.equalTo(170)
            make.edges.equalToSuperview()
        }
    } // configureCellLayout
    
    func setupViewModel(viewModel:HomeViewModel) {
        self.homeViewModel = viewModel
        self.homeViewModel?.delegateHomeModelToTagsTableCell = self
    } // setupViewModel
    
}
