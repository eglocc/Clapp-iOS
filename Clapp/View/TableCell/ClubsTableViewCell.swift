//
//  ClubItemTableViewCell.swift
//  Clapp
//
//  Created by mac on 04/12/2017.
//  Copyright © 2017 Clapp!. All rights reserved.
//

import UIKit

class ClubsTableViewCell: UITableViewCell {

    @IBOutlet weak var clubIcon: UIImageView!
    @IBOutlet weak var clubNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
