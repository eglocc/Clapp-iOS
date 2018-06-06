//
//  EventDetailViewController.swift
//  Clapp
//
//  Created by mac on 06/12/2017.
//  Copyright © 2017 Clapp!. All rights reserved.
//

import UIKit
import FirebaseDatabase

class EventDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    var ref : DatabaseReference!
    
    var dataSource = DataSource.shared()
    
    var eventID : UInt32?
    var event : SoftEvent?
    var members : [SoftUser]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.register(UINib.init(nibName: "EventDetailHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "EventDetailHeaderView")
        
        ref = Database.database().reference()
        
        self.dataSource.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if event != nil && members != nil {
            showTableView()
        } else {
            showLoader()
            let eventQuery = ref.child("events/\(self.eventID!)")
            let membersQuery = ref.child("members").queryOrdered(byChild: "name")
            dataSource.loadEventDetail(query: eventQuery)
            dataSource.loadMemberList(query: membersQuery)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension EventDetailViewController : DataSourceDelegate {
    
    func eventDetailLoaded(event: SoftEvent) {
        self.event = event
        DispatchQueue.main.async {
            self.tableView.reloadData()
            if self.members != nil {
                self.showTableView()
            }
        }
    }
    
    func memberListLoaded(memberList: [SoftUser]) {
        self.members = memberList
        DispatchQueue.main.async {
            self.tableView.reloadData()
            if self.event != nil {
                self.showTableView()
            }
        }
    }
}

extension EventDetailViewController : UITableViewDataSource, UITableViewDelegate, EventDetailHeaderViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 500
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "EventDetailHeaderView") as! EventDetailHeaderView
        
        if let event = event, let clubIcon = event.club_icon_name, let eventImage = event.image_name {
            header.clubIcon.image = UIImage(named : clubIcon)
            header.clubNameLabel.text = event.club_name
            header.eventPrivacyLabel.text = event.privacy?.toString()
            header.eventTitleLabel.text = event.title
            header.eventDescriptionLabel.text = event.description
            header.setImage(modal: event)
            header.eventDateLabel.text = event.dateString
            header.eventTimeLabel.text = event.timeString
            header.eventPlaceLabel.text = event.place
            header.delegate = self
        }
        
        return header
    }
    
    func eventAddedToCalendar(header: EventDetailHeaderView) {
        print("added to calendar")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let members = members {
            return members.count
        } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableCell = tableView.dequeueReusableCell(withIdentifier: "ClapperItemCell", for: indexPath) as! ClappersTableViewCell
        
        if let clapper = members?[indexPath.row] {
            reusableCell.clapperNameLabel.text = clapper.name
        }
        
        return reusableCell
    }
    
}
