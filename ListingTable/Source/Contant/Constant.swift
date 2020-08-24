//
//  Constant.swift
//  ListingTable
//
//  Created by Vikesh Prasad on 24/08/20.
//  Copyright © 2020 VikeshApp. All rights reserved.
//

/**
  We are creating Enum to use inside Target
*/
/// Storyboard name
struct StoryboardConstant {
   static let main = "Main"
   static let launch = "LaunchScreen"
}

struct APIManagerConstant {
    static let baseUrl = "https://api.snglty.com"
}

struct APIEndPoint {
    static let listing = "/v1/test/roomsList"
    static let detail = "/v1/test/lockDetails"
}

/// Alert Buttons
enum AlertAction: String {
    case okAction = "OK"
    case cancelAction = "Cancel"
    case retryAction = "Retry"
    case item2 = "2"
    case item3 = "3"
    case item4 = "4"
}

enum InternetAvailability: String {
    case title = "Internet"
    case message = "Internet not Avaiable"
}
