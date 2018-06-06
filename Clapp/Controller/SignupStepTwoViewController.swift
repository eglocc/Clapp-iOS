//
//  SignupStepTwoViewController.swift
//  Clapp
//
//  Created by mac on 19/11/2017.
//  Copyright © 2017 Clapp!. All rights reserved.
//

import UIKit

class SignupStepTwoViewController: UIViewController {
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var genderPicker: UIPickerView!
    @IBOutlet weak var dobPicker: UIDatePicker!
    
    let genders : [String] = User.Gender.asStringArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.delegate = self
        self.title = "Personal Information"
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

extension SignupStepTwoViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            self.genderField.text = nil
            self.genderField.placeholder = "Your gender"
        } else {
            self.genderField.text = genders[row]
        }
    }
}

extension SignupStepTwoViewController : UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is SignupStepOneViewController {
            viewController.title = "Account Information"
        }
    }
}
