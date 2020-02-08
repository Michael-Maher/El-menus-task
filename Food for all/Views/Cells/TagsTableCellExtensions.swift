//
//  TagsTableCellExtensions.swift
//  Food for all
//
//  Created by Michael Maher on 2/8/20.
//  Copyright © 2020 MichaelMaher. All rights reserved.
//

import Foundation
import UIKit

extension TagsTableCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.homeViewModel?.tagsList.count ?? 0
    } // numberOfItemsInSections
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagsCollectionCell.identifier, for: indexPath)
            as? TagsCollectionCell,
            let singleTag = self.homeViewModel?.tagsList[indexPath.row] else {
                return UICollectionViewCell()
        }
        
        if selectedIndexPath == nil { // if there's no selected tag, select first cell to be preselected one
            self.tagsCollectionView.selectItem(at: firstCell, animated: false, scrollPosition: .init())
            self.collectionView(tagsCollectionView, didSelectItemAt: firstCell)
        }
        
        cell.configureCell(withTag: singleTag)
        
        return cell
    } // cellForItemAt
}

extension TagsTableCell: HomeModelToTagsTableCellDelegate, UICollectionViewDelegate {
    //========================
    //MARK: Collection view delegate methods
    //========================
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let tagList = homeViewModel?.tagsList else { return }
        
        if indexPath.row == tagList.count - 1 { // if it's last tag, then fetch next page of tags
            delegateTagsCellToHomeModel?.fetchTagsNextPage()
        }
    } // willDisplay
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let singleTag = self.homeViewModel?.tagsList[indexPath.row],
            let cell = collectionView.cellForItem(at: indexPath) as? TagsCollectionCell else { return }
        cell.cellSelectionConfiguration()
        delegateTagsCellToHomeModel?.didSelectTag(tagName: singleTag.tagName ?? "")
        self.selectedIndexPath = indexPath
    } // didSelectItemAt

    //========================
    //MARK: HomeModelToTagsTableCellDelegate methods implementation
    //========================

    func didFetchTagsList(tags: [Tags]?, errorMsg: String?) {
        if tags != nil {
            if TagsModel.page == 1 { // This condition tells us that user reloads all tags (using pull to refresh), so we reset selectedIndexPath to preselect first tag again
                selectedIndexPath = nil
            }
            self.tagsCollectionView.reloadCollectionView()
        } else {
            GenericView.showErrorMsgForTime(errorMsg: errorMsg)
        }
    }
    
    
}

