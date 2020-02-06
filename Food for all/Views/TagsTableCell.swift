//
//  TagsTableCell.swift
//  Food for all
//
//  Created by Michael Maher on 2/5/20.
//  Copyright © 2020 MichaelMaher. All rights reserved.
//

import Foundation
import UIKit

protocol TagsCollectionViewDelegate {
    func didSelectTag (tagName: String)
}

class TagsTableCell: UITableViewCell {
    
    static let identifier = "TagsTableCell"
    var delegate: TagsCollectionViewDelegate?
    var selectedIndexPath: IndexPath?

    var tagsList: [Tags] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tagsCollectionView.reloadData()
            }
        }
    }
    
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
}



extension TagsTableCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Number of list: \n\n\(tagsList.count)")
        return tagsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagsCollectionCell.identifier, for: indexPath)
            as? TagsCollectionCell else {
                return UICollectionViewCell()
        }
        cell.configureCell(withTag: tagsList[indexPath.row] , isSelected: selectedIndexPath == indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == tagsList.count - 1 {
            TagsModel.page += 1
            NetworkManager.getTagsList(page: TagsModel.page, success: { [unowned self] (tags) in
                self.tagsList.append(contentsOf: tags)
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TagsCollectionCell else { return }

        cell.cellSelectionConfiguration()
        delegate?.didSelectTag(tagName: tagsList[indexPath.row].tagName ?? "")
        self.selectedIndexPath = indexPath
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
         guard let cell = collectionView.cellForItem(at: indexPath) as? TagsCollectionCell else { return }
             cell.cellDeSelectionConfiguration()
         self.selectedIndexPath = nil

    }
    
    
}
