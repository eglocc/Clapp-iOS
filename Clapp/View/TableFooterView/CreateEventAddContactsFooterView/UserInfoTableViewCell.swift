//
//  UserInfoTableViewCell.swift
//  Clapp
//
//  Created by Ergiz Work on 23/12/2017.
//  Copyright © 2017 Clapp!. All rights reserved.
//

import UIKit

class UserInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var userInfoKey: UILabel!
    @IBOutlet weak var userInfoValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
