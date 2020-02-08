//
//  CashingManger.swift
//  Repos manger
//
//  Created by Michael Maher on 1/13/20.
//  Copyright © 2020 Michael Maher. All rights reserved.
//

import Foundation
import Moya

protocol CachePolicyGettable {
    var cachePolicy: URLRequest.CachePolicy { get }
}

class LocalDataHandler: PluginType {
    
    static let shared = LocalDataHandler()
    
    //=======================
    //MARK:-  API caching
    //=======================
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        if let cacheableTarget = target as? CachePolicyGettable {
            var mutableRequest = request
            mutableRequest.cachePolicy = cacheableTarget.cachePolicy
            return mutableRequest
        }
        return request
    }
    
    func clearCache(provider: MoyaProvider<TagsProvider>, urlRequests: [URLRequest] = []) {
           guard let urlCache = provider.manager.session.configuration.urlCache else { return }
           if urlRequests.isEmpty {
               urlCache.removeAllCachedResponses()
           } else {
               urlRequests.forEach { urlCache.removeCachedResponse(for: $0) }
           }
       }
    
}

