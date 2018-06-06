//
//  ViewController.swift
//  Clapp
//
//  Created by mac on 18/11/2017.
//  Copyright © 2017 Clapp!. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import GoogleSignIn

class AuthViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var continueAsGuestButton: UIButton!
    
    var ref : DatabaseReference!
    
    var handle : AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBar.isHidden = true
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signInSilently()
        ref = Database.database().reference()
        
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            
            if user != nil {
                self.performSegue(withIdentifier: "userAuthenticated", sender: self)
                self.ref.child("users/\(user!.uid)/uid").setValue(user!.uid)
            }
        })
    }
    
    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}

