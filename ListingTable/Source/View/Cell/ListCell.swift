//
//  ListCell.swift
//  ListingTable
//
//  Created by Vikesh Prasad on 24/08/20.
//  Copyright © 2020 VikeshApp. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {

    var content: Content? {
        didSet{
            if let cont = content {
                self.textLabel?.text = cont.org.name + " - " + cont.property.name + " - " + cont.room.name
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
