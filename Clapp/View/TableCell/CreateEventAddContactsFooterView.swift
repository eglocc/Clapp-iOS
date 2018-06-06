//
//  CreateEventAddContactsFooterView.swift
//  Clapp
//
//  Created by Ergiz Work on 22/12/2017.
//  Copyright © 2017 Clapp!. All rights reserved.
//

import UIKit

protocol CreateEventAddContactsFooterViewDelegate {
    
}

class CreateEventAddContactsFooterView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var chatSwitch: UISwitch!
    
    var delegate : CreateEventAddContactsFooterViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
