//
//  EventCardHeaderView.swift
//  Clapp
//
//  Created by mac on 07/12/2017.
//  Copyright © 2017 Clapp!. All rights reserved.
//

import UIKit

protocol EventCardHeaderViewDelegate{
    func didSelectEventCardHeader(header : EventCardHeaderView)
}

class EventCardHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var clubIcon: UIImageView!
    @IBOutlet weak var clubNameLabel: UILabel!
    @IBOutlet weak var eventPrivacyIcon: UIImageView!
    @IBOutlet weak var eventPrivacyLabel: UILabel!
    
    var delegate : EventCardHeaderViewDelegate?
    var club_id : UInt32?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func didSelectHeader(sender : EventCardHeaderView) {
        self.delegate?.didSelectEventCardHeader(header: self)
    }
    
}
