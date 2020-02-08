//
//  HomeViewModel.swift
//  Food for all
//
//  Created by Michael Maher on 2/6/20.
//  Copyright © 2020 MichaelMaher. All rights reserved.
//

import Foundation
import UIKit

//==============
//MARK: These methods to handle actions from view model to Tags Table Cell
//==============
protocol HomeModelToTagsTableCellDelegate {
    func didFetchTagsList(tags: [Tags]? , errorMsg: String?)
}
//==============
//MARK: These methods to handle actions from view model to Home Controller
//==============
protocol HomeModelToHomeControllerDelegate {
    func didFetchSingleTagData(singeTagItems: [Items]? , errorMsg: String?)
}

class HomeViewModel {
    
    //==============
    //MARK: Instance Variables
    //==============
    var tagsList:[Tags] = []
    var singleTagItems:[Items] = []
    
    //==============
    //MARK: Delegates
    //==============
    var delegateHomeModelToTagsTableCell: HomeModelToTagsTableCellDelegate?
    var delegateHomeModelToHomeController: HomeModelToHomeControllerDelegate?

    //==============
    //MARK: Loading data methods
    //==============
    @objc
    func initialDataLoading(completion:@escaping(_ errorOccurred: Bool) -> Void) {
        TagsModel.page = 1 // reset tags page to be 1
        self.tagsList.removeAll() // reset tagsList array
        loadTagsData(page: TagsModel.page, tagsCompletionHandler: { (tags) in
            print("\n\nFetching new page Done :\(TagsModel.page)")
            completion(true)
        }) { (errorMsg) in
            print("\n\nFetching new page Error :\(errorMsg)")
            completion(false)
        }
    } // initialLoading
    
    func loadTagsData(page: Int, tagsCompletionHandler:@escaping(_ tags:[Tags]) -> Void , failure:@escaping(_ error: String) -> Void) {
        NetworkManager.getTagsList(page: page, success: { [unowned self] (tags) in
            self.tagsList.append(contentsOf: tags) // append new data into the previous arrays
            self.delegateHomeModelToTagsTableCell?.didFetchTagsList(tags: tags,errorMsg: nil)
            tagsCompletionHandler(tags)
        }) { (error) in
            print(error.localizedDescription)
            self.delegateHomeModelToTagsTableCell?.didFetchTagsList(tags: nil,errorMsg: error.localizedDescription)
            failure(error.localizedDescription)
        }
    } // loadTagsData
    
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
    } // loadSingleTagData
    
    //==============
    //MARK: Setup delegate
    //==============
    func setupTagsCellDelegate(cell: TagsTableCell) {
        cell.delegateTagsCellToHomeModel = self
    } // setupTagsCellDelegate
}

//==============
//MARK: TagsTableCellToHomeModel delegate methods implementation
//==============
extension HomeViewModel: TagsTableCellToHomeModel {
    func didSelectTag(tagName: String) {    // Implement did select tag from tags collection so we should fetch its items
        UIApplication.topViewController()?.view.addActivityIndicator() // add loading view in front of top view controller (Home view controller in our case)
        loadSingleTagData(tagName: tagName, tagItemsCompletionHandler: { (items) in
            print("\n\nFetching \(tagName) items  Done :\(items)")
          UIApplication.topViewController()?.view.removeActivityIndicatorView()
        }) { (errorMsg) in
            print("\n\nFetching \(tagName) items Error :\(errorMsg)")
            UIApplication.topViewController()?.view.removeActivityIndicatorView()
        }
    } // didSelectTag
    
    func fetchTagsNextPage() { // fetch new page from tags
        TagsModel.page += 1 // increment page counter
        loadTagsData(page: TagsModel.page, tagsCompletionHandler: { (tags) in
            print("\n\nFetching new page Done :\(TagsModel.page)")
        }) { (errorMsg) in
             print("\n\nFetching new page Error :\(errorMsg)")
        }
    } // fetchTagsNextPage
    
    
}
