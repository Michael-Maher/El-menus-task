//
//  HomeProvider.swift
//  Food for all
//
//  Created by Michael Maher on 2/5/20.
//  Copyright © 2020 MichaelMaher. All rights reserved.
//

import Foundation
import Moya
import Alamofire

enum TagsProvider {
    case getTagsList(page: Int)
    case getSingleTagItems(tagName: String)
}

extension TagsProvider: CachePolicyGettable , TargetType {
    var cachePolicy: URLRequest.CachePolicy {
        return .returnCacheDataElseLoad
    }
    
    
    //============
    //MARK: Base URL
    //============
    var baseURL: URL {
        guard let baseUrl = URL(string: "https://elmenus-task.getsandbox.com") else {           fatalError("base URL could not be configured")
        }
        
        return baseUrl
    }
    
    //============
    //MARK: Path
    //============
    var path: String {
        switch self {
        case .getTagsList(let page):
            return "tags/\(page)"
        case .getSingleTagItems(let tagName):
            return "items/\(tagName)"
        }
    }
    
    //============
    //MARK: Sample Data
    //============
    var sampleData: Data {
        return Data()
    }
    
    //============
    //MARK: Method
    //============
    var method: Moya.Method {
        return .get
    }
    
    //==========
    //MARK: Task
    //==========
    var task: Task {
        return Task.requestPlain
    }
    
    //==========
    //MARK: Validation Type
    //==========
    var validationType: ValidationType {
        return .successAndRedirectCodes
    }
    
    //=============
    //MARK: Headers
    //=============
    var headers: [String: String]? {
        let header = ["Accept": "application/json"]
        return header
    } // headers
}

