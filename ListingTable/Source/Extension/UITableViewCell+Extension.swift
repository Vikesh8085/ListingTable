//
//  UITableViewCell+Extension.swift
//  ListingTable
//
//  Created by Vikesh Prasad on 24/08/20.
//  Copyright © 2020 VikeshApp. All rights reserved.
//

import UIKit

// MARK: - declare dequeue reusable Indentifier protocol
protocol ReusableIdentifier: class {
    static var defaultIdentifier: String { get }
}

// MARK: - extend dequeue reusable Indentifier protocol to return the name of the Cell
extension ReusableIdentifier where Self: UIView {
    static var defaultIdentifier: String {
        return NSStringFromClass(self)
    }
}

// MARK: - UITable view cell extends to conform the protocol
extension UITableViewCell: ReusableIdentifier { }
