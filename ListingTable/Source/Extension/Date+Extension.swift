//
//  Date+Extension.swift
//  ListingTable
//
//  Created by Vikesh Prasad on 24/08/20.
//  Copyright © 2020 VikeshApp. All rights reserved.
//

import Foundation
extension Date {
    var timeStamp : Int64! {
        return Int64(self.timeIntervalSince1970)
    }
}
