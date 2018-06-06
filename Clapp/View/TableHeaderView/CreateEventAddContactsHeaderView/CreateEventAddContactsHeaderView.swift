//
//  CreateEventAddContactsHeaderView.swift
//  Clapp
//
//  Created by Ergiz Work on 22/12/2017.
//  Copyright © 2017 Clapp!. All rights reserved.
//

import UIKit

protocol CreateEventAddContactsHeaderViewDelegate {
    func userDidCancel()
}

class CreateEventAddContactsHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var delegate : CreateEventAddContactsHeaderViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func userDidCancel(_ sender: Any) {
        self.delegate?.userDidCancel()
    }
}
