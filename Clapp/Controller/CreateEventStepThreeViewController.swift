//
//  CreateEventStepThreeViewController.swift
//  Clapp
//
//  Created by mac on 09/12/2017.
//  Copyright © 2017 Clapp!. All rights reserved.
//

import UIKit
import FirebaseDatabase

protocol CreateEventStepThreeViewControllerDelegate {
    func cancel()
}

class CreateEventStepThreeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    var ref : DatabaseReference!
    
    var delegate : CreateEventStepThreeViewControllerDelegate?
    
    let dataSource = DataSource.shared()
    
    var members : [SoftUser]?
    
    var searchActive : Bool = false
    var filtered : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.register(UINib.init(nibName: "CreateEventAddContactsHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "CreateEventAddContactsHeader")
        self.tableView.register(UINib.init(nibName: "CreateEventAddContactsFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "CreateEventAddContactsFooter")
        
        ref = Database.database().reference()
        self.dataSource.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.members != nil {
            showTableView()
        } else {
            showLoader()
            let query = ref.child("members").queryOrdered(byChild: "name")
            dataSource.loadMemberList(query: query)
        }
    }
    
    func showTableView() {
        self.tableView.isHidden = false
        self.loader.isHidden = true
    }
    
    func showLoader() {
        self.tableView.isHidden = true
        self.loader.isHidden = false
    }
    
    @IBAction func userDidCancel(_ sender: Any) {
        delegate?.cancel()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CreateEventStepThreeViewController : DataSourceDelegate {
    
    func memberListLoaded(memberList: [SoftUser]) {
        self.members = memberList
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.showTableView()
        }
    }
}

extension CreateEventStepThreeViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchActive { return filtered.count }
        
        if let members = members {
            return members.count
        } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableCell = tableView.dequeueReusableCell(withIdentifier: "ClapperItemCell", for: indexPath) as! ClappersTableViewCell
        
        if searchActive {
            let filteredMemberName = filtered[indexPath.row]
            let filteredMemberID : UInt32 = (dataSource.memberDictionary[filteredMemberName])!
            if let clapper = dataSource.memberDataDictionary[filteredMemberID] {
                reusableCell.clapperNameLabel.text = clapper.name
            }
        } else {
            if let clapper = members?[indexPath.row] {
                reusableCell.clapperNameLabel.text = clapper.name
            }
        }

        return reusableCell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CreateEventAddContactsHeader") as? CreateEventAddContactsHeaderView {
            header.delegate = self
            header.searchBar.delegate = self
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CreateEventAddContactsFooter") as? CreateEventAddContactsFooterView {
            footer.delegate = self
            return footer
        }
        return nil
    }
}

extension CreateEventStepThreeViewController : UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = dataSource.memberNames.filter { (text) -> Bool in
            let tmp : NSString = text as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        }
        
        if filtered.count == 0 { searchActive = false } 
        else { searchActive = true }
        self.tableView.reloadData()
    }
}

extension CreateEventStepThreeViewController : CreateEventAddContactsHeaderViewDelegate, CreateEventAddContactsFooterViewDelegate {
    
    func userDidCancel() {
        delegate?.cancel()
    }
    
}


