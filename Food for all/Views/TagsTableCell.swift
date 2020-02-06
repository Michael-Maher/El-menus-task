//
//  TagsTableCell.swift
//  Food for all
//
//  Created by Michael Maher on 2/5/20.
//  Copyright © 2020 MichaelMaher. All rights reserved.
//

import Foundation
import UIKit

protocol TagsTableCellToHomeModel {
    func didSelectTag (tagName: String)
    func fetchTagsNextPage ()
}

class TagsTableCell: UITableViewCell {
    
    static let identifier = "TagsTableCell"
    var delegateTagsCellToHomeModel: TagsTableCellToHomeModel?
    var selectedIndexPath: IndexPath?

    var homeViewModel: HomeViewModel?
    
    lazy var tagsCollectionView: UICollectionView = {
        let width = UIScreen.main.bounds.width * 0.25
        let height = width * 1.75
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: width, height: height)
        
        layout.sectionInset = UIEdgeInsets(top: 30, left: 10, bottom: 30, right: 0)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = false
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
            make.height.equalTo(170)
//            make.leading.equalToSuperview().offset(10)
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        tagsCollectionView.reloadData()
    }
    
    func setupViewModel(viewModel:HomeViewModel) {
        self.homeViewModel = viewModel
        self.homeViewModel?.delegateHomeModelToTagsTableCell = self
    }
}



extension TagsTableCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print("Number of list: \n\n\(tagsList.count)")
        return self.homeViewModel?.tagsList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagsCollectionCell.identifier, for: indexPath)
            as? TagsCollectionCell,
            let singleTag = self.homeViewModel?.tagsList[indexPath.row] else {
                return UICollectionViewCell()
        }
        cell.configureCell(withTag: singleTag, isSelected: selectedIndexPath == indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let tagList = homeViewModel?.tagsList else { return }
        
        if indexPath.row == tagList.count - 1 {
            delegateTagsCellToHomeModel?.fetchTagsNextPage()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TagsCollectionCell,
        let singleTag = self.homeViewModel?.tagsList[indexPath.row] else { return }

        cell.cellSelectionConfiguration()
        delegateTagsCellToHomeModel?.didSelectTag(tagName: singleTag.tagName ?? "")
        self.selectedIndexPath = indexPath
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
         guard let cell = collectionView.cellForItem(at: indexPath) as? TagsCollectionCell else { return }
             cell.cellDeSelectionConfiguration()
         self.selectedIndexPath = nil

    }
    
    
}

extension TagsTableCell: HomeModelToTagsTableCellDelegate {
    func didFetchTagsList(tags: [Tags]?, errorMsg: String?) {
        guard let _ = tags else { return }
        
        DispatchQueue.main.async {
            self.tagsCollectionView.reloadData()
        }
    }
}
