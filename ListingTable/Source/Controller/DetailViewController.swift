//
//  DetailViewController.swift
//  ListingTable
//
//  Created by Vikesh Prasad on 24/08/20.
//  Copyright © 2020 VikeshApp. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var lblMac: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!

    
    var content: Content?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIManager.shared.fetchDetail(id: String(content?.room.id ?? 0)){ (result) in
            switch result {
            case let  .failure(_, title, subTitle):
                print(title)
            case let .successDetail(content):
                DispatchQueue.main.async {
                    self.lblMac.text = content.MAC
                    self.lblName.text = content.name
                    self.lblDescription.text = content.description
                }
                
             case let .success(content):
                print(content)
            }
        }
        
    }
}
