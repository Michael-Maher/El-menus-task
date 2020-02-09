//
//  NetworkManger.swift
//  Food for all
//
//  Created by Michael Maher on 1/9/20.
//  Copyright © 2020 Michael Maher. All rights reserved.
//

import Foundation
import Moya

struct NetworkManager {
    
    static let tagsProvider =
        MoyaProvider<TagsProvider>(plugins: [NetworkLoggerPlugin(verbose: true),LocalDataHandler()]) // make moya provider with API caching feature
    
    static let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
    
    //============
    //MARK: getTagsList
    //============
    static func getTagsList(page: Int, success: @escaping(_ success: [Tags]) -> Void, failure: @escaping(_ error: Error) -> Void ) {
        tagsProvider.request(
        .getTagsList(page: page)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let responseModel = try jsonDecoder.decode(TagsModel.self, from: response.data)
                    success(responseModel.tags ?? [])
                } catch (let error) {
                    print(error.localizedDescription)
                    failure(error)
                }
            case .failure(let error):
                print(error.localizedDescription)
                failure(error)
            }
        }
    } //getReposList
    
    //============
    //MARK: getSingleTagItems
    //============
    static func getSingleTagItems(tagName: String, success: @escaping(_ response: [Items]) -> Void, failure: @escaping (_ error: Error) -> Void) {
        tagsProvider.request(
        .getSingleTagItems(tagName: tagName)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let response = try jsonDecoder.decode(SingleTagItemsModel.self, from: response.data)
                    success(response.items ?? [])
                } catch (let error) {
                    print(error.localizedDescription)
                    failure(error)
                }
            case .failure(let error):
                print(error.localizedDescription)
                failure(error)
            }
        }
    } // getSingleTagItems
}

