//
//  UITableView+Extension.swift
//  ListingTable
//
//  Created by Vikesh Prasad on 24/08/20.
//  Copyright © 2020 VikeshApp. All rights reserved.
//

import UIKit
// MARK: - UITable view extends functionality to register the cell identifier based on the name of the class and return the cell with specified identifier
extension UITableView {
    func register<T:UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: T.defaultIdentifier)
    }

    func dequeueReusableCell<T: UITableViewCell>(type: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: type.defaultIdentifier, for: indexPath) as? T else {
            fatalError("unable to dequeue cell")
        }
        return cell
    }
}
