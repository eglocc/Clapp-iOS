//
//  ClappersTableViewCell.swift
//  Clapp
//
//  Created by mac on 06/12/2017.
//  Copyright © 2017 Clapp!. All rights reserved.
//

import UIKit

class ClappersTableViewCell: UITableViewCell {

    @IBOutlet weak var clapperImage: UIImageView!
    @IBOutlet weak var clapperNameLabel: UILabel!
    @IBOutlet weak var clapperTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
