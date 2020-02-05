//
//  NetworkManger.swift
//  Food for all
//
//  Created by Michael Maher on 1/9/20.
//  Copyright © 2020 Michael Maher. All rights reserved.
//

import Foundation

struct TagsModel : Decodable {
	let tags : [Tags]?
}


struct Tags : Decodable {
    let tagName : String?
    let photoURL : String?
}
