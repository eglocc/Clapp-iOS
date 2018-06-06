//
//  ClubDetailViewController.swift
//  Clapp
//
//  Created by mac on 04/12/2017.
//  Copyright © 2017 Clapp!. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ClubDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    var ref : DatabaseReference!
    
    let dataSource = DataSource.shared()
    
    var clubID : UInt32?
    var club : SoftClub?
    var clubEvents : [SoftEvent]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.register(UINib.init(nibName: "ClubDetailHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "ClubDetailHeaderView")
        
        ref = Database.database().reference()
        
        if let club_id = clubID, let club = dataSource.clubDataDictionary[club_id] {
            self.club = club
            self.clubEvents = club.events
        }
        
        self.dataSource.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if club != nil {
            showTableView()
        } else {
            showLoader()
            let query = ref.child("clubs/\(self.clubID!)")
            dataSource.loadClubDetail(query: query)
            
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
        
        if let detailedEventController = segue.destination as? EventDetailViewController, let tableCell = sender as? EventCardTableViewCell {
            let selectedIndexPath = self.tableView.indexPath(for: tableCell)
            detailedEventController.eventID = clubEvents?[selectedIndexPath!.row].event_id
        }
        
        if let createEventPagerController = segue.destination as? CreateEventPageViewController {
            createEventPagerController.event?.club_id = club?.club_id
            createEventPagerController.event?.club_name = club?.name
            createEventPagerController.event?.club_icon_name = club?.icon_name
        }
    }
 
}

extension ClubDetailViewController : DataSourceDelegate {
    func clubDetailLoaded(club: SoftClub) {
        self.club = club
        self.clubEvents = club.events
        DispatchQueue.main.async {
            self.title = club.name
            self.tableView.reloadData()
            self.showTableView()
        }
    }
}

extension ClubDetailViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ClubDetailHeaderView") as? ClubDetailHeaderView
        
        if let club = club, let clubIcon = club.icon_name{
            header?.clubIcon.image = UIImage(named : clubIcon)
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let club = club, let clubEvents = club.events {
            return clubEvents.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableCell = tableView.dequeueReusableCell(withIdentifier: "EventCardCell", for: indexPath) as! EventCardTableViewCell
        
        if let event = clubEvents?[indexPath.row] {
            reusableCell.eventTitleLabel.text = event.title
            reusableCell.eventDescriptionLabel.text = event.description
            reusableCell.setImage(modal: event)
            reusableCell.eventDateLabel.text = event.dateString
            reusableCell.eventTimeLabel.text = event.timeString
            reusableCell.eventPlaceLabel.text = event.place
        }
        
        return reusableCell
    }
    
}
