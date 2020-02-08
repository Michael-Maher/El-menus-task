//
//  HomeViewModel.swift
//  Food for all
//
//  Created by Michael Maher on 2/6/20.
//  Copyright © 2020 MichaelMaher. All rights reserved.
//

import Foundation
import UIKit

protocol HomeModelToTagsTableCellDelegate {
    func didFetchTagsList(tags: [Tags]? , errorMsg: String?)
    func didReloadData()
}

protocol HomeModelToHomeControllerDelegate {
    func didFetchSingleTagData(singeTagItems: [Items]? , errorMsg: String?)
}

class HomeViewModel {
    
    var tagsList:[Tags] = []
    var singleTagItems:[Items] = []
    
    var delegateHomeModelToTagsTableCell: HomeModelToTagsTableCellDelegate?
    var delegateHomeModelToHomeController: HomeModelToHomeControllerDelegate?

    @objc
    func initialDataLoading(completion:@escaping(_ errorOccurred: Bool) -> Void) {
        TagsModel.page = 1
        self.tagsList.removeAll()
        loadTagsData(page: TagsModel.page, tagsCompletionHandler: { (tags) in
            self.loadSingleTagData(tagName: tags.first?.tagName ?? "", tagItemsCompletionHandler: { [unowned self] (items) in
                self.delegateHomeModelToTagsTableCell?.didReloadData()
                completion(true)
            }) { (errorMsg) in
                print(errorMsg)
                completion(false)
            }
        }) { (errorMsg) in
            self.delegateHomeModelToHomeController?.didFetchSingleTagData(singeTagItems: nil, errorMsg: errorMsg)
            completion(false)
        }
    }
    
    func loadTagsData(page: Int, tagsCompletionHandler:@escaping(_ tags:[Tags]) -> Void , failure:@escaping(_ error: String) -> Void) {
        NetworkManager.getTagsList(page: page, success: { [unowned self] (tags) in
            self.tagsList.append(contentsOf: tags)
            self.delegateHomeModelToTagsTableCell?.didFetchTagsList(tags: tags,errorMsg: nil)
            tagsCompletionHandler(tags)
        }) { (error) in
            print(error.localizedDescription)
            self.delegateHomeModelToTagsTableCell?.didFetchTagsList(tags: nil,errorMsg: error.localizedDescription)
            failure(error.localizedDescription)
        }
    }
    
    func loadSingleTagData(tagName: String, tagItemsCompletionHandler:@escaping(_ items:[Items]) -> Void , failure:@escaping(_ error: String) -> Void) {
        NetworkManager.getSingleTagItems(tagName: tagName, success: { [unowned self] (items) in
            self.singleTagItems = items
            self.delegateHomeModelToHomeController?.didFetchSingleTagData(singeTagItems: items, errorMsg: nil)

            tagItemsCompletionHandler(items)
        }) { (error) in
            print(error.localizedDescription)
            self.delegateHomeModelToHomeController?.didFetchSingleTagData(singeTagItems: nil, errorMsg: error.localizedDescription)

            failure(error.localizedDescription)
        }
    }
    
    func setupTagsCellDelegate(cell: TagsTableCell) {
        cell.delegateTagsCellToHomeModel = self
    }
}

extension HomeViewModel: TagsTableCellToHomeModel {
    func didSelectTag(tagName: String) {
        UIApplication.topViewController()?.view.addActivityIndicator()
        loadSingleTagData(tagName: tagName, tagItemsCompletionHandler: { (items) in
            print("\n\nFetching \(tagName) items  Done :\(items)")
          UIApplication.topViewController()?.view.removeActivityIndicatorView()
        }) { (errorMsg) in
            print("\n\nFetching \(tagName) items Error :\(errorMsg)")
            UIApplication.topViewController()?.view.removeActivityIndicatorView()
        }
    }
    
    func fetchTagsNextPage() {
        TagsModel.page += 1
        loadTagsData(page: TagsModel.page, tagsCompletionHandler: { (tags) in
            print("\n\nFetching new page Done :\(TagsModel.page)")
        }) { (errorMsg) in
             print("\n\nFetching new page Error :\(errorMsg)")
        }
    }
    
    
}
