//
//  ListViewController.swift
//  ListingTable
//
//  Created by Vikesh Prasad on 24/08/20.
//  Copyright © 2020 VikeshApp. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController, Storyboarded {

    var coordinator: ListCoordinator?
    var listViewModel: ListViewModel?

    lazy var refreshController: UIRefreshControl = {
          let refreshControl = UIRefreshControl()
          refreshControl.addTarget(self, action:
                       #selector(self.handleRefresh(_:)),
                                   for: UIControl.Event.valueChanged)
          refreshControl.tintColor = UIColor.gray
          
          return refreshControl
      }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        fetchData()
    }
    
    private func setUI() {
        self.title = "List"
        self.tableView.register(ListCell.self)
        self.tableView.addSubview(self.refreshController)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        fetchData()
    }
    
    private func fetchData() {
        
        self.listViewModel = ListViewModel(listViewController: self)
        if let viewModel = self.listViewModel {
            viewModel.completionHandler = { (success, error) in
                if success {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.refreshController.endRefreshing()
                    }
                }
            }
            viewModel.getList()
        }
    }

}

extension ListViewController {
    
    // MARK: - TableView Data Source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listViewModel?.listArray?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(type: ListCell.self, for: indexPath)
        cell.content = self.listViewModel?.listArray?[indexPath.row]
        return cell
    }
    
    // MARK: - TableView Delegate
    /**
         Navigation is done via MainCoordinator
    */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let content = self.listViewModel?.listArray?[indexPath.row] {
            coordinator?.showDetailWith(content: content)
        }
    }
}
