//
//  ListingModel.swift
//  ListingTable
//
//  Created by Vikesh Prasad on 24/08/20.
//  Copyright © 2020 VikeshApp. All rights reserved.
//

import Foundation

struct ListingModel: Decodable {
    let success: Bool
    let data: [Content]
}

struct Content: Decodable {
    let org: Org
    let property: Org
    let room: Org
}

struct Org: Decodable {
    let id: Int
    let name: String
}
