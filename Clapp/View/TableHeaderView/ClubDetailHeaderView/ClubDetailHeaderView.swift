//
//  ClubDetailHeaderView.swift
//  Clapp
//
//  Created by mac on 08/12/2017.
//  Copyright © 2017 Clapp!. All rights reserved.
//

import UIKit

class ClubDetailHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var clubIcon: UIImageView!
    @IBOutlet weak var clubFollowersCountLabel: UILabel!
    @IBOutlet weak var clubMembersCountLabel: UILabel!
    @IBOutlet weak var clubTotalEventsCountLabel: UILabel!
    @IBOutlet weak var clubUpcomingEventsLabel: UILabel!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
