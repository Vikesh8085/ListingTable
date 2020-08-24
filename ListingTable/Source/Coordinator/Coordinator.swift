//
//  Coordinator.swift
//  ListingTable
//
//  Created by Vikesh Prasad on 24/08/20.
//  Copyright © 2020 VikeshApp. All rights reserved.
//

import UIKit
protocol Coordinator {
    var childCoordinators:[Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start()
}
