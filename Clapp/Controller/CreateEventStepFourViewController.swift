//
//  CreateEventStepThreeViewController.swift
//  Clapp
//
//  Created by mac on 08/12/2017.
//  Copyright © 2017 Clapp!. All rights reserved.
//

import UIKit

protocol CreateEventStepFourViewControllerDelegate {
    func done(imageData : Data?)
    func cancel()
}

class CreateEventStepFourViewController: UIViewController {

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
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    
    
    var delegate : CreateEventStepFourViewControllerDelegate?
    
    var imageData : Data?
    
    @IBAction func userWantsToSelectAnImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true) {
            
        }
    }
    
    @IBAction func userWantsToSubmitEvent(_ sender: Any) {
        delegate?.done(imageData: imageData)
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

extension CreateEventStepFourViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let imageTaken = info[UIImagePickerControllerEditedImage] as? UIImage
        
        self.eventImage.contentMode = .scaleAspectFit
        self.eventImage.image = imageTaken
        
        self.imageData = UIImagePNGRepresentation(imageTaken!)
        
        
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true)
    }
}
