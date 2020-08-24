//
//  StoryBoard+Extension.swift
//  ListingTable
//
//  Created by Vikesh Prasad on 24/08/20.
//  Copyright © 2020 VikeshApp. All rights reserved.
//

import UIKit
protocol Storyboarded {
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self {
        let className = String(describing: self)
        let storyBoard = UIStoryboard(name: StoryboardConstant.main, bundle: Bundle.main)
        return storyBoard.instantiateViewController(withIdentifier: className) as! Self
    }
}
