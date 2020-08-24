//
//  NetworkResult.swift
//  ListingTable
//
//  Created by Vikesh Prasad on 24/08/20.
//  Copyright © 2020 VikeshApp. All rights reserved.
//

import Foundation

enum NetworkResult {
    case successDetail(ContentDetail)
    case success([Content])
    case failure(statusCode: HTTPStatusCodes, title: String, subTitle: String)
}

enum HTTPStatusCodes: Int, Equatable {
    case success = 200
    case badrequest = 400
}

enum HTTPError: String {
    case errorCode = "400"
    case errorMessage = "BAD REQUEST"
}
