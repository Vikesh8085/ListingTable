//
//  ListViewModel.swift
//  ListingTable
//
//  Created by Vikesh Prasad on 24/08/20.
//  Copyright © 2020 VikeshApp. All rights reserved.
//

import UIKit
import Toast_Swift

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
                if let completion = self.completionHandler {
                    completion(false,nil)
                    DispatchQueue.main.async {
                        self.showError(title: title, message: subTitle)
                    }
                }
            case let .success(photo):
                self.listArray = photo
                if let completion = self.completionHandler {
                    completion(true,nil)
                }
            case let .successDetail(detail):
                print(detail)
            }
        }
        
        if !ReachabilityWrapper.shared.isNetworkAvailable() {
            self.showToast(InternetAvailability.message.rawValue)
        }
    }
    
    func showToast(_ message: String) {
        self.listViewController?.tableView.makeToast(message)
    }
    
    private func showError(title:String, message: String) {
         self.listViewController?.showAlert(title: title, message: message, preferredStyle: .alert, alertActions: [(AlertAction.okAction.rawValue, .default)]) { (index) in
         }
     }
     
}
