//
//  ListViewModel.swift
//  ListingTable
//
//  Created by Vikesh Prasad on 24/08/20.
//  Copyright © 2020 VikeshApp. All rights reserved.
//

import UIKit

class ListViewModel {
    
    private var listViewController: ListViewController?
    var listArray: [Content]?
    public var completionHandler: ((Bool, Error?) -> (Void))?

    init(listViewController: ListViewController) {
        self.listViewController = listViewController
    }
    
    func getList() {
        
        APIManager.shared.fetchData { (result) in
            switch result {
            case let  .failure(_, title, subTitle):
                print(title)
            case let .success(photo):
                self.listArray = photo
                if let completion = self.completionHandler {
                    completion(true,nil)
                }
            case let .successDetail(detail):
                print(detail)
            }
        }
    }
}
