//
//  CreateEventPageViewController.swift
//  Clapp
//
//  Created by mac on 08/12/2017.
//  Copyright © 2017 Clapp!. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class CreateEventPageViewController: UIPageViewController {
    
    fileprivate lazy var pages : [UIViewController] = {
        return [
            self.getViewController(withIdentifier: "CreateEventStepOne"),
            self.getViewController(withIdentifier: "CreateEventStepTwo"),
            self.getViewController(withIdentifier: "CreateEventStepThree"),
            self.getViewController(withIdentifier: "CreateEventStepFour")
        ]
    }()
    
    var ref : DatabaseReference!
    var storageRef : StorageReference!
    
    var event : SoftEvent? = SoftEvent()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        storageRef = Storage.storage().reference()
        
        self.dataSource = self
        self.delegate = self
        
        if let firstViewController = pages.first, let stepOneViewController = firstViewController as? CreateEventStepOneViewController {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
            stepOneViewController.delegate = self
        }
    }
    
    
    fileprivate func getViewController(withIdentifier identifier : String) -> UIViewController {
        return UIStoryboard(name : "Main", bundle : nil).instantiateViewController(withIdentifier: identifier)
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
}

extension CreateEventPageViewController : UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else { return pages.last }
        
        guard pages.count > previousIndex else { return nil }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.index(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else { return pages.first }
        
        guard pages.count > nextIndex else { return nil }
        
        return pages[nextIndex]
    }
    
}

extension CreateEventPageViewController : UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let sourceController = previousViewControllers.first as? CreateEventStepOneViewController {
            self.event?.title = sourceController.eventTitleField.text
            self.event?.event_type = Event.EventType.stringToEventType(typeAsString: sourceController.eventTypeField.text)
            self.event?.privacy = Event.EventPrivacy.stringToEventPrivacy(privacyAsString: sourceController.eventPrivacyField.text)
        } else if let sourceController = previousViewControllers.first as? CreateEventStepTwoViewController {
            let date = sourceController.eventDateTimePicker.date
            self.event?.dateString = DateTimeUtils.formatDate(date: date)
            self.event?.timeString = DateTimeUtils.formatTime(time: date)
            self.event?.place = sourceController.eventLocationField.text
            self.event?.description = sourceController.eventDescriptionField.text
        } else if let sourceController = previousViewControllers.first as? CreateEventStepThreeViewController {
            //self.event?.contacts_list must be set
            //self.event?.chatroom_id =
            //sourceController.chatGroupSwitch.isOn ? 1 : nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        if let targetController = pendingViewControllers.first as? CreateEventStepTwoViewController {
            targetController.delegate = self
        }
        else if let targetController = pendingViewControllers.first as? CreateEventStepThreeViewController {
            targetController.delegate = self
        } else if let targetController = pendingViewControllers.first as? CreateEventStepFourViewController {
            targetController.clubIcon.image = UIImage(named : (self.event?.club_icon_name)!)
            targetController.clubNameLabel.text = self.event?.club_name
            targetController.eventPrivacyLabel.text = self.event?.privacy?.toString()
            targetController.eventTitleLabel.text = self.event?.title
            targetController.eventDescriptionLabel.text = self.event?.description
            targetController.eventDateLabel.text = self.event?.dateString
            targetController.eventTimeLabel.text = self.event?.timeString
            targetController.eventPlaceLabel.text = self.event?.place
            targetController.delegate = self
        }
    }
}

extension CreateEventPageViewController : CreateEventStepOneViewControllerDelegate, CreateEventStepTwoViewControllerDelegate, CreateEventStepThreeViewControllerDelegate, CreateEventStepFourViewControllerDelegate {
    
    func done(imageData : Data?) {
        
        if let event = self.event {
            
            if let title = event.title, let imageData = imageData {
                let imageName = title.lowercased().replacingOccurrences(of: " ", with: "_")
                event.image_name = imageName
                let imageRef = storageRef.child("event_posters/\(imageName).png")
                let metadata = StorageMetadata()
                metadata.contentType = "image/png"
                let uploadTask = imageRef.putData(imageData, metadata: metadata)
                
                uploadTask.observe(.success) { (snapshot) in
                    print("upload succeeded")
                }
                
                uploadTask.observe(.failure) { (snapshot) in
                    if let error = snapshot.error as NSError? {
                        
                        switch StorageErrorCode(rawValue: error.code)! {
                            
                        case .unknown:
                            print("unknown failure")
                        case .objectNotFound:
                            print("object not found")
                        case .bucketNotFound:
                            print("bucket not found")
                        case .projectNotFound:
                            print("project not found")
                        case .quotaExceeded:
                            print("quota exceeded")
                        case .unauthenticated:
                            print("unauthenticated")
                        case .unauthorized:
                            print("unauthorized")
                        case .retryLimitExceeded:
                            print("retry limit exceeded")
                        case .nonMatchingChecksum:
                            print("non matching checksum")
                        case .downloadSizeExceeded:
                            print("download size exceeded")
                        case .cancelled:
                            print("cancelled")
                        }
                    }
                    
                }
            }
            
            ref.child("events").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
                let count = snapshot.childrenCount
                let id = UInt32(count)
                event.event_id = id
                self.ref.child("events/\(id)").setValue(event.toAnyObject())
            })
        }
        
        dismiss(animated: true)
    }
    
    func cancel() {
        dismiss(animated: true)
    }
}

