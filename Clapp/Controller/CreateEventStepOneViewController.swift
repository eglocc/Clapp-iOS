//
//  CreateEventStepOneViewController.swift
//  Clapp
//
//  Created by mac on 08/12/2017.
//  Copyright © 2017 Clapp!. All rights reserved.
//

import UIKit

protocol CreateEventStepOneViewControllerDelegate {
    func cancel()
}

class CreateEventStepOneViewController: UIViewController {

    @IBOutlet weak var eventTitleField: UITextField!
    @IBOutlet weak var eventTypeField: UITextField!
    @IBOutlet weak var eventTypePicker: UIPickerView!
    @IBOutlet weak var eventPrivacyField: UITextField!
    @IBOutlet weak var eventPrivacyPicker: UIPickerView!
    
    var delegate : CreateEventStepOneViewControllerDelegate?
    
    let eventTypes = ["-"] + Event.EventType.asStringArray()
    let eventPrivacies = ["-"] + Event.EventPrivacy.asStringArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func userDidCancel(_ sender: Any) {
        delegate?.cancel()
    }
    
}

extension CreateEventStepOneViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.accessibilityIdentifier == "eventTypePicker" {
            return eventTypes.count
        } else { return eventPrivacies.count }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.accessibilityIdentifier == "eventTypePicker" {
            return eventTypes[row]
        } else { return eventPrivacies[row] }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.accessibilityIdentifier == "eventTypePicker" {
            if row == 0 {
                self.eventTypeField.text = nil
            } else {
                self.eventTypeField.text = eventTypes[row]
            }
        } else {
            if row == 0 {
                self.eventPrivacyField.text = nil
            } else {
                self.eventPrivacyField.text = eventPrivacies[row]
            }
        }
    }
}
