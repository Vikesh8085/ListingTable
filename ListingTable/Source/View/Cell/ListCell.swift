//
//  ListCell.swift
//  ListingTable
//
//  Created by Vikesh Prasad on 24/08/20.
//  Copyright © 2020 VikeshApp. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {

    var content: Content! {
        didSet{
            self.textLabel?.text = content.org.name + " - " + content.property.name + " - " + content.room.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
