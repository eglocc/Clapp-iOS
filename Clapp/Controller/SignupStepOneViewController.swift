//
//  SignupViewController.swift
//  Clapp
//
//  Created by mac on 18/11/2017.
//  Copyright © 2017 Clapp!. All rights reserved.
//

import UIKit

class SignupStepOneViewController: UIViewController {
    
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Account Information"
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        self.title = "Back"
    }
}
