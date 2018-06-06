//
//  MainViewController.swift
//  Clapp
//
//  Created by mac on 18/11/2017.
//  Copyright © 2017 Clapp!. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class EventFeedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    var atTheEndOfTheContent = false
    
    var ref : DatabaseReference!
    var storageRef : StorageReference!
    
    let dataSource = DataSource.shared()
    var events : [SoftEvent]?
    
    var refHandle : DatabaseHandle!
    var eventSnapshots : [DataSnapshot] = []
    var numberOfSections = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configureDatabase()
        configureStorage()
        
        self.tableView.register(UINib.init(nibName: "EventCardHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "EventCardHeaderView")
        
        self.tabBarController?.delegate = self
        self.dataSource.delegate = self
        
        let query = ref.child("events").queryOrderedByKey()
        self.dataSource.loadEventList(query: query)
        //self.dataSource.addChildAddedListener(query: query)
        
    }
    
    func configureDatabase() {
        ref = Database.database().reference()
        refHandle = ref.child("events").observe(.childAdded) { (snapshot) in
            self.eventSnapshots.append(snapshot)
            self.tableView.beginUpdates()
            self.tableView.insertSections(IndexSet(integer: self.numberOfSections), with: .automatic)
            self.tableView.endUpdates()
            self.numberOfSections += 1
        }
    }
    
    func configureStorage() {
        storageRef = Storage.storage().reference()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.title = "Discovery"
        if self.events != nil {
            showTableView()
            updateEventList()
        } else {
            showLoader()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //        let fakeEvents : NSArray = data_helper.fakeEvents!.map {$0.toAnyObject()} as NSArray
        //        let fakeMembers : NSArray = data_helper.fakeMembers!.map {$0.toAnyObject()} as NSArray
        //        let fakeClubs : NSArray = data_helper.fakeClubs!.map {$0.toAnyObject()} as NSArray
        //        ref.child("events").setValue(fakeEvents)
        //        ref.child("members").setValue(fakeMembers)
        //        ref.child("clubs").setValue(fakeClubs)
    }
    
    func showTableView() {
        self.tableView.isHidden = false
        self.loader.isHidden = true
    }
    
    func showLoader() {
        self.tableView.isHidden = true
        self.loader.isHidden = false
    }
    
    func updateEventList() {
        if let count = self.events?.count {
            let query = ref.child("events").queryOrderedByKey().queryStarting(atValue: "\(count)")
            self.dataSource.updateEventList(query: query)
        }
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let detailedEventController = segue.destination as? EventDetailViewController
        
        if let tableCell = sender as? EventCardTableViewCell {
            let selectedIndexPath = self.tableView.indexPath(for: tableCell)
            detailedEventController?.eventID = events?[selectedIndexPath!.section].event_id!
        }
        
        if segue.identifier == "eventHeaderTapped" {
            let detailedClubController = segue.destination as? ClubDetailViewController
            let header = sender as! EventCardHeaderView
            detailedClubController?.clubID = header.club_id
        }
    }
    
    deinit {
        ref.child("events").removeObserver(withHandle: refHandle)
    }
}

extension EventFeedViewController : UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 0 {
            tabBarController.title = "Discovery"
        } else if tabBarController.selectedIndex == 1 {
            tabBarController.title = "Main Feed"
        }
    }
}

extension EventFeedViewController : DataSourceDelegate {
    
    func eventListLoaded(eventList: [SoftEvent]) {
        self.events = eventList
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.showTableView()
        }
    }
    
    func eventListUpdated(eventList: [SoftEvent]) {
        if !eventList.isEmpty {
            self.events?.append(contentsOf: eventList)
            DispatchQueue.main.async {
                if self.events != nil {
                    self.tableView.insertRows(at: [IndexPath(row : 0, section : self.events!.count - 1)], with: .automatic)
                }
                
            }
        }
    }
    
    func imageLoaded(data: Data, indexPath: IndexPath) {
        DispatchQueue.main.async {
            if let eventCard = self.tableView.cellForRow(at: indexPath) as? EventCardTableViewCell {
                eventCard.eventImage.image = UIImage(data: data)
            }
        }
    }
}

extension EventFeedViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        if bottomEdge >= scrollView.contentSize.height {
            atTheEndOfTheContent = true
        } else {
            atTheEndOfTheContent = false
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        var targetY : Int = Int(targetContentOffset.pointee.y)
        let (_, r) = targetY.quotientAndRemainder(dividingBy: 432)
        if velocity.y != 0 && !atTheEndOfTheContent {
            targetY -= r
            targetContentOffset.pointee = CGPoint(x: 0, y: targetY)
        }
    }
}

extension EventFeedViewController : UITableViewDataSource, UITableViewDelegate, EventCardHeaderViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return eventSnapshots.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "EventCardHeaderView") as! EventCardHeaderView
        
//        if let event = self.events?[section], let clubIconName = event.club_icon_name {
//            header.clubIcon.image = UIImage(named : clubIconName)
//            header.clubNameLabel.text = event.club_name
//            //header.eventPrivacyIcon.image = UIImage(named : )
//            header.eventPrivacyLabel.text = event.privacy?.toString()
//            header.club_id = event.club_id
//            header.delegate = self
//        }
        
        let eventSnapshot : DataSnapshot! = self.eventSnapshots[section]
        let value : NSDictionary = eventSnapshot.value as! NSDictionary
        let privacyAsString = value["privacy"] as? String ?? nil
        let clubID = value["clubid"] as? UInt32 ?? nil
        let clubName = value["clubName"] as? String ?? nil
        if let clubIconName = value["clubIcon"] as? String ?? nil {
            header.clubIcon.image = UIImage(named: clubIconName)
        }
        
        header.clubNameLabel.text = clubName
        header.eventPrivacyLabel.text = privacyAsString
        header.club_id = clubID
        header.delegate = self
        
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableCell = tableView.dequeueReusableCell(withIdentifier: "EventCardCell", for: indexPath) as! EventCardTableViewCell
        
        if let event = self.events?[indexPath.section] {
            reusableCell.eventTitleLabel.text = event.title
            reusableCell.eventDescriptionLabel.text = event.description
            reusableCell.eventDateLabel.text = event.dateString
            reusableCell.eventTimeLabel.text = event.timeString
            reusableCell.eventPlaceLabel.text = event.place
            reusableCell.setImage(modal: event)
        }
        
        return reusableCell
    }
    
    func didSelectEventCardHeader(header: EventCardHeaderView) {
        performSegue(withIdentifier: "eventHeaderTapped", sender: header)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .insert {
            tableView.insertSections([indexPath.row, indexPath.section], with: .fade)
        }
    }
}
