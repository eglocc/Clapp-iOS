//
//  EventDetailHeaderView.swift
//  Clapp
//
//  Created by mac on 08/12/2017.
//  Copyright © 2017 Clapp!. All rights reserved.
//

import UIKit
import FirebaseStorage

protocol EventDetailHeaderViewDelegate {
    func eventAddedToCalendar(header : EventDetailHeaderView)
}

class EventDetailHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var clubIcon: UIImageView!
    @IBOutlet weak var clubNameLabel: UILabel!
    @IBOutlet weak var eventPrivacyIcon: UIImageView!
    @IBOutlet weak var eventPrivacyLabel: UILabel!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var eventPlaceLabel: UILabel!
    @IBOutlet weak var addToCalendarButton: UIButton!
    @IBOutlet weak var imageLoader: UIActivityIndicatorView!
    
    var storageRef : StorageReference!
    
    var delegate : EventDetailHeaderViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        storageRef = Storage.storage().reference()
    }
    
    func showLoader() {
        self.imageLoader.isHidden = false
        self.eventImage.isHidden = true
    }
    
    func showImage() {
        self.imageLoader.isHidden = true
        self.eventImage.isHidden = false
    }
    
    @IBAction func eventAddedToCalendar(_ sender: Any) {
        self.delegate?.eventAddedToCalendar(header: self)
    }
}

extension EventDetailHeaderView : HasDownloadableImage {
    func setImage(modal: Any?) {
        
        if let event = modal as? SoftEvent, let imageName = event.image_name {
            if let imageData = event.imageData {
                self.eventImage.image = UIImage(data : imageData)
                self.showImage()
            } else {
                self.showLoader()
                storageRef.child("event_posters/\(imageName).png").downloadURL(completion: { (url, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                        return
                    }
                    
                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                        
                        if error != nil {
                            print(error!.localizedDescription)
                            return
                        }
                        
                        guard let data = data, let image = UIImage(data : data) else { return }
                        
                        DispatchQueue.main.async {
                            event.imageData = data
                            self.eventImage.image = image
                            self.showImage()
                        }
                        
                    }).resume()
                })
            }
        }
        
    }
    
    
}
