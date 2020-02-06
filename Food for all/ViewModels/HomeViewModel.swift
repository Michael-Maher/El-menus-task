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
}

protocol HomeModelToHomeControllerDelegate {
    func didFetchSingleTagData(singeTagItems: [Items]? , errorMsg: String?)
}

class HomeViewModel {
    
    var tagsList:[Tags] = []
    var singleTagItems:[Items] = []
    
    var delegateHomeModelToTagsTableCell: HomeModelToTagsTableCellDelegate?
    var delegateHomeModelToHomeController: HomeModelToHomeControllerDelegate?

    
    func initialDataLoading() {
        TagsModel.page = 1
        loadTagsData(page: TagsModel.page, tagsCompletionHandler: { (tags) in
            self.loadSingleTagData(tagName: tags.first?.tagName ?? "", tagItemsCompletionHandler: { (items) in
                print("\n\nFetching First page Data Done :\(tags.first?.tagName ?? "")")
            }) { (errorMsg) in
                print(errorMsg)
            }
        }) { (errorMsg) in
            self.delegateHomeModelToHomeController?.didFetchSingleTagData(singeTagItems: nil, errorMsg: errorMsg)
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
        loadSingleTagData(tagName: tagName, tagItemsCompletionHandler: { (items) in
            print("\n\nFetching \(tagName) items  Done :\(items)")
        }) { (errorMsg) in
            print("\n\nFetching \(tagName) items Error :\(errorMsg)")
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
