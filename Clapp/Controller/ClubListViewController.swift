//
//  ClubSearchViewController.swift
//  Clapp
//
//  Created by mac on 04/12/2017.
//  Copyright © 2017 Clapp!. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ClubListViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    var ref : DatabaseReference!
    
    let dataSource = DataSource.shared()
    var searchActive : Bool = false
    var clubs : [SoftClub]?
    var filtered : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.dataSource.delegate = self
        ref = Database.database().reference()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.title = "Club Search"
        if self.clubs != nil {
            showTableView()
        } else {
            showLoader()
            let query = ref.child("clubs").queryOrdered(byChild: "name")
            dataSource.loadClubList(query: query)
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let detailedClubController = segue.destination as? ClubDetailViewController
        
        if let tableCell = sender as? ClubsTableViewCell, let clubName = tableCell.clubNameLabel.text {
            let clubID = dataSource.clubDictionary[clubName]
            detailedClubController?.clubID = clubID
        }
    }

}

extension ClubListViewController : DataSourceDelegate {
    func clubListLoaded(clubList: [SoftClub]) {
        self.clubs = clubList
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.showTableView()
        }
    }
}

extension ClubListViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filtered.count
        }
        if let clubs = clubs {
            return clubs.count
        } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableCell = tableView.dequeueReusableCell(withIdentifier: "ClubItemCell", for: indexPath) as! ClubsTableViewCell
        
        if searchActive {
            filtered.sort {$0 < $1}
            let filteredClubName = filtered[indexPath.row]
            let filteredClubID : UInt32 = (dataSource.clubDictionary[filteredClubName])!
            if let club = dataSource.clubDataDictionary[filteredClubID], let iconName = club.icon_name {
                reusableCell.clubIcon.image = UIImage(named : iconName)
                reusableCell.clubNameLabel.text = club.name
            }
        } else {
            if let club = clubs?[indexPath.row], let iconName = club.icon_name {
                reusableCell.clubIcon.image = UIImage(named : iconName)
                reusableCell.clubNameLabel.text = club.name
            }
        }
        
        return reusableCell
    }
}

extension ClubListViewController : UISearchBarDelegate {
    
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
        filtered = dataSource.clubNames.filter { (text) -> Bool in
            let tmp : NSString = text as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        }
        
        if filtered.count == 0 { searchActive = false }
        else { searchActive = true }
        self.tableView.reloadData()
    }
}
